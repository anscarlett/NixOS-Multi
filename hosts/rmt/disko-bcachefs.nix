{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:04:00.0";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              end = "500MiB";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi";
              };
            };
            root = {
              name = "root";
              end = "-0";
              content = {
                type = "filesystem";
                format = "bcachefs";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
