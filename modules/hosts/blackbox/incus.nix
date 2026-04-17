{ den, ... }:
{
  den.aspects.incus = den.lib.perHost {
    nixos =
      { lib, pkgs, ... }:
      {
        virtualisation = {
          kvmgt.enable = lib.mkDefault true;
          incus = {
            enable = true;
            ui.enable = true;
            preseed = {
              config = {
                "core.https_address" = ":8443";
              };
              networks = [
                {
                  name = "internalbr0";
                  type = "bridge";
                  description = "Internal/NATted bridge";
                  config = {
                    "ipv4.address" = "auto";
                    "ipv4.nat" = "true";
                    "ipv6.address" = "auto";
                    "ipv6.nat" = "true";
                  };
                }
              ];
              profiles = [
                {
                  name = "default";
                  description = "Default Incus Profile";
                  devices = {
                    root = {
                      path = "/";
                      pool = "default";
                      type = "disk";
                    };
                    data = {
                      path = "/mnt/data";
                      pool = "default";
                      source = "data";
                      type = "disk";
                    };
                  };
                }
                {
                  name = "bridged";
                  description = "Instances bridged to LAN";
                  devices = {
                    eth0 = {
                      name = "eth0";
                      nictype = "bridged";
                      parent = "br0";
                      type = "nic";
                    };
                  };
                }
                {
                  name = "nat";
                  description = "Internal NAT'd network";
                  devices = {
                    eth0 = {
                      name = "eth0";
                      network = "internalbr0";
                      type = "nic";
                    };
                  };
                }
                {
                  name = "docker-configs";
                  description = "Docker compose configs from dotfiles";
                  devices = {
                    docker-dotfiles = {
                      path = "/opt/docker";
                      shift = "true";
                      source = "/home/sam/dotfiles/configs/docker";
                      type = "disk";
                    };
                  };
                }
                {
                  name = "pool";
                  description = "Access to /mnt/pool";
                  config = {
                    "raw.idmap" = ''
                      gid 1500 0
                    '';
                  };
                  devices = {
                    pool = {
                      path = "/mnt/pool";
                      source = "/mnt/pool";
                      type = "disk";
                    };
                  };
                }
                {
                  name = "gpu";
                  description = "Intel GPU passthrough";
                  devices = {
                    gpu-1 = {
                      gputype = "physical";
                      pci = "0000:00:02.0";
                      type = "gpu";
                    };
                  };
                }
              ];
              storage_pools = [
                {
                  name = "default";
                  driver = "zfs";
                  config = {
                    # source = "/dev/nvme1n1"; # if starting from an unpartitioned disk
                    source = "incus"; # after disk is setup
                    "zfs.pool_name" = "incus";
                  };
                }
              ];
              storage_volumes = [
                {
                  name = "data";
                  pool = "default";
                  type = "custom";
                  content_type = "filesystem";
                  config = {
                    "security.shifted" = "true";
                    "snapshots.expiry" = "5d";
                    "snapshots.schedule" = "@daily";
                  };
                }
              ];
            };
          };
        };

        environment.systemPackages = [
          # Shell script to create incus lxc image from nixos config with option to auto deploy from template
          (pkgs.writeShellScriptBin "nixos-update-lxc-image" ''
            HOST=$1
            if [ -z "$HOST" ]; then echo "Usage: nixos-update-lxc-image <hostname> [--deploy]"; exit 1; fi

            METADATA=$(nix build ".#nixosConfigurations.$HOST.config.system.build.metadata" --no-link --print-out-paths)
            SQUASHFS=$(nix build ".#nixosConfigurations.$HOST.config.system.build.squashfs" --no-link --print-out-paths)
            incus image delete "nixos/custom/$HOST" || true
            incus image import --alias "nixos/custom/$HOST" "$METADATA"/tarball/*.tar.xz "$SQUASHFS"/*.squashfs

            if [ "''${2:-}" = "--deploy" ]; then
              TEMPLATE="$(git rev-parse --show-toplevel)/configs/incus/''${HOST}.yaml"

              if [ ! -f "$TEMPLATE" ]; then
                echo "No template found at $TEMPLATE"
                exit 1
              fi

              if incus info "$HOST" &>/dev/null; then
                echo "Stopping and deleting existing instance $HOST..."
                incus stop "$HOST" --force 2>/dev/null || true
                incus delete "$HOST"
              fi

              echo "Launching $HOST from nixos/custom/$HOST..."
              incus launch "nixos/custom/$HOST" "$HOST" < "$TEMPLATE"
            fi
          '')
        ];

        # allow host to map lxc root group to host pool group
        users = {
          users = {
            root.subGidRanges = [
              { startGid = 1500; count = 1; }
              { startGid = 1000000; count = 1000000000; }
            ];
            # map lxc root to host docker user
            docker = {
              isSystemUser = true;
              uid = 1000000;
              group = "nogroup";
              description = "docker LXC root";
            };
          };
        };
      };
  };
}
