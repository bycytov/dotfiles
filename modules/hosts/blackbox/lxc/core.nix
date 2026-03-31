{ den, ... }:
{
  den.aspects.lxc-core = {
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
              Gateway = "192.168.1.1";
              DNS = "192.168.1.1";
              IPv6AcceptRA = true;
            };
            linkConfig.RequiredForOnline = "routable";
          };
        };

        environment.systemPackages = with pkgs; [ fastfetch ];
      };
    };
}
