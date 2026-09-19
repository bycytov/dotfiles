{ den, ... }:
{
  den.aspects.nfs.nixos =
    { lib, ... }:
    {
      services.nfs.server.enable = true;
      services.nfs.server.exports = ''
        /mnt/pool/games/PS4    192.168.1.0/24(fsid=0,rw,sync,no_subtree_check,insecure,anongid=1500,anonuid=1000)
      '';
    };

}
