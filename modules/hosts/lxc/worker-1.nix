{ den, ... }:
{
  den.aspects.worker-1 = {
    includes = [ den.aspects.lxc-core (den._.tty-autologin "sam") ];

    nixos = { pkgs, ... }: {
      systemd.network.networks."50-eth0".networkConfig.Address = "192.168.1.32/24";
      environment.systemPackages = with pkgs; [ btop ];
    };
  };
}
