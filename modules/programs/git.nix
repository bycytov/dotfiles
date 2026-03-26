{ den, ... }:
{
  den.aspects.git = den.lib.perUser {
    homeManager = { lib, ... }: {
      programs.git = {
        enable = lib.mkDefault true;
        settings.init.defaultBranch = lib.mkDefault "main";
      };
      programs.lazygit.enable = lib.mkDefault true;
    };
  };
}

