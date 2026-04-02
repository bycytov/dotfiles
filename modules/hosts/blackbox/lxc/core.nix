{ den, ... }:
{
  den.aspects.lxc-core = {
    includes = with den.aspects.lxc-core._; [
      address
      base
    ] ++ [ den.aspects.nix-config ];

    _.address = { host, ... }: {
      nixos.systemd.network.networks."50-eth0".networkConfig.Address = host.ip;
    };

    _.base = den.lib.perHost {
      nixos =
        { pkgs, modulesPath, ... }:
        {
          imports = [ "${modulesPath}/virtualisation/lxc-container.nix" ];

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
  };
}
