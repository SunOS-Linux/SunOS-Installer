#!/usr/bin/env bash
#-------------------------------------------------------------------------
#  Sun Installer
#   Version 2021.04   (C) 2021 Morales Research Corporation
#-------------------------------------------------------------------------

echo -e "\nINSTALLING AUR SOFTWARE and Proprietary Sun Kernel!\n"

cd "${HOME}"

echo "CLONING: RPM-builder"
echo "(C) 2012 Red Hat Inc"
git clone "https://aur.archlinux.org/rpm-builder.git"
cd ${HOME}/rpm-builder
makepkg -si

ehco "Cloning: DNF"
echo "Dandified YUM"
git clone "https://aur.archlinux.org/dnf.git"
cd ${HOME}/dnf

echo "Cloning: SELinux"
git clone "https://aur.archlinux.org/linux-vanilla-selinux.git"

cd ${HOME}/linux-vanilla-selinux
makepkg -si

echo "Cloning the Sun Kernel"
echo "(C) 2020 Morales Research Corp."
git clone "https://github.com/SunOS-Linux/Sun-Kernel"
echo "Download complete!"
echo "Please compile the kernel!"
echo "For more Information and instructions, go to https://www.kernel.org/doc/html/latest/"

echo "Cloning doas"
git clone "https://aur.archlinux.org/doas.git"
cd ${HOME}/doas
makepkg -si

cd ${HOME}/Sun-Kernel/2.1.0
make menuconfig

echo -e "\nDone! Installed YUM\n"
echo -e "\nDone! Installed RPM-Builder\n"
echo -e "\nFinished downloading kernel!\n"
echo -e "\nFinished downloading SELinux\n"
echo -e "\nDone Installing AUR packages!\n"
