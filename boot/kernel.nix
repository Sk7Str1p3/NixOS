{pkgs, ...}: {
  boot = {
    kernelModules = [
      "kvm-intel"
    ];
    resumeDevice = "/dev/mapper/NixOS";
    kernelParams = [
      "resume_offset=7876239"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
