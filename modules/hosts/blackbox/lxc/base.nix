{ den, ... }:
{
  den.aspects.drone = {
    includes = [ den.aspects.lxc-core (den._.tty-autologin "sam") ];

    nixos = { ... }: {
      systemd.network.networks."50-eth0".networkConfig.Address = "192.168.1.31/24";
    };
  };
}
