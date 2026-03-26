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

