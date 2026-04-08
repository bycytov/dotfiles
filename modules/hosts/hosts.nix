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

        worker-1.ip = "192.168.1.30/24";

        worker-2 = {
          instantiate = inputs.nixpkgs-stable.lib.nixosSystem;
          home-manager.module = inputs.home-manager-stable.nixosModules.home-manager;
          ip = "192.168.1.31/24";
        };
      };
    };
  };
}
