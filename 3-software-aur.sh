#!/usr/bin/env bash
#-------------------------------------------------------------------------
# Sun/OS Installer for Sun/OS and Sun Systems
#   Version 2021.02     (C) 2021 Abdon Morales Jr
#-------------------------------------------------------------------------

echo -e "\nINSTALLING AUR SOFTWARE and Proprietary Sun Kernel!\n"

cd "${HOME}"

echo "CLONING: YUM"
echo "(C) 2011 Seth Vidal"
git clone "https://aur.archlinux.org/yum.git"

cd ${HOME}/yum
makepkg -si

echo "CLONING: RPM-builder"
echo "(C) 2012 Red Hat Inc"
git clone "https://aur.archlinux.org/rpm-builder.git"

cd ${HOME}/rpm-builder
makepkg -si

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

cd ${HOME}/Sun-Kernel/SUN-5.10.6
make menuconfig

echo -e "\nDone! Installed YUM\n"
echo -e "\nDone! Installed RPM-Builder\n"
echo -e "\nFinished downloading kernel!\n"
echo -e "\nFinished downloading SELinux\n"
echo -e "\nDone Installing AUR packages!\n"
