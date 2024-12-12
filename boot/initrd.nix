{
  boot.initrd = {
    availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
    systemd = {
      enable = true;
      tpm2.enable = true;
    };
  };
}
