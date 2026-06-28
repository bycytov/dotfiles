{ den, ... }:
{
  # Include SSH by default on all hosts
  den.schema.host.includes = [ den.aspects.ssh ];

  den.aspects.ssh.nixos =
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
}
