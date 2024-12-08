# ____              _   
#| __ )  ___   ___ | |_ 
#|  _ \ / _ \ / _ \| __|
#| |_) | (_) | (_) | |_ 
#|____/ \___/ \___/ \__|

# Determine functions
{
  config,
  lib,
  pkgs,
  ...
}:

############# Grub configuration #############
{
#  nixpkgs.overlays = [
#    (final: prev: {
 #     grub2 = prev.grub2.overrideAttrs (attrs: {
  #      #src = prev.fetchgit {
   #     #  url = "https://git.savannah.gnu.org/git/grub.git";
    #    #  sha256 = "sha256-iN1dhZ2cMbtkNYX3z7vEXI3fZudLxkpBiHArifwQ/tE=";
     #   #};
      #  patches = [
       #   # Argon2id patches
        #  (prev.fetchpatch {
        #    name = "argon_1.patch";
        #    url = "https://aur.archlinux.org/cgit/aur.git/plain/argon_1.patch?h=grub-improved-luks2-git";
         #   sha256 = "sha256-WCt+sVr8Ss/bAI41yMJmcZoIPVO1HFEjw1OVRUPYb+w=";
          #})
#          (prev.fetchpatch {
 #           name = "argon_2.patch";
  #          url = "https://aur.archlinux.org/cgit/aur.git/plain/argon_2.patch?h=grub-improved-luks2-git";
   #         sha256 = "sha256-OMQYjTFq0PpO38wAAXRsYUfY8nWoAMcPhKUlbqizIS8=";
    #      })
     #     (prev.fetchpatch {
      #      name = "argon_3.patch";
       #     url = "https://aur.archlinux.org/cgit/aur.git/plain/argon_3.patch?h=grub-improved-luks2-git";
        #    sha256 = "sha256-rxtvrBG4HhGYIvpIGZ7luNH5GPbl7TlqbNHcnR7IZc8=";
         # })
          #(prev.fetchpatch {
           # name = "argon_4.patch";
            #url = "https://aur.archlinux.org/cgit/aur.git/plain/argon_4.patch?h=grub-improved-luks2-git";
#            sha256 = "sha256-Hz88P8T5O2ANetnAgfmiJLsucSsdeqZ1FYQQLX0WP3I=";
 #         })
  #        (prev.fetchpatch {
   #         name = "argon_5.patch";
    #        url = "https://aur.archlinux.org/cgit/aur.git/plain/argon_5.patch?h=grub-improved-luks2-git";
     #       sha256 = "sha256-cs5dKI2Am+Kp0/ZqSWqd2h/7Oj+WEBeKgWPVsCeMgwk=";
      #    })
       #   (prev.fetchpatch {
        #    name = "grub-install_luks2.patch";
         #   url = "https://aur.archlinux.org/cgit/aur.git/plain/grub-install_luks2.patch?h=grub-improved-luks2-git";
          #  sha256 = "sha256-I+1Yl0DVBDWFY3+EUPbE6FTdWsKH81DLP/2lGPVJtLI=";
#          })
 #       ];
  #      nativeBuildInputs =
   #       (builtins.filter (x: x.name != "autoreconf-hook") attrs.nativeBuildInputs)
    #      ++ (with final; [
     #       autoconf
      #      automake
       #   ]);
#
 #       preConfigure =
  #        let
   #         gnulib = final.fetchgit {
    #          url = "https://git.savannah.gnu.org/r/gnulib.git";
     #         sha256 = "sha256-hvduGEglL48COscpqhwvM6nLl+O/lzGmaIXA8naZfBo=";
      #      };
       #   in
        #  builtins.replaceStrings [ "patchShebangs ." ] [
         #   ''
          #    patchShebangs .
#
 #             ./bootstrap --no-git --gnulib-srcdir=${gnulib}
  #          ''
   #       ] attrs.preConfigure;
#
 #       configureFlags = attrs.configureFlags ++ [
  #        "--disable-nls"
   #       "--disable-silent-rules"
    #      "--disable-werror"
     #   ];
#      #});
 #   })
  #];
  boot.loader = {
    grub =
      let
        inherit (lib) escapeShellArg;
        out = "${config.boot.loader.efi.efiSysMountPoint}/EFI/NixOS-boot-efi/grubx64.efi";
      in
      {
        enable = true;
        enableCryptodisk = true;
        devices = [ "nodev" ];
        efiInstallAsRemovable = false;
        efiSupport = true;
        # extraGrubInstallArgs = [ "--modules=$(basename --suffix .mod /boot/grub/x86_64-efi/*.mod)" ];
        extraInstallCommands = ''
                              grub_tmp=$(${pkgs.coreutils}/bin/mktemp -d -t grub.conf.XXXXXX)
          		    modules=$(${pkgs.coreutils}/bin/basename --suffix .mod /boot/grub/x86_64-efi/*.mod)
                              trap '${pkgs.coreutils}/bin/rm -rf -- "$grub_tmp"' EXIT
                    	  ${pkgs.coreutils}/bin/cat <<EOS >"$grub_tmp/grub.cfg"
                    	    cryptomount -u $(${pkgs.utillinux}/bin/blkid -o value -s UUID ${escapeShellArg config.boot.initrd.luks.devices.NixOS.device})
                                set root=(crypto0)
                    	    set prefix=(crypto0)/boot/grub
                    	  EOS

                    	  mkdir -p ${escapeShellArg (builtins.dirOf out)}
                    	  ${pkgs.grub2}/bin/grub-mkimage \
                    	  -p '(crypto0)/boot/grub' \
                    	  -O x86_64-efi \
                    	  -c $grub_tmp/grub.cfg \
                    	  -o ${escapeShellArg out} \
                    	  $modules
        '';
        useOSProber = true;
      };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };
}
