# Defines all hosts + users
{ inputs, lib, ... }:
{
  den = {
    schema.user.classes = lib.mkDefault [ "homeManager" ];
    hosts = {
      x86_64-linux = {

        blackbox = {
          users.sam = { };
          networking = {
            interfaces = [ "enp3s0" ];
            address = "192.168.1.3";
            gateway = "192.168.1.1";
            nameservers = [ "192.168.1.1" ];
          };
        };

        docker.ip = "192.168.1.30/24";

        nixos-stable = {
          instantiate = inputs.nixpkgs-stable.lib.nixosSystem;
          home-manager.module = inputs.home-manager-stable.nixosModules.home-manager;
          ip = "192.168.1.31/24";
        };
      };
    };
  };
}
