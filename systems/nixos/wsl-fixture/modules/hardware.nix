{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "sr_mod"
    ];
  };

  disko.devices.disk.main = {
    type = "disk";

    device = "/dev/disk/nvme0n1";

    content = {
      type = "gpt";

      partitions = {
        ESP = {
          priority = 1;
          name = "ESP";
          start = "1M";
          end = "128M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        root = {
          size = "100%";
          priority = 2;

          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            mountpoint = "/partition-root";

            subvolumes = {
              "root" = {
                mountpoint = "/";
              };

              "home" = {
                mountOptions = [ "compress=zstd" ];
                mountpoint = "/home";
              };

              "nix" = {
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
                mountpoint = "/nix";
              };

              "swap" = {
                mountpoint = "/.swapvol";

                swap = {
                  swapfile.size = "20M";
                  swapfile2.size = "20M";
                  swapfile2.path = "rel-path";
                };
              };
            };

            swap = {
              swapfile = {
                size = "20M";
              };
              swapfile1 = {
                size = "20M";
              };
            };
          };
        };
      };
    };
  };
}
