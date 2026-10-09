{ den, lib, ... }:
{
  den.aspects.docker = {
    includes = [ den.aspects.lxc-core ];

    nixos = { pkgs, ... }:
    let
      mkComposeService = { name, composeFile, requires ? [], after ? [] }: {
        "docker-compose-${name}" = {
          description = "Docker Compose stack: ${name}";
          wantedBy    = [ "multi-user.target" ];
          requires    = [ "docker.service" "network-online.target" ] ++ requires;
          after       = [ "docker.service" "network-online.target" ] ++ after;

          serviceConfig = {
            Type             = "oneshot";
            RemainAfterExit  = true;
            WorkingDirectory = builtins.dirOf composeFile;
            ExecStart = "${pkgs.docker}/bin/docker compose -f ${composeFile} up --remove-orphans --wait";
            ExecStop   = "${pkgs.docker}/bin/docker compose -f ${composeFile} down";
            Restart    = "on-failure";
          };
        };
      };
    in {

      virtualisation.docker = {
        enable = true;
        autoPrune = {
          enable = lib.mkDefault true;
          dates  = lib.mkDefault "weekly";
      	  flags = [ "--filter" "until=48h" ];
        };
      };

      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        _7zip-zstd-rar
        lftp
        tree
        wget
      ];

      systemd.services = lib.mkMerge [
        (mkComposeService { name = "samba"; composeFile = "/opt/docker/samba/compose.yaml"; })
        (mkComposeService { name = "docktail"; composeFile = "/opt/docker/docktail/compose.yaml"; after = [ "tailscaled.service" ]; })
        (mkComposeService { name = "media"; composeFile = "/opt/docker/media/compose.yaml"; requires = [ "docker-compose-docktail.service" ]; after = [ "docker-compose-docktail.service" ]; })
        (mkComposeService { name = "actualbudget"; composeFile = "/opt/docker/actualbudget/compose.yaml"; requires = [ "docker-compose-docktail.service" ]; after = [ "docker-compose-docktail.service" ]; })
      ];

      # keep tailscale identity (and its tag) across LXC redeploys
      systemd.tmpfiles.rules = [ "d /mnt/data/tailscale 0700 root root -" ];
      fileSystems."/var/lib/tailscale" = {
        device = "/mnt/data/tailscale";
        fsType = "none";
        options = [ "bind" ];
      };
    };
  };
}
