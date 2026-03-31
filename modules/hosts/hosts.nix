# Defines all hosts + users
{ den, ... }:
{
  den.hosts.x86_64-linux.blackbox.users.sam = {
    classes = [ "homeManager" ];
  };

  den.hosts.x86_64-linux.worker-1.users.sam = {
    classes = [ "homeManager" ];
  };
}

