{
  imports = [
    ./loader.nix
    #./loader_grub.nix
    ./kernel.nix
    ./initrd.nix
    ./plymouth.nix
    #./binfmt.nix
    ./crashDump.nix
  ];

  boot = {
    consoleLogLevel = 0;
    enableContainers = true;
    growPartition = true;
    hardwareScan = true;
    supportedFilesystems = {
      btrfs = true;
      zfs = false;
      ntfs = true;
      fat = true;
    };
  };
}
