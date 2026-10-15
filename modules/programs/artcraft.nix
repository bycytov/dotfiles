{ inputs, den, ... }:
{
  flake-file.inputs.artcraft = {
    url = "github:devitek/artcraft-nixos";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.artcraft.homeManager =
    { ... }:
    {
      imports = [ inputs.artcraft.homeManagerModules.default ];

      programs.artcraft = {
        enable = true;
        apps = [ "pdfcraft" "gridcraft" "wordcraft" "deckcraft" ];
      };
    };
}
