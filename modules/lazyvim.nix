{ inputs, den, ... }:
{
  flake-file.inputs = {
    lazyvim.url = "github:pfassina/lazyvim-nix";
  };
  den.aspects.lazyvim = {
    homeManager =
      { pkgs, ... }:
      {
        imports = [ inputs.lazyvim.homeManagerModules.default ];
        programs.lazyvim = {
          enable = true;
          extras = {
            lang.nix.enable = true;
          };
          extraPackages = with pkgs; [
            nixd
            alejandra
          ];
        };
      };
  };
}
