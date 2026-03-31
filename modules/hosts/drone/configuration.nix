{ den, ... }:
{
  den.aspects.drone = {
    includes = with den.aspects; [

      nix-config # nix daemon settings

      (den._.tty-autologin "sam")
    ];

    nixos = { config, pkgs, modulesPath, ... }:

      {
        imports = [
          # Include the default incus configuration.
          "${modulesPath}/virtualisation/lxc-container.nix"
        ];

        networking = {
          dhcpcd.enable = false;
          useDHCP = false;
          useHostResolvConf = false;
        };

        systemd.network = {
          enable = true;
          networks."50-eth0" = {
            matchConfig.Name = "eth0";
            networkConfig = {
              Address = "192.168.1.31/24";
              Gateway = "192.168.1.1";
              DNS = "192.168.1.1";
              IPv6AcceptRA = true;
            };
            linkConfig.RequiredForOnline = "routable";
          };
        };

        environment.systemPackages = with pkgs; [ fastfetch git ];

        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        system.stateVersion = "25.11"; # Did you read the comment?
      };
    };
}
