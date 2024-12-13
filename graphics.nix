#   ____                 _     _           _                      _                                      _
#  / ___|_ __ __ _ _ __ | |__ (_) ___ __ _| |      ___ _ ____   _(_)_ __ ___  _ __  _ __ ___   ___ _ __ | |_
# | |  _| '__/ _` | '_ \| '_ \| |/ __/ _` | |     / _ \ '_ \ \ / / | '__/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __|
# | |_| | | | (_| | |_) | | | | | (_| (_| | |    |  __/ | | \ V /| | | | (_) | | | | | | | | |  __/ | | | |_
#  \____|_|  \__,_| .__/|_| |_|_|\___\__,_|_|     \___|_| |_|\_/ |_|_|  \___/|_| |_|_| |_| |_|\___|_| |_|\__|
#                 |_|
# Determine functions
{pkgs, ...}: {
  # Enable X11
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };
  # Enabling DE/WM/DM
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
