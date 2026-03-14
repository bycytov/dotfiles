{ den, ... }:
{
  # host aspect
  den.aspects.blackbox = {
    includes = [
      den.aspects.incus
      den.aspects.nix
    ];
    # host NixOS configuration
    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
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

        environment.systemPackages = with pkgs; [
          btop
          curl
          fastfetch
          iotop
          intel-gpu-tools
          mergerfs
          ncdu
          tmux
          vim
          wget
        ];

        services.openssh.enable = true;
        services.getty.autologinUser = "sam";
        services.tailscale.enable = true;
      };

    # host provides default home environment for its users
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.tree ];
      };
  };
}
