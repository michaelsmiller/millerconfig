{
  disko.devices = {
    disk.main = {
      device = "/command/line/overrides/this/value"; # MUST OVERRIDE THIS BEFORE RUNNING DISKO
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          MBR = { # grub MBR
            type = "EF02";
            size = "1M";
            priority = 1; # must be first partition
          };
          ESP = { # EFI system partition
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          swap = {
            size = "64G";
            content = {
              type = "swap";
            };
          };
          nix = {
            size = "1000G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
              mountOptions = [ "noatime" ]; # fewer writes, good for disk health
            };
          };
          root = { # remainder is user space
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "defaults" ];
            };
          };
        };
      };
    };
  };
}
