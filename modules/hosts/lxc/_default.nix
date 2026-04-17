{ den, ... }:
{
  den.aspects.<hostname> = {
    includes = [ den.aspects.lxc-core ];

    nixos = { ... }: {

    };
  };
}
