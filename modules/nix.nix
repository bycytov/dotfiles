{
  den.aspects.nix = {
    # Owned configs per class
    nixos =
      { ... }:
      {
        nix = {
          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            warn-dirty = true;
          };
          optimise = { 
            automatic = true;
            dates = "weekly";
          };
          gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
          };
        };
      };
  };
}
