{pkgs, ...}: {
  system.stateVersion = "23.05";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
  };

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    cpu.amd.updateMicrocode = true;
  };

  sound.enable = true;

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.device = "nodev";
    };

    initrd = {
      kernelModules = ["amdgpu"];
      availableKernelModules = ["nvme"];
    };
  };

  time.timeZone = "America/Toronto";
}
