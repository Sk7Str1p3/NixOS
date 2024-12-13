{
  imports = [
    ./loader_grub.nix # uncomment if you wish use grub
    ./kernel.nix
    ./initrd.nix
    ./plymouth.nix
  ];
}
