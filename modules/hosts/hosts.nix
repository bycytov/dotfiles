# Defines all hosts + users
{ inputs, lib, ... }:
{
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  den.hosts.x86_64-linux.blackbox.users.sam = { };

  den.hosts.x86_64-linux.worker-1.users.sam = { };

  den.hosts.x86_64-linux.worker-2 = {
    instantiate = inputs.nixpkgs-stable.lib.nixosSystem;
    home-manager.module = inputs.home-manager-stable.nixosModules.home-manager;
    users.sam = { };
  };
}

