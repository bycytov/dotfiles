{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./../../nixosModules/incus.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    firewall.enable = false;
    hostName = "blackbox";
    nftables.enable = true;
    interfaces = {
      br0 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.1.3";
            prefixLength = 20;
          }
        ];
      };
    };
    bridges = {
      br0 = {
        interfaces = [ "enp3s0" ];
      };
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.1" ];
  };

  time.timeZone = "America/Chicago";

  users.users.sam = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "incus-admin"
      "video"
      "render"
    ]; 
  };

  environment.systemPackages = with pkgs; [
    btop
    curl
    fastfetch
    iotop
    intel-gpu-tools
    unstable.mergerfs
    ncdu
    tmux
    vim
    wget
  ];

  services.openssh.enable = true;
  services.getty.autologinUser = "sam";
  services.tailscale.enable = true;

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

  system.stateVersion = "25.11";

}
