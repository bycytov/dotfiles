{ den, ... }:
{
  den.aspects.blackbox.nixos = { pkgs, ... }: {
    fileSystems = {
      "/mnt/disk01" = {
        device = "/dev/disk/by-uuid/928fca4a-8e2d-425e-8f03-2679e4988c95";
        fsType = "ext4";
        options = [ "nosuid" "nodev" "nofail" ];
      };
      "/mnt/disk02" = {
        device = "/dev/disk/by-uuid/67b04c48-c02b-4779-b275-39f3a436bc3f";
        fsType = "ext4";
        options = [ "nosuid" "nodev" "nofail" ];
      };
      "/mnt/disk03" = {
        device = "/dev/disk/by-uuid/3f507787-ef84-4d6c-9a00-12f877968ab8";
        fsType = "ext4";
        options = [ "nosuid" "nodev" "nofail" ];
      };
      "/mnt/disk04" = {
        device = "/dev/disk/by-uuid/6d38a749-30af-4246-b522-fd8c28cd78cf";
        fsType = "ext4";
        options = [ "nosuid" "nodev" "nofail" ];
      };

      "/mnt/pool" = {
        device = "/mnt/disk*";
        fsType = "mergerfs";
        options = [
          "minfreespace=500G"
          "allow_other"
          "use_ino"
          "passthrough.io=rw"
          "cache.files=auto-full"
          "dropcacheonclose=true"
          "category.create=pfrd"
          "func.getattr=newest"
        ];
      };
    };

    users = {
      users.docker = {
        isSystemUser = true;
        uid = 1500;
        group = "docker";
      };
      groups.docker.gid = 1500;
    };

    environment.systemPackages = [ pkgs.mergerfs ];
  };
}
