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
                    eth0 = {
                      name = "eth0";
                      network = "internalbr0";
                      type = "nic";
                    };
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
              ];
              storage_pools = [
                {
                  name = "default";
                  driver = "zfs";
                  config = {
                    source = "/dev/nvme1n1";
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
          # Shell script to create incus lxc image from nixos config
          (pkgs.writeShellScriptBin "nixos-update-lxc-image" ''
            HOST=$1
            if [ -z "$HOST" ]; then echo "Usage: nixos-update-lxc-image <hostname>"; exit 1; fi
            METADATA=$(nix build ".#nixosConfigurations.$HOST.config.system.build.metadata" --no-link --print-out-paths)
            SQUASHFS=$(nix build ".#nixosConfigurations.$HOST.config.system.build.squashfs" --no-link --print-out-paths)
            incus image delete "nixos/custom/$HOST" || true
            incus image import --alias "nixos/custom/$HOST" "$METADATA"/tarball/*.tar.xz "$SQUASHFS"/*.squashfs
          '')
        ];

        # map container root to docker user on host
        # see configs/incus/worker-1.yaml raw.idmap
        users = {
          users = {
            root.subUidRanges = [
              { startUid = 1500; count = 1; }
              { startUid = 1000000; count = 1000000000; }
            ];
            root.subGidRanges = [
              { startGid = 1500; count = 1; }
              { startGid = 1000000; count = 1000000000; }
            ];
            docker = {
              isSystemUser = true;
              uid = 1500;
              group = "docker";
            };
          };
          groups.docker.gid = 1500;
        
        };
      };
  };
}
