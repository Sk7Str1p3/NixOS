{pkgs, ...}: {
  config = {
    services.displayManager = {
      # defaultSession = "hyprland";
      sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        wayland = {
          enable = true;
          compositor = "weston";
        };
        theme = "catppuccin-mocha";
      };
    };
    environment.systemPackages = [
      (pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        font = "JetBrainsMono Nerd Font Propo";
        fontSize = "12";
        loginBackground = true;
      })
    ];
  };
}
