{pkgs, ...}: {
  boot = {
    kernelModules = [
      "kvm-intel"
    ];
    resumeDevice = "/dev/mapper/NixOS";
    kernelParams = [
      "resume_offset=7876239"
      "quiet"
      "splash"
    ];
    kernelPackages = pkgs.linuxPackages_cachyos;
  };
}
