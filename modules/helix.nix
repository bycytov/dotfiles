{ inputs, den, ... }:
{
  flake-file.inputs = {
    helix.url = "github:helix-editor/helix";
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
