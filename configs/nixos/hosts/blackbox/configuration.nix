{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./../../nixosModules/virtualisation.nix
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
        ipv4.addresses = [ {
          address = "192.168.1.3";
          prefixLength = 20;
        } ];
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
    extraGroups = [ "wheel" "incus-admin" "video" "render" ];
    packages = with pkgs; [
      tree
    ];
  };

  # programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    btop
    curl
    fastfetch
    iotop
    intel-gpu-tools
    unstable.mergerfs
    ncdu
    nvim
    tmux
    vimPlugins.LazyVim
    wget
  ];

  services.openssh.enable = true;
  services.getty.autologinUser = "sam";
  services.tailscale.enable = true;
  
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = true;
    };
  };

  system.stateVersion = "25.11";

}

