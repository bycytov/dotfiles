{ den, ... }:
{
  den.aspects.base = {
    includes = [ den.aspects.lxc-core ];

    nixos = { ... }: {
      # systemd.network.networks."50-eth0".networkConfig.Address = "192.168.1.31/24";
    };
  };
}
