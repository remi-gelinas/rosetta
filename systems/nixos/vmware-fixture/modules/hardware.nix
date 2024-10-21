{
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "sr_mod"
    ];

    # VMWare errors on boot if this is not "0"
    loader.systemd-boot.consoleMode = "0";
  };

  disko.devices.disk.main.device = "/dev/disk/nvme0n1";
}
