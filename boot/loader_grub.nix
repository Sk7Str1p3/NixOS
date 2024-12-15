{
  pkgs,
  lib,
  config,
  ...
}: {
  boot.loader = {
    generationsDir.enable = true;
    grub = {
      enable = true;
      devices = ["nodev"];
      efiInstallAsRemovable = false;
      efiSupport = true;
      users.root.hashedPassword = "grub.pbkdf2.sha512.10000.48C7839865DFA9077AAD8A5F6F7D68B71794D8C1B1C039A94633D07ED5D6A0B7A708364DCE7A0423F76B712CD49C3515CBB489BD6C1C0833A6BB3E9C9B744956.0A61094935BE41BA940A023D812A4FD8657ADE921B496DFC2F11DD25CE954416F2B16F7B91BC2848CD56B4728964C106ABB0FAB50D9C37C498B148567F69CB7B";
      splashImage = null;
      memtest86 = {
        enable = true;
        params = [
          "btrace"
        ];
      };
      extraEntries = ''
        menuentry 'Windows 11' --unrestricted --class windows --class os $menuentry_id_option 'osprober-efi-B121-36EC' {
          insmod part_gpt
          insmod fat
          search --no-floppy --fs-uuid --set=root B121-36EC
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
        submenu "Power" --class submenu --class shutdown --unrestricted {
          menuentry "Power Off" --class shutdown {
            halt
          }
          menuentry "Reboot" --class restart {
            reboot
          }
        }
        if [ "$grub_platform" = "efi" ]; then
          insmod bli
        fi

        if [ "$grub_platform" = "efi" ]; then
          fwsetup --is-supported
          if [ "$?" = 0 ]; then
            menuentry 'UEFI Firmware Settings' $menuentry_id_option 'uefi-firmware' {
              fwsetup
            }
          fi
        fi
      '';
      extraEntriesBeforeNixOS = true;
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
      extraInstallCommands = ''
        cd /boot/theme
        ${pkgs.imagemagick}/bin/magick /sys/firmware/acpi/bgrt/image PNG24:./bgrt.png
        echo '+ image {' >> ./theme.txt
        echo "    left = $(</sys/firmware/acpi/bgrt/xoffset)" >> ./theme.txt
        echo "    top  = $(</sys/firmware/acpi/bgrt/yoffset)" >> ./theme.txt
        echo '    file = "bgrt.png"' >> ./theme.txt
        echo '}' >> ./theme.txt

        echo "Building REAL grub image::"
        grub_tmp=$(${pkgs.coreutils}/bin/mktemp -d -t grub.conf.XXXXXX)
        trap '${pkgs.coreutils}/bin/rm -rf -- "$grub_tmp"' EXIT
        echo 'set root=(memdisk)' >> $grub_tmp/grub.cfg
        echo 'set prefix=($root)/grub' >> $grub_tmp/grub.cfg
        echo 'configfile ($prefix)/grub.cfg' >> $grub_tmp/grub.cfg

        cd /boot/
        ${pkgs.coreutils}/bin/rm -rf memdisk
        ${pkgs.coreutils}/bin/mkdir memdisk
        ${pkgs.coreutils}/bin/cp -r grub/ memdisk/grub
        ${pkgs.coreutils}/bin/cp -r theme/ memdisk/theme
        cd memdisk
        ${pkgs.gnutar}/bin/tar -cf md.tar *

        ${pkgs.grub2_efi}/bin/grub-mkimage \
          -p '(memdisk)/boot/grub' \
          -m md.tar \
          --disable-shim-lock \
          -O x86_64-efi \
          -c $grub_tmp/grub.cfg \
          -o /boot/EFI/NixOS-boot/grubx64.efi \
          all_video boot btrfs cat chain configfile echo efifwsetup efinet ext2 fat font gettext gfxmenu gfxterm gfxterm_background gzio halt help hfsplus iso9660 jpeg keystatus loadenv loopback linux ls lsefi lsefimmap lsefisystab lssal memdisk minicmd normal ntfs part_apple part_msdos part_gpt password_pbkdf2 png probe reboot regexp search search_fs_uuid search_fs_file search_label sleep smbios squash4 test true video xfs zfs zfscrypt zfsinfo play cpuid tpm cryptodisk luks lvm mdraid09 mdraid1x raid5rec raid6rec diskfilter cryptodisk luks gcry_rijndael gcry_sha256 ext2 memdisk tar at_keyboard keylayouts configfile

        echo 'signing grub'
        ${pkgs.sbctl}/bin/sbctl sign /boot/EFI/NixOS-boot/grubx64.efi
      '';
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };
}
