{pkgs, ...}: {
  nix = {
    enable = true;
    package = pkgs.nixVersions.latest;

    channel.enable = true;
    gc = {
      automatic = true;
      dates = "22:00";
      options = "--delete-older-than 3d";
      persistent = true;
      randomizedDelaySec = "0";
    };
    optimise = {
      automatic = true;
      persistent = true;
      randomizedDelaySec = "0";
      dates = [
        "06:00"
        "18:00"
        "22:00"
      ];
    };

    settings = {
      allowed-users = [
        "*"
      ];
      auto-optimise-store = true;
      cores = 0;
      extra-sandbox-paths = [];
      max-jobs = "auto";
      require-sigs = true;
      sandbox = true;
      show-trace = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
