{ inputs, den, ... }:
{
  flake-file.inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";
  };
  den.aspects.stable = {
    nixos =
      { pkgs, ... }:
      {
        nixpkgs.overlays = [
          (final: prev: {
            stable = import inputs.nixpkgs-stable {
              inherit (final) system;
              # config.allowUnfree = true;
            };
          })
        ];
      };
  };
}
