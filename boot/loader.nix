{lib, ...}: {
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = lib.mkForce false;
        configurationLimit = 20;
        consoleMode = "max";
        editor = false;
      };
      generationsDir = {
        enable = false;
        copyKernels = true;
      };
      initScript.enable = false;
      timeout = 2;
    };
  };
}
