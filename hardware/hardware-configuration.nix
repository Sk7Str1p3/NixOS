# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.luks.devices = {
   NixOS.device = "/dev/nvme0n1p2";
  };
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.resumeDevice = "/dev/mapper/NixOS";
  boot.kernelParams = [
    "resume_offset=7876239"
  ];

  environment.etc."crypttab".text = ''
    HDD    	/dev/disk/by-partuuid/0b959419-c80e-41b7-b298-d666073d0a4f 	/etc/cryptsetup-keys.d/HDD.bek 		bitlk,nofail
    WinWare	/dev/disk/by-partuuid/74e675f3-4eb2-4075-a56c-413091ce48bd	/etc/cryptsetup-keys.d/WinWare.bek	bitlk
    Windows	/dev/disk/by-partuuid/2ebfde02-9a3a-4e15-9afa-83f98cfb782c	/etc/cryptsetup-keys.d/Windows.bek	bitlk
    RaidSATA	/dev/disk/by-partuuid/b9888660-3e7a-4176-91b0-39857dae7900	/etc/cryptsetup-keys.d/RaidSATA.key
    RaidNVME	/dev/disk/by-partuuid/2dfb0f15-8490-4807-a542-ab6b895f2321	/etc/cryptsetup-keys.d/RaidNVME.key
  '';

  fileSystems."/" = {
    device = "/dev/mapper/NixOS";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/NixOS";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" ];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/NixOS";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" ];
  };

  fileSystems."/.swapvol" = {
    device = "/dev/mapper/NixOS";
    fsType = "btrfs";
    options = [ "subvol=@swap" "compress=zstd" ];
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/B121-36EC";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  fileSystems."/home/Sk7Str1p3/HDD" = {
    device = "/dev/mapper/HDD";
    fsType = "ntfs";
    options = [ "nofail" ];
  };
  fileSystems."/home/Sk7Str1p3/Windows" = {
    device = "/dev/mapper/Windows";
    fsType = "ntfs";
  };
  fileSystems."/home/Sk7Str1p3/WinWare" = { 
    device = "/dev/mapper/WinWare";
    fsType = "ntfs";
  };
  fileSystems."/home/Sk7Str1p3/LinuxWare" = { 
    device = "/dev/mapper/RaidNVME";
    fsType = "btrfs";
    options = [ "compress=zstd" "subvol=@" ];
  };

  swapDevices = [
    {
      device = "/.swapvol/NixSwap";
      size = 12*1024;
    }
  ];
  zramSwap.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f0u3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
