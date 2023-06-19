# https://github.com/nix-community/disko/tree/master/example
{disks ? ["/dev/sda"], ...}: {
  disko.devices = {
    disk = {
      sda = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "ESP";
              start = "1MiB";
              end = "500MiB";
              fs-type = "fat32";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi";
              };
            }
            {
              name = "root";
              start = "500MiB";
              end = "-4G";
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Override existing partition
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "/rootfs" = {
                    mountpoint = "/";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  # Mountpoints inferred from subvolume name
                  "/home" = {
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "/nix" = {
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            }
            {
              name = "swap";
              start = "-4G";
              end = "100%";
              part-type = "primary";
              content = {
                type = "swap";
                # randomEncryption = true;
              };
            }
          ];
        };
      };
    };
  };
}
