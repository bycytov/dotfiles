{ config, pkgs, ... }:

{

  imports = [
  #  ./../../homeModules/lazyvim.nix
  ];

  home.username = "sam";
  home.homeDirectory = "/home/sam";
  home.stateVersion = "25.11";

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
    enable = true;
    shellAliases = {
      lg = "lazygit";
    };
  };
  programs.lazygit.enable = true;

  home.packages = with pkgs; [
    tree
  ];

#  xdg.configFile."tmux" = {
#    source = config.lib.file.mkOutOfStoreSymlink "/home/sam/dotfiles/submodules/tmux";
#    recursive = true;
#  };
}
