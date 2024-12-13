{pkgs, ...}: {
  services.displayManager = {
    defaultSession = "Hyprland";
    sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      wayland = {
        enable = true;
        compositor = "weston";
      };
      theme = pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        font = "JetBrainsMono Nerd Font Propo";
        fontSize = "12";
        background = "${./wallpaper.png}";
        loginBackground = true;
      };
    };
  };
}
