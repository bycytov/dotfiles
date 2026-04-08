{ den, ... }:
{
  den.aspects.blackbox = {
    includes = with den.aspects; [
      stable # nixpkgs-stable overlay
      network-bridge
      nix-config # nix daemon settings
      incus # incus virtualisation
      (den._.tty-autologin "sam")
    ];

    nixos =
      { pkgs, lib, ... }:
      {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # ZFS Stuff
        boot.supportedFilesystems = [ "zfs" ];
        boot.zfs.forceImportRoot = false;
        boot.zfs.extraPools = [ "incus" ];
        networking.hostId = "38ce88fa";

        environment.systemPackages = with pkgs; [
          btop
          curl
          fastfetch
          iotop
          intel-gpu-tools
          ncdu
          tmux
          wget
        ];
      };

  };
}
