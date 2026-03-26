{ den, lib, ... }:
{
  flake-file.inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.ctx.hm-host.includes = [
    (den.lib.perHost {
      nixos.home-manager = {
        useUserPackages = lib.mkDefault true;
        useGlobalPkgs = lib.mkDefault true;
        backupFileExtension = lib.mkDefault "backup";
      };
    })
  ];
}
