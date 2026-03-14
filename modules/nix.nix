{ den, ... }:
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
          gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
          };
        };
      };
  };
}
