{pkgs, ...}: {
  virtualisation.libvirtd.qemu = {
    package = pkgs.qemu;
    ovmf = {
      enable = true;
      packages = with pkgs; [
        OVMFFull.fd
        pkgsCross.aarch64-multiplatform.OVMF.fd
      ];
    };
    runAsRoot = true;
    swtpm = {
      enable = true;
      package = pkgs.swtpm-tpm2;
    };
    vhostUserPackages = [pkgs.virtiofsd];
  };
}
