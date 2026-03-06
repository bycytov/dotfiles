{
  config,
  lib,
  pkgs,
  nixvim,
  ...
}:
{
  imports = [
    nixvim.homeModules.nixvim
  ];

  programs.nixvim.enable = true;
}
