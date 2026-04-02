{ den, ... }:
{
  den.aspects.worker-2 = {
    includes = [ den.aspects.lxc-core ];

    nixos = { pkgs, ... }: {
      systemd.network.networks."50-eth0".networkConfig.Address = "192.168.1.33/24";
      environment.systemPackages = with pkgs; [ bottom ];
    };
  };
}
