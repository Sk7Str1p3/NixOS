{pkgs, ...}: {
  nix = {
    enable = true;
    package = pkgs.nixVersions.latest;
    settings = {
      show-trace = true;
      allowed-users = [
        "*"
      ];
      auto-optimise-store = true;
      cores = 8;
      trusted-users = [
        "root"
        "@wheel"
      ];
      sandbox-paths = ["/bin/sh=${pkgs.busybox-sandbox-shell.out}/bin/busybox"];
    };
    optimise = {
      automatic = true;
      dates = [
        "06:00"
        "18:00"
        "22:00"
      ];
    };
    gc = {
      automatic = true;
      dates = "22:00";
      options = "--delete-older-than 3d";
    };
  };
}
