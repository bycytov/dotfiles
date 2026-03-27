{ den, ... }:
{
  den.aspects.blackbox = {
    includes = with den.aspects; [
      stable # nixpkgs-stable overlay
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
        networking.hostId = "38ce88fa";

        networking = {
          firewall.enable = false;
          nftables.enable = true;
          interfaces.br0 = {
            useDHCP = false;
            ipv4.addresses = [
              {
                address = "192.168.1.3";
                prefixLength = 20;
              }
            ];
          };
          bridges.br0.interfaces = [ "enp3s0" ];
          defaultGateway = "192.168.1.1";
          nameservers = [ "192.168.1.1" ];
        };

        environment.systemPackages = with pkgs; [
          btop
          curl
          fastfetch
          iotop
          intel-gpu-tools
          mergerfs
          ncdu
          tmux
          wget
        ];
      };

  };
}
