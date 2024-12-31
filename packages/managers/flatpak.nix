{pkgs, ...}: {
  services.flatpak.enable = true;

  systemd.services.flathub = {
    wantedBy = [
      "multi-user.target"
    ];
    path = [
      pkgs.flatpak
    ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
