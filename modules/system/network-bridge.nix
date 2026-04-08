{ den, ... }:
{
  den.aspects.network-bridge = { host, ... }: {
    nixos = {
      networking = {
        firewall.enable = false;
        nftables.enable = true;
        interfaces.br0 = {
          useDHCP = false;
          ipv4.addresses = [
            {
              address = host.networking.address;
              prefixLength = 24;
            }
          ];
        };
        bridges.br0.interfaces = host.networking.interfaces;
        defaultGateway = host.networking.gateway;
        nameservers = host.networking.nameservers;
      };
    };
  };
}
