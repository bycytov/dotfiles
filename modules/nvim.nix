{ inputs, den, ... }:
{
  flake-file.inputs = {
    nvim.url = "github:bycytov/dotfiles?dir=configs/nvim-nix";
  };
  den.aspects.nvim = {
    nixos =
      { nvim, pkgs, ... }:
      {
        nixpkgs.overlays = [ inputs.nvim.overlays.default ];
        environment.systemPackages = with pkgs; [
          nvim-pkg
        ];
      };
  };
}
