{ den, ... }:
{
  # Include tailscale by default on all hosts
  den.ctx.host.includes = [ den.aspects.tailscale ];

  den.aspects.tailscale = den.lib.perHost {
    nixos =
      { lib, ... }:
      {
        services.tailscale = {
          enable = lib.mkDefault true;
        };
      };
  };
}
