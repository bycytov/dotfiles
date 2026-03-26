# Declare tools for use in implementing the dendritic pattern
{ inputs, ... }:
{
  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
  ];

  flake-file.inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    flake-file.url = "github:vic/flake-file";
    den.url = "github:vic/den/latest";
    flake-aspects.url = "github:vic/flake-aspects/latest";
  };

  systems = [
    "x86_64-linux"
  ];
}

