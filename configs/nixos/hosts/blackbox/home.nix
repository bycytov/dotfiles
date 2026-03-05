{ config, pkgs, ... }:

{
  home.username = "sam";
  home.homeDirectory = "/home/sam";
  home.stateVersion = "25.11";
  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "bycytov";
        email = "bycytov@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo nixos running fin";
    };
  };
  xdg.configFile."tmux" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/sam/dotfiles/submodules/tmux";
    recursive = true;
  };
#  home.file.".config/tmux".source = ./../../../../submodules/tmux;
}
