# ____              _
#| __ )  ___   ___ | |_
#|  _ \ / _ \ / _ \| __|
#| |_) | (_) | (_) | |_
#|____/ \___/ \___/ \__|
# Determine functions

############# Grub configuration #############
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

