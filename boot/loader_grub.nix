{pkgs, ...}: {
  boot.loader = {
    grub = {
      enable = true;
      devices = ["nodev"];
      efiInstallAsRemovable = false;
      efiSupport = true;
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
        echo 'Patching theme::'
        ${pkgs.imagemagick}/bin/magick /sys/firmware/acpi/bgrt/image PNG24:./bgrt.png
        echo '+ image {' >> ./theme.txt
        echo '  left = $(</sys/firmware/acpi/bgrt/xoffset)' >> theme.txt
        echo '  top  = $(</sys/firmware/acpi/bgrt/yoffset)' >> theme.txt
        echo '  file = "bgrt.png"' >> theme.txt
        echo '}' >> theme.txt
        echo 'Done.'
        echo

        echo "Generating initial config::"
        grub_tmp=$(${pkgs.coreutils}/bin/mktemp -d -t grub.conf.XXXXXX)
        trap '${pkgs.coreutils}/bin/rm -rf -- "$grub_tmp"' EXIT
        echo 'set check_signatures=enforce' >> $grub_tmp/grub.cfg
        echo 'export check_signatures' >> $grub_tmp/grub.cfg 
        echo 'set superusers="root"' >> $grub_tmp/grub.cfg 
        echo 'password_pbkdf2 root grub.pbkdf2.sha512.10000.6246D66661994460C930AA2CD15F0BC839538DEEFCA92B3573C1737AAD403D779CD1ACBC42EA6343E8134F7C129217AC32780F03FC4F3201013BDC1B4FC3CE76.E9555647B30D8D0CE089F3618BAEB915D388BABA248A1DF0AD5FAE8AA7485CB5D359B8436F89162E103755296434BAB9AA2F2CB2CE576011DC01E9FB4D8F79D0' >> $grub_tmp/grub.cfg 
        echo 'search --set=drive1 --no-floppy --fs-uuid B121-36EC' >> $grub_tmp/grub.cfg 
        echo 'configfile /grub.cfg' >> $grub_tmp/grub.cfg 
	echo 'echo Fail!! fixme' >> $grub_tmp/grub.cfg 
        #  echo Validation failed! rebooting in 3sec
        #  sleep 3
        #  reboot
        echo 'Done.'
        echo

        echo 'Export GPG to sign config and embed to binary::'
        GPGKey='E5A46314BC7A0984051A6DDB75613BD727012E40'
        ${pkgs.gnupg}/bin/gpg --export "$GPGKey" > /tmp/grub_gpg.key
        ${pkgs.gnupg}/bin/gpg --default-key "$GPGKey" --detach-sign $grub_tmp/grub.cfg
        #${pkgs.gnupg}/bin/gpg --default-key "$GPGKey" --detach-sign /boot/grub/grub.cfg

        echo 'Building grub::'
        ${pkgs.grub2_efi}/bin/grub-mkimage \
          --disable-shim-lock \
          -p /boot/grub \
          -O x86_64-efi \
          -c $grub_tmp/grub.cfg \
          -o /boot/efi/NixOS-boot/grubx64.efi \
          -k /tmp/grub_gpg.key \
          all_video boot btrfs cat chain configfile echo efifwsetup efinet ext2 fat font gettext gfxmenu gfxterm gfxterm_background gzio halt help hfsplus iso9660 jpeg keystatus loadenv loopback linux ls lsefi lsefimmap lsefisystab lssal memdisk minicmd normal ntfs part_apple part_msdos part_gpt password_pbkdf2 png probe reboot regexp search search_fs_uuid search_fs_file search_label sleep smbios squash4 test true video xfs zfs zfscrypt zfsinfo play cpuid tpm cryptodisk luks lvm mdraid09 mdraid1x raid5rec raid6rec diskfilter cryptodisk luks gcry_rijndael gcry_sha256 ext2 memdisk tar at_keyboard keylayouts configfile
        ${pkgs.coreutils}/bin/rm /tmp/grub_gpg.key
        echo 'signing GRUB and kernel::'
        ${pkgs.sbctl}/bin/sbctl sign /boot/efi/NixOS-boot/grubx64.efi
        ${pkgs.sbctl}/bin/sbctl sign /boot/kernels/$(${pkgs.coreutils}/bin/cat /boot/grub/grub.cfg | ${pkgs.gnugrep}/bin/grep 'bzImage'  | ${pkgs.coreutils}/bin/cut -f4 -d '/' | ${pkgs.coreutils}/bin/cut -f1 -d ' ' | ${pkgs.coreutils}/bin/head -n 1)
        ${pkgs.gnupg}/bin/gpg --default-key "$GPGKey" --detach-sign /boot/kernels/$(${pkgs.coreutils}/bin/cat /boot/grub/grub.cfg | ${pkgs.gnugrep}/bin/grep 'initrd'  | ${pkgs.coreutils}/bin/cut -f4 -d '/' | ${pkgs.coreutils}/bin/cut -f1 -d ' ' | ${pkgs.coreutils}/bin/head -n 1)
      '';
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };
}
