
# Updating system to latest release --->Update script with the new one once the Git repo is updates

echo "Updating Sun/OS to latest version"

# Start replacing codename and version with the most updated release

 nano /etc/os-release

sed -i '4s/2021.01.01/2021.02' /etc/os-release

sed -i '5s/Waco/Dallas' /etc/os-release

echo "System updated successfully"

echo "Sun/OS update installed"

sudo pacman -Syy

sudo pacman -Syu

echo "Now updated to Sun/OS v2021.02 (Dallas)!"

echo "Reloading Sun/OS"

echo "Done!"
echo "(C) 2021 Abdon Morales Jr - Andrew Riefenstahl"
exit
