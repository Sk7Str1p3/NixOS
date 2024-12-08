# Your NixOS configuration. Here's the structure:
{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./boot.nix
    ./network.nix
    ./graphics.nix
  ];

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  security.polkit = {
    enable = true;
    extraConfig = ''
         polkit.addRule(function(action, subject) {
           if (
             subject.isInGroup("wheel")
        && (
          action.id == "org.freedesktop.login1.reboot" ||
          action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
          action.id == "org.freedesktop.login1.power-off" ||
          action.id == "org.freedesktop.login1.power-off-multiple-sessions"
        )
      )
           {
             return polkit.Result.YES;
           }
         });
    '';
  };
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  programs.seahorse.enable = true;
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      package = pkgs.qemu_kvm;
    };
  };
  programs.virt-manager.enable = true;

  services.gvfs.enable = true;
  services.openssh.enable = true;
  services.udisks2.enable = true;
  programs.fish.enable = true;
  users.users.Sk7Str1p3 = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel"];
  };

  environment.systemPackages = with pkgs; [
    wget
    iwd
    sddm
    libreoffice
    fish
    ntfs3g
    xwayland
    polkit_gnome
    nautilus
    gparted
    nixd
    wl-clipboard
    ripgrep
    binutils
    cryptsetup
    git
    file-roller
    brightnessctl
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
  system.copySystemConfiguration = true;

  system.stateVersion = "24.05"; # DO NOOOOOT CHANGE THIS!!!! NEVER!!!!
}
