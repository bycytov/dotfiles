{ inputs, den, ... }:
{
  flake-file.inputs = {
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.helix = {
    homeManager =
      { helix, pkgs, ... }:
      {
        programs.helix = {
          enable = true;
          package = inputs.helix.packages.${pkgs.system}.default;
        };
      };

  };
}
