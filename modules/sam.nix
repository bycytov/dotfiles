{ den, ... }:
{
  # user aspect
  den.aspects.sam = {
    includes = [
      den.provides.primary-user
      den._.bidirectional
      (den.provides.user-shell "bash")
      #      den.aspects.lazyvim
    ];

    homeManager =
      { pkgs, ... }:
      {
        programs.git = {
          enable = true;
          settings = {
            user = {
              name = "bycytov";
              email = "bycytov@gmail.com";
            };
            init.defaultBranch = "main";
          };
        };
        programs.bash = {
          shellAliases = {
            lg = "lazygit";
          };
        };
        programs.lazygit.enable = true;
        home.packages = [ pkgs.htop ];
      };

    # user can provide NixOS configurations
    # to any host it is included on
    nixos =
      { pkgs, ... }:
      {
        security.sudo.wheelNeedsPassword = false;
      };
  };
}
