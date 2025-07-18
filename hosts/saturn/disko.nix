{ ... }:
let
  makeLuksContent = diskName: content: {
    type = "luks";
    name = diskName;
    settings = {
      allowDiscards = true;
      crypttabExtraOpts = ["fido2-device=auto" "token-timeout=10"];
    };
    inherit content;
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
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "1G";
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
              content = makeLuksContent "main-crypt" {
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
      nixstore = {
        type = "disk";
        device = "/dev/nvme0n1"; # faster disk
        content = {
          type = "gpt";
          partitions = {
            luks = {
              size = "100%";
              content = makeLuksContent "nixstore-crypt" {
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
  };
}

