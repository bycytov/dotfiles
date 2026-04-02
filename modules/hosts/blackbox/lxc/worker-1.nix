{ den, ... }:
{
  den.aspects.worker-1 = {
    includes = [ den.aspects.lxc-core den.aspects.docker ];

    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ btop ];
    };
  };
}
