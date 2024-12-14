{pkgs, ...}: {
  boot.loader = {
    grub = {
      enable = true;
      devices = ["nodev"];
      efiInstallAsRemovable = false;
      efiSupport = true;
      useOSProber = true;
      users.root.hashedPassword = "grub.pbkdf2.sha512.10000.48C7839865DFA9077AAD8A5F6F7D68B71794D8C1B1C039A94633D07ED5D6A0B7A708364DCE7A0423F76B712CD49C3515CBB489BD6C1C0833A6BB3E9C9B744956.0A61094935BE41BA940A023D812A4FD8657ADE921B496DFC2F11DD25CE954416F2B16F7B91BC2848CD56B4728964C106ABB0FAB50D9C37C498B148567F69CB7B";
      splashImage = null;
      memtest86 = {
        enable = true;
        params = [
          "btrace"
        ];
      };
      extraEntries = ''
        submenu "Power" --class submenu --class shutdown --unrestricted {
          menuentry "Power Off" --class shutdown {
            halt
          }
          menuentry "Reboot" --class restart {
            reboot
          }
        }
      '';
      extraPerEntryConfig = "--unrestricted";
      default = 5;
      theme = pkgs.stdenv.mkDerivation {
        pname = "grub-bgrt";
        version = "2.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "logonoff";
          repo = "bgrt-grub-theme";
          rev = "2.0.1";
          hash = "sha256-aRJ9x/ZeunTLavTCziTzhqHKTgECEY2EKXcIFWp+tLU=";
        };
        buildPhase = ''
          runHook preBuild
          cp ./theme.txt ./theme/theme.txt
          runHook postBuild
        '';
        installPhase = ''
          runHook preInstall
          cp -r ./theme "$out"
          runHook postInstall'';
      };
      extraGrubInstallArgs = ["--disable-shim-lock"];
      extraInstallCommands = ''
        cd /boot/theme
        ${pkgs.imagemagick}/bin/magick /sys/firmware/acpi/bgrt/image PNG24:./bgrt.png
        echo '+ image {' >> ./theme.txt
        echo "    left = $(</sys/firmware/acpi/bgrt/xoffset)" >> ./theme.txt
        echo "    top  = $(</sys/firmware/acpi/bgrt/yoffset)" >> ./theme.txt
        echo '    file = "bgrt.png"' >> ./theme.txt
        echo '}' >> ./theme.txt
      '';
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };
}
