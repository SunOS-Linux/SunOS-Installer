#!/usr/bin/env bash
#-------------------------------------------------------------------------
# Sun/OS Installer for Sun/OS and Sun Systems
#   Version 2021.02     (C) 2021 Abdon Morales Jr
#-------------------------------------------------------------------------

echo -e "\nINSTALLING AUR SOFTWARE\n"

cd "${HOME}"

echo "CLONING: YUM"
git clone "https://aur.archlinux.org/yum.git"

cd ${HOME}/yum
makepkg -si

echo -e "\nDone!\n"
