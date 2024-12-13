{
  boot.initrd = {
    verbose = false;
    availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
    systemd = {
      enable = true;
      tpm2.enable = true;
    };
    luks.devices = {
      NixOS.device = "/dev/disk/by-uuid/db0200f2-fae6-483f-aff1-164cd2d17a0e";
    };
  };
}
