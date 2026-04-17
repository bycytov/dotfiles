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
        };
      };

      systemd.services = lib.mkMerge [
        (mkComposeService { name = "plex"; composeFile = "/opt/docker/plex/compose.yaml"; })
        (mkComposeService { name = "tsbridge"; composeFile = "/opt/docker/tsbridge/compose.yaml"; })
        (mkComposeService { name = "media"; composeFile = "/opt/docker/media/compose.yaml"; requires = [ "docker-compose-tsbridge.service" ]; after = [ "docker-compose-tsbridge.service" ]; })
        (mkComposeService { name = "actualbudget"; composeFile = "/opt/docker/actualbudget/compose.yaml"; requires = [ "docker-compose-tsbridge.service" ]; after = [ "docker-compose-tsbridge.service" ]; })
      ];
    };
  };
}
