{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "ESP";
              type = "EF00";
              priority = 1;
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi";
              };
            };
            # swap = {
            #   label = "swap";
            #   type = "8200";
            #   size = "4G";
            #   content = {
            #     type = "swap";
            #     # randomEncryption = true;
            #     # resumeDevice = true;  # resume from hiberation from this device
            #   };
            # };
            root = {
              label = "root";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Override existing partition
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "/rootfs" = {
                    mountpoint = "/";
                  };
                  # Mountpoints inferred from subvolume name
                  "/home" = {
                    mountOptions = ["compress=zstd"];
                  };
                  "/nix" = {
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
