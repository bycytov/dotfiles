{ den, ... }:
{
  den.aspects.worker-2 = {
    includes = [ den.aspects.lxc-core ];

    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ bottom btop ];
    };
  };
}
