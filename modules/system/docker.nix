{ den, ... }:
{
  den.aspects.docker = {
    nixos = { pkgs, lib, ... }: {
      virtualisation.docker = {
        enable = true;
        autoPrune = {
          enable = lib.mkDefault true;
          dates = lib.mkDefault "weekly";
        };
      };
      environment.systemPackages = [ pkgs.docker-compose ];
    };
  };
}
