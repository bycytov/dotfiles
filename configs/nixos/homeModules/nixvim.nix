{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    <nixvim>.homeModules.nixvim
  ];

  programs.nixvim.enable = true:
}
