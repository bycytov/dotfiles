{ den, ... }:
{
  den.aspects.nix-config = {
    includes = with den.aspects.nix-config._; [
      core
      gc
      locale
    ];

    _.core.nixos =
      { lib, ... }:
      {
        nix.settings = {
          experimental-features = lib.mkDefault [
            "nix-command"
            "flakes"
          ];
          warn-dirty = lib.mkDefault true;
          trusted-users = lib.mkDefault [ "@wheel" ];
        };
      };

    _.gc.nixos =
      { lib, ... }:
      {
        nix.gc = {
          automatic = lib.mkDefault true;
          dates = lib.mkDefault "weekly";
          options = lib.mkDefault "--delete-older-than 7d";
        };
        nix.settings.auto-optimise-store = lib.mkDefault true;
      };
    _.locale.nixos =
      { lib, ... }:
      {
        time.timeZone = lib.mkDefault "America/Chicago";
      };
  };
}
