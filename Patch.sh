uname -r
echo "Loading Sun Patcher"
echo
echo "(C) 2021 Morales Research Corporation"
echo
echo "Sun Patcher"
echo "v2021.02"
echo "Detecting System"
lsb-release
cat /etc/os-release # Change this if os release filename is different
echo "Operating System detected"
echo "Now patching system"
pacman -Syu
echo "Now cloning AUR Doas"
git clone "https://aur.archlinux.org/doas.git"
echo "DOAS is now clone"
echo "Description"
echo "Doas is alternative to sudo to maintain stability with non-previliged users for Linux and Unix operating systems - this will support for future versions of Sun/OS for the forseeable future"
cd ${HOME}/doas
makepkg -si
echo "If the autoinstall failed please run makepkg -si in sudo"

echo "The system has been patched!"
whereis doas
echo "Please reboot the system, in order for the patch to take affect"
echo
echo "Patcher contains BSD-3 License, for more please go to our GitHub to read the license"
clear
