{ inputs, den, ... }:
{
  flake-file.inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";
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

