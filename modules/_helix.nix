{ inputs, ... }:
{
  flake-file.inputs = {
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.helix = {
    homeManager =
      { pkgs, ... }:
      {
        programs.helix = {
          enable = true;
          package = inputs.helix.packages.${pkgs.system}.default;
          extraPackages = with pkgs; [
            nil
            nixfmt
          ];
          languages = {
            language = [
              {
                name = "nix";
                auto-format = true;
                formatter = {
                  command = "nixfmt";
                };
              }
            ];
          };
          ignores = [
            ".build/"
            "build/"
            "flake.lock"
            ".git/"
            ".jj/"
            ".idea/"
            "node_modules/*"
          ];
        };
      };
  };
}
