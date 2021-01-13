#!/usr/bin/env bash
#-------------------------------------------------------------------------
#      _          _    __  __      _   _
#     /_\  _ _ __| |_ |  \/  |__ _| |_(_)__
#    / _ \| '_/ _| ' \| |\/| / _` |  _| / _|
#   /_/ \_\_| \__|_||_|_|  |_\__,_|\__|_\__|
#  Arch Linux Post Install Setup and Config
#-------------------------------------------------------------------------

echo -e "\nINSTALLING AUR SOFTWARE\n"

cd "${HOME}"

echo "CLONING: YUM"
git clone "https://aur.archlinux.org/yum.git"


PKGS=(

    # UTILITIES -----------------------------------------------------------

    'synology-drive'            # Synology Drive
    'libreoffice'                # Office Alternative
    
    # MEDIA ---------------------------------------------------------------

    'lbry-app-bin'              # LBRY Linux Application

    # COMMUNICATIONS ------------------------------------------------------

    'brave-nightly-bin'         # Brave
    

)


cd ${HOME}/yum
makepkg -si

for PKG in "${PKGS[@]}"; do
    pacman -S --noconfirm $PKG
done

echo -e "\nDone!\n"
