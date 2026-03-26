{ den, ... }:
{
  den.aspects.incus = den.lib.perHost {
    nixos =
      { lib, ... }:
      {
        virtualisation = {
          kvmgt.enable = lib.mkDefault true;
          incus = {
            enable = true;
            ui.enable = true;
            preseed = {
              networks = [
                {
                  name = "internalbr0";
                  type = "bridge";
                  description = "Internal/NATted bridge";
                  config = {
                    "ipv4.address" = "auto";
                    "ipv4.nat" = "true";
                    "ipv6.address" = "auto";
                    "ipv6.nat" = "true";
                  };
                }
              ];
              profiles = [
                {
                  name = "default";
                  description = "Default Incus Profile";
                  devices = {
                    eth0 = {
                      name = "eth0";
                      network = "internalbr0";
                      type = "nic";
                    };
                    root = {
                      path = "/";
                      pool = "default";
                      type = "disk";
                    };
                  };
                }
                {
                  name = "bridged";
                  description = "Instances bridged to LAN";
                  devices = {
                    eth0 = {
                      name = "eth0";
                      nictype = "bridged";
                      parent = "br0";
                      type = "nic";
                    };
                    root = {
                      path = "/";
                      pool = "default";
                      type = "disk";
                    };
                  };
                }
              ];
              storage_pools = [
                {
                  name = "default";
                  driver = "dir";
                  config = {
                    source = "/mnt/incus/default";
                  };
                }
              ];
            };
          };
        };
      };
  };
}
