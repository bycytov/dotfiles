{ den, ... }:
{
  # Include SSH by default on all hosts
  den.ctx.host.includes = [ den.aspects.ssh ];

  den.aspects.ssh = den.lib.perHost {
    nixos =
      { lib, ... }:
      {
        services.openssh = {
          enable = lib.mkDefault true;
          settings = {
            PermitRootLogin = lib.mkDefault "no";
            PasswordAuthentication = lib.mkDefault true;
          };
        };
      };
  };
}
