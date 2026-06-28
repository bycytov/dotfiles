{ den, ... }:
{
  # Include tailscale by default on all hosts
  den.schema.host.includes = [ den.aspects.tailscale ];

  den.aspects.tailscale.nixos =
    { lib, ... }:
    {
      services.tailscale = {
        enable = lib.mkDefault true;
      };
    };
}
