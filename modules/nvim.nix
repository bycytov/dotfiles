{ inputs, den, ... }:
{
  flake-file.inputs = {
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };
  den.aspects.nvim = {
    homeManager =
      { pkgs, ... }:
      {
        imports = [ inputs.nvf.homeManagerModules.default ];
        programs.nvf = {
          enable = true;
          settings = {
            vim = {
              options = {
                tabstop = 2;
                shiftwidth = 2;
              };
              visuals.indent-blankline.enable = true;
              binds.whichKey = {
                enable = true;
                setupOpts = {
                  incons.mapping = false;
                  preset = "helix";
                };
              };
              telescope.enable = true;
              autocomplete.nvim-cmp.enable = true;
              lsp.enable = true;
              languages = {
                enableFormat = true;
                enableTreesitter = true;
                enableExtraDiagnostics = true;
                nix.enable = true;
              };
            };
          };
        };
      };
  };
}
