{ den, ... }:
{
  den.aspects.sam = {
    # den._.primary-user gives sam wheel + networkmanager groups
    includes = [ den._.primary-user ];

    homeManager = { pkgs, lib, ... }: {
      programs.git.settings.user = {
        name = lib.mkDefault "bycytov";
        email = lib.mkDefault "bycytov@gmail.com";
      };

      programs.bash.shellAliases.lg = "lazygit";

      home.packages = with pkgs; [
        tree
        (writeShellScriptBin "update-lxc-image" ''
          HOST=$1
          if [ -z "$HOST" ]; then echo "Usage: update-lxc-image <hostname>"; exit 1; fi
          METADATA=$(nix build ".#nixosConfigurations.$HOST.config.system.build.metadata" --no-link --print-out-paths)
          SQUASHFS=$(nix build ".#nixosConfigurations.$HOST.config.system.build.squashfs" --no-link --print-out-paths)
          incus image delete "nixos/custom/$HOST" || true
          incus image import --alias "nixos/custom/$HOST" "$METADATA"/tarball/*.tar.xz "$SQUASHFS"/*.squashfs
        '') 
      ]; 
    };

    # Everything sam wants on every host he lives on
    _.to-hosts = {
      includes = with den.aspects; [
        git
        nvim
      ];

      nixos = { lib, ... }: {
        security.sudo.wheelNeedsPassword = lib.mkDefault false;
        users.users.sam.extraGroups = [ "incus-admin" ];
      };
    };
  };
}

