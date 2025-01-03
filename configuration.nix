# Your NixOS configuration. Here's the structure:
{pkgs, ...}: {
  imports = [
    ./hardware
    ./network.nix
    ./boot
    ./graphics
    ./network
    ./virtualisation
    ./services
    ./security
    ./programs
  ];

  appstream.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.seahorse.enable = true;
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.openssh.enable = true;
  programs.fish.enable = true;
  programs.obs-studio.enable = true;
  users.users.Sk7Str1p3 = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      kitty
      home-manager
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    libreoffice
    fish
    ntfs3g
    polkit_gnome
    nautilus
    gparted
    nixd
    wl-clipboard
    sbctl
    pkgsi686Linux.gnutls
    ripgrep
    binutils
    cryptsetup
    file-roller
    sbctl
    git
    (ventoy.override {
      defaultGuiType = "gtk3";
      withGtk3 = true;
    })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.fwupd.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.

  system.stateVersion = "25.05"; # DO NOOOOOT CHANGE THIS!!!! NEVER!!!!
}
