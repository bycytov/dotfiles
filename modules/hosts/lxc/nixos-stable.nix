{ den, ... }:
{
  den.aspects.nixos-stable = {
    includes = [ den.aspects.lxc-core ];

    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ bottom btop ];
    };
  };
}
