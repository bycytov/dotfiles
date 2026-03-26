{ den, ... }:
{
  # Applied to every host, user, and home in the flake
  den.default = {
    includes = [
      # ${user}._.${host} and ${host}._.${user} bidirectional wiring
      den._.mutual-provider
      # Automatically set hostname from host.hostName
      den._.hostname
      # Automatically create users.users.<name> on OS + home.username in HM
      den._.define-user
      # Expose system-specialised inputs' and self' as module args
      den._.inputs'
      den._.self'
    ];

    nixos.system.stateVersion = "25.11";
    homeManager.home.stateVersion = "25.11";
  };
}

