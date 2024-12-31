{
  imports = [
    ./lanzaboot.nix
    #./loader_grub.nix
    ./kernel.nix
    ./initrd.nix
    ./plymouth.nix
    ./bimfmt.nix
  ];

  boot.consoleLogLevel = 0;
  boot.enableContainers = true;
  boot.growPartition = true;
  boot.hardwareScan = true;
  boot.supportedFilesystems = {
    btrfs = true;
    zfs = false;
    ntfs = true;
    fat = true;
  };
}
