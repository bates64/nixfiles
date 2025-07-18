{ ... }:
let
  luksContent = {
    type = "luks";
    name = "crypted";
    # disable settings.keyFile if you want to use interactive password entry
    #passwordFile = "/tmp/secret.key"; # Interactive
    settings = {
      allowDiscards = true;
      keyFile = "/tmp/secret.key";
    };
    additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
  };
in {
  # TODO: once I have more ram, make /tmp a tmpfs

  # https://github.com/nix-community/disko/tree/master/example
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda"; # slower disk
        content = {
          type = "gpt";
          partitions = {
            # EFI boot partition
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = luksContent // {
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Override existing filesystem
                  subvolumes = {
                    "/rootfs" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                      ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                      ];
                    };
                    "/swap" = {
                      mountpoint = "/.swapvol";
                      # https://btrfs.readthedocs.io/en/latest/Swapfile.html
                      swap.swapfile.size = "20G"; # ~1.5x RAM
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
    nixdisk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1"; # faster disk
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = luksContent // {
                content = {
                  type = "btrfs";
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    }
  };
}

