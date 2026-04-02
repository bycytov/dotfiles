{ inputs, den, ... }:
{
  flake-file.inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  den.aspects.stable = den.lib.perHost {
    nixos = { pkgs, lib, ... }: {
      nixpkgs.overlays = [
        (final: _prev: {
          stable = import inputs.nixpkgs-stable {
            inherit (final) system;
          };
        })
      ];
    };
  };
}

