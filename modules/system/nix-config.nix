{ den, ... }:
{
  den.aspects.nix-config = {
    includes = with den.aspects.nix-config._; [
      experimental-features
      optimise
      gc
    ];

    _.experimental-features = den.lib.perHost {
      nixos =
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
    };

    _.optimise = den.lib.perHost {
      nixos =
        { lib, ... }:
        {
          nix.optimise = {
            automatic = lib.mkDefault true;
            dates = lib.mkDefault "weekly";
          };
        };
    };

    _.gc = den.lib.perHost {
      nixos =
        { lib, ... }:
        {
          nix.gc = {
            automatic = lib.mkDefault true;
            dates = lib.mkDefault "weekly";
            options = lib.mkDefault "--delete-older-than 7d";
          };
        };
    };
  };
}
