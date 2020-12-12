#!/usr/bin/env bash
#Updating system to latest release --->Update script with the new one once the Git repo is updates

echo "Updating Sun/OS to latest version"

# Start replacing codename and version with the most updated release

 nano /etc/os-release

sed -i '4s/2020.12.09/2021.01.01' /etc/os-release

sed -i '5s/Mount Bonnell/Waco' /etc/os-release

echo "System updated successfully"

echo "Sun/OS update installed"

sudo pacman -Syy

sudo pacman -Syu

echo "System now rebooting to apply update"
echo
echo
echo
echo

sudo reboot
