#!/bin/bash

# Version 2021.03
#
# Created by Abdon Morales
# (C) 2021 Morales Research Corporation 
# sun-aip.sh file
# For Sun Systems ---> i386 and amd64
#
echo "Sun-AIP v4.0.0  (C) 2021 Morales Research Corporation "
#
# text formatting codes
# source https://github.com/nbros652/LUKS-guided-manual-partitioning/blob/master/LGMP.sh
#
normalText='\e[0m'
boldText='\e[1m'
yellow='\e[93m'
green='\e[92m'
red='\e[91m'

#
# check if running as root
#
if [ "$(whoami)" != "root" ]; then
    echo -e "${boldText}${red}This script must be executed as root."${normalText}
    exit 0
fi

#
# install this package to check which OS is running
#
pacman -Sy &>/dev/null && pacman -S lsb-release --noconfirm --needed &>/dev/null

# Verify Arch Linux is running
if [ ! -f /usr/bin/pacman ]; then
    echo "Pacman Package Manager was not found in this system, execution aborted."
    exit
    else
        pacman -S lsb-release --noconfirm --needed &>/dev/null
        os=$(lsb_release -ds | sed 's/"//g')
fi

if [ "${os}" != "Arch Linux""SunOS Linux" ]; then
    echo "You must be using Arch Linux or Sun/OS to execute this script."
    exit 1
fi

function welcome() {
    clear
    sudo pacman -S figlet --noconfirm --needed &>/dev/null
    figlet -c "Sun/OS"
    figlet -c "AIP"
    sudo pacman -Rncsd figlet --noconfirm &>/dev/null
    kernelVer="$(uname -r)"
    echo -e "Welcome to the Sun Automated Installation Procedure tool!\nCreated by SunOS Linux Team!\nKernel version: ${kernelVer}\n"
}

function root {
    # based of
    # source: https://github.com/SunOS-Linux/SunOS-Installer
    # author: Sun/OS Linux
    if [[ ! -d ~/.config/archlinux-aip/ ]]; then
        mkdir -p ~/.config/archlinux-aip/
    fi

    if ! source ~/.config/archlinux-aip/main.conf &>/dev/null; then
        echo -e "${red}${boldText}:: ERROR: Configuration file 'archlinux-aip.conf' not found. Creating a new one...\n"
        echo -e "\n${yellow}${boldText}:: Pacman Mirrorlist Settings${normalText}\n"
        read -p "Where do you live? (Example: United States): " country
        echo -e "\n\n${yellow}${boldText}:: System Settings${normalText}\n"
        read -p "Which is your region? (Example: US): " region
        read -p "Which is your city? (Example: California): " city
        read -p "Which language do you natively speak? (Example: en_US.UTF-8): " lang
        read -p "Which is your keyboard from? (Example: en): " keymap
        read -p "How shall your computer be known on the network and/or locally?: " hostname
        read -p "Now type in your username (All lowercase and without spaces): " username
        read -p "Which is your favorite editor? (nano, vi or vim): " editor
        read -p "Which platform do you prefer to use with QT applications? (wayland or xcb): " qtplatform
        read -p "Which theme do you prefer to use with QT applications? (gtk2, gtk3 or qt5ct): " qtplatformtheme
        while true; do
        read -s -p "Type a password for the username "${username}": " password1
        echo ""
        read -s -p "Repeat the password: " password2

        # Check if both passwords match
        if [ "${password1}" != "${password2}" ]; then
            echo -e "\n\n${red}${boldText}:: ERROR: Passwords did not match. Try again.${normalText}\n"
            password1=""
            password2=""
            else
                break
        fi
        done
        printf '[Pacman Mirrorlist Settings]\ncountry="${country}"\n\n[System Settings}\nregion="${region}"\ncity="${city}"\nlang="${lang}"\nkeymap="${keymap}"\nhostname="${hostname}"\neditor="${editor} visudo"\nqtplatform="${qtplatform}"\nqtplatformtheme="${qtplatformtheme}"\n\n[User Settings]\nusername="${username}"\npassword="${password}"' > ~/.config/archlinux-aip/main.conf
        else
            source ~/.config/archlinux-aip/main.conf &>/dev/null
            echo -e "${green}${boldText}:: Your configuration file was found and loaded successfully!${normalText}\n"
    fi
}

function diskPartitioning() {
    echo -e "${yellow}${boldText}:: Installing dependencies...${normalText} \n"
    pacman -Syyy &>/dev/null && sudo pacman -S cryptsetup lvm2 --needed --noconfirm &>/dev/null && echo -e "${green}${boldText}done${normalText}\n" || echo -e "${red}${boldText}failed${normalText}\n"

    read -p ":: Select a device to start ('/dev/' is not needed): " disk
    echo -e "${yellow}${boldText}:: Creating GUID Partition Table...${normalText} \n"
    parted /dev/${disk} mklabel gpt

    echo -e "${yellow}${boldText}:: Creating EFI partition...${normalText} \n"
    sgdisk /dev/${disk} -n=1:0:+100M -t=1:ef00 #&>/dev/null

    echo -e "${yellow}${boldText}:: Creating boot partition...${normalText} \n"
    sgdisk /dev/${disk} -n=2:0:+500M -t=1:8200 #&>/dev/null

    echo -e "\n\n\n"

    lsblk

    echo -e "\n"
    read -p ":: Select the EFI partition ('/dev/' is not needed): " efiPartition

    echo ""
    read -p ":: Select the boot partition ('/dev/' is not needed): " bootPartition

    echo ""
    read -p ":: Select a device to encrypt ('/dev/' is not needed): " luksDevice
    cryptsetup luksFormat /dev/${luksDevice}
    luksDeviceUuid=$(blkid -s UUID -o value /dev/${luksDevice})
    
    echo -e "\n"
    read -p ":: Type a name for the LUKS container in ${luksDevice}, afterwards, unlock it: " luksContainer
    cryptsetup open /dev/${luksDevice} ${luksContainer}

    echo -e "\n"
    echo -e ":: Creating physical LVM volume on /dev/${luksContainer}... "
    pvcreate /dev/mapper/${luksContainer} &>/dev/null

    echo -e "\n"
    read -p ":: Type a name for the LVM group: " lvmGroup
    vgcreate ${lvmGroup} /dev/${luksContainer}

    while true; do
        read -p ":: Do you want to create a swap partition? [Y/N] " input
            case ${input} in
                [Yy]* ) read -p "How much space do you want to allocate for the swap partition? (Example: 4G): " swapLvmPartitionSize; lvcreate -L ${swapLvmPartitionSize} ${lvmGroup} -n swap; break;;
                [Nn]* ) echo -e "${yellow}${boldText}:: WARNING: No swap file will be created by your request.${normalText} \n"; break;;
                * ) echo -e ":: ERROR: Please type 'y' or 'n', and try again.${normalText} \n"
            esac
    done

    read -p ":: How much space do you want to allocate for the root partition? (Default: 30G): " rootLvmPartitionSize
    lvcreate -L ${rootLvmPartitionSize} ${lvmGroup} -n root

    read -p ":: How much space do you want to allocate for the home partition? (Default: all space left): " homeLvmPartitionSize
    lvcreate -L ${homeLvmPartitionSize} ${lvmGroup} -n home

    echo -e "${yellow}${boldText}:: Formatting devices with ext4 filesystem...${normalText} \n"
    mkfs.ext4 /dev/${lvmGroup}/root
    mkfs.ext4 /dev/${lvmGroup}/home
    if [[ -f /dev/${lvmGroup}/swap ]]; then
        mkswap /dev/${lvmGroup}/swap
    fi

    echo -e "${yellow}${boldText}:: Mounting filesystem...${normalText} \n"
    mount /dev/${lvmGroup}/root /mnt
    mkdir /mnt/home && mount /dev/${lvmGroup}/home /mnt/home
    if [[ -f /dev/${lvmGroup}/swap ]]; then
        swapon /dev/${lvmGroup}/swap
    fi
    mkdir -p /boot/efi
    mount /dev/${bootPartition} /mnt/boot
    mount /dev/${efiPartition} /mnt/boot/efi

    echo -e "${yellow}${boldText}:: Configuring mkinitpcio...${normalText} \n"
    sed -i 's/HOOKS=(base udev autodetect modconf filesystems keyboard fsck)/HOOKS=(base udev autodetect keyboard keymap consolefont modconf block encrypt lvm2 filesystems fsck)' /etc/mkinitpcio.conf

}

function baseSetup() {
    echo -e "${yellow}${boldText}:: Installing base system...${normalText} \n"
    pacstrap /mnt base base-devel linux linux-headers linux-firmware gdm &>/dev/null

    echo -e "${yellow}${boldText}:: Generating UUID-based '/etc/fstab' file...${normalText} \n"
    genfstab -U /mnt > /mnt/etc/fstab

    echo -e "${yellow}${boldText}:: Switching to installed Sun Base System...${normalText} \n"
    arch-chroot /mnt

    pacman -Sy && pacman -S reflector && reflector --country ${country} --sort rate --save /etc/pacman.d/mirrorlist

    sed -i 's/#[multilib]/[multilib]/g' /etc/pacman.conf
    sed -i '#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlist/g' /etc/pacman.conf
    sed -i 's/#RemoteFileSigLevel = Required/RemoteFileSigLevel = Required/g' /etc/pacman.conf
    
    pacman -Syyy && pacman -Syu

    ln -sf /usr/share/zoneinfo/${region}/${city} /etc/localtime && hwclock --systohc && sed -i 's/#${lang}/${lang}/g' /etc/locale.gen && locale-gen

    printf "LANG="${lang}"" > /etc/locale.conf
    printf "KEYMAP="${keymap}"" > /etc/vconsole.conf
    printf "EDITOR="${editor}"\nQT_QPA_PLATFORM="${qtplatform}"\nQT_QPA_PLATFORMTHEME="${qtplatformtheme}\nQT_PLUGIN_PATH=/usr/lib/qt/plugins"" >> /etc/enviroment
    printf "alias ron='xhost si:localuser:root'\nalias roff='xhost -si:localuser:root'\nalias ll='ls -ali --color=auto'\nalias cgwp='wallpaper-reddit'" > ~/.bash_aliases
    printf "# Load aliases and profile variables\nif [[ -f /etc/profile ]]; then\n    source /etc/profile\nfi\nif [[ -f ~/.bash_aliases ]]; then\n    source ~/.bash_aliases\nfi\n# PS1='[\u@\h \W] \$ '\nPS1='\u@\h \W \$ '" > ~/.bashrc

    cpuCores=$(grep -c ^processor /proc/cpuinfo)
    sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j${cpuCores}g' /etc/makepkg.conf
    sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T ${cpuCores} -z -)/g' /etc/makepkg.conf
    
    printf "kernel.dmesg_restrict = 1\nkernel.kptr_restrict = 1\nnet.core.bpf_jit_harden=2\nkernel.yama.ptrace_scope=3\nkernel.kexec_load_disabled = 1\nnet.ipv4.conf.default.rp_filter=1\nnet.ipv4.conf.all.rp_filter=1\nnet.ipv4.tcp_syncookies = 1\nnet.ipv4.tcp_rfc1337 = 1\nnet.ipv4.conf.default.log_martians = 1\nnet.ipv4.conf.all.log_martians = 1\nnet.ipv4.conf.all.accept_redirects = 0\nnet.ipv4.conf.default.accept_redirects = 0\nnet.ipv4.conf.all.secure_redirects = 0\nnet.ipv4.conf.default.secure_redirects = 0\nnet.ipv6.conf.all.accept_redirects = 0\nnet.ipv6.conf.default.accept_redirects = 0\nnet.ipv4.conf.all.send_redirects = 0\nnet.ipv4.conf.default.send_redirects = 0\nnet.ipv4.icmp_echo_ignore_all = 1\nnet.ipv6.icmp.echo_ignore_all = 1" > /etc/sysctl.confsysctl -p -q &>/dev/null
    printf "${hostname}" > /etc/hostname
    printf "127.0.0.1   localhost\n::1  localhost" > /etc/hosts
    pacman -S networkmanager --noconfirm --needed &>/dev/null

    printf "function update-grub {\n    sudo grub-mkconfig -o /boot/grub/grub.cfg\n}" /etc/profile.d/update-grub.sh
    printf "function update-initramfs {\n    sudo mkinitcpio -P\n}" /etc/profile.d/update-initramfs.sh
    source /etc/profile.d/update-grub.sh && source /etc/profile.d/update-initramfs.sh
    
    printf '#!/bin/bash

function scrcpy {
    if ! source ~/.config/scrcpy/main.conf &>/dev/null; then
        if [ ${deviceIp}="" ]; then
            read -p "There is no device IP established. Please type your device IP address: " input1
            deviceIp="${input1}"
        fi
        if [ ${internalDeviceName}="" ]; then
            read -p "There is no internal device name established. Please type a name: " input2
            internalDeviceName="${input2}"
        fi
        if [ ${deviceName}="" ]; then
            read -p "There is no device name established. Please type a name: " input3
            deviceName="${input3}"
            
            printf "[Settings]
deviceIp="${input1}"
internalDeviceName="${input2}"
deviceName="${input3}"" > ~/.config/scrcpy/main.conf
        fi        
        else
            source ~/.config/scrcpy/main.conf
    fi

    clear
    read -n1 -p ":: Make sure to enable developer tools, USB debugging and enable MTP, then press any key to continue..."

    echo -n ":: Starting ADB server... "
    adb start-server &>/dev/null && echo -e "done" || echo -e "failed"

    echo -n ":: Enabling device over TCP/IP... "
    adb tcpip 5555 &>/dev/null && echo -e "done" || echo -e "failed"

    read -n1 -p ":: Unplug the device now and press any key to continue... "

    echo -n ":: Connecting to device ${internalDeviceName}... "
    adb connect ${deviceIp}:5555 &>/dev/null && echo -e "done" || echo -e "failed"

    echo -n ":: Connected to device: ${internalDeviceName}"
    scrcpy --always-on-top --window-title ${deviceName} &>/dev/null

    echo -n ":: Closing ADB server... "
    adb kill-server &>/dev/null && echo -e "done" || echo -e "failed"
    }' /etc/modprobe.d/scrpy.sh

    sudo pacman -S grub --noconfirm --needed &>/dev/null
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=archlinux

    sed -i -e 's@GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"@GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID="${luksDeviceUuid}":"${luksContainer}" root=//dev//${lvmGroup}//root selinux=1 security=selinux apparmor=1 security=apparmor audit=1 lockdown=mode intel_iommu=on iommu=pt isolcpus=2,3,4,5 nohz_full=2,3,4,5 rcu_nocbs=2,3,4,5 default_hugepagesz=1G hugepagesz=1G hugepages=16 rd.driver.pre=vfio-pci video=efifb:off"@g' grub

    printf "options kvm_intel nested=1\noptions kvm-intel enable_shadow_vmcs=1\noptions kvm-intel enable_apicv=1\noptions kvm-intel ept=1" > /etc/modprobe.d/kvm.conf

    update-grub
    update-initramfs 

    echo -e "\n:: Please type in a password for the root user"
    passwd root
    
    echo -e "\n"

    while true; do
        read -p ":: Do you want to create your own user? [Y/n] " $input
        case $input in
            [Yy]* ) useradd -m ${username}; passwd ${password}; exit;;
            [Nn]* ) break;;
            * ) echo ":: Invalid parameter, please type Yy or Nn instead.";;
        esac
    done

    echo -e "\n:: Base System v4.0 is now ready for use\n"
    read -n1 -p ":: Press any key to continue..."
}

function aurSetup() {
    pacman -S git --nocm --needed &>/dev/null
    if [[ ! -d /opt/yay-git ]]; then
        cd /opt/
        git clone -q https://aur.archlinux.org/yay-git.git
        chown -R $username:$username yay-git/
        cd yay-git/
        makepkg -si --noconfirm &>/dev/null
        else
            cd /opt/yay-git/
            chown -R $username:$username .
            makepkg -si --noconfirm
    fi
}

function extrasSetup() {
    if [[ ${qtplatformtheme} != "qt5ct" ]]; then
    packagesArch="pacman-contrib qemu bridge-utils ovmf gedit bleachbit chrome-gnome-shell clamtk clamtk-gnome code fail2ban gimp adobe-source-han-{sans-cn-fonts,sans-tw-fonts,serif-cn-fonts,serif-tw-fonts} gnome-{backgrounds,screenshot,tweaks,terminal,control-center,keyring} libgnome-keyring gstreamer-vaapi intel-ucode libappindicator-{gtk2,gtk3} libreoffice libvdpau-va-gl lutris wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva libva-{intel,mesa}-driver lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader mokutil nautilus neofetch papirus-icon-theme pcsx2 pulseaudio pulseaudio-{jack,bluetooth} steam telegram-desktop unrar unzip xdg-user-dirs apparmor gvfs-{mtp,google} cups hplip"
    else
        packagesArch="pacman-contrib qemu bridge-utils ovmf gedit bleachbit chrome-gnome-shell clamtk clamtk-gnome code fail2ban gimp adobe-source-han-{sans-cn-fonts,sans-tw-fonts,serif-cn-fonts,serif-tw-fonts} gnome-{backgrounds,screenshot,tweaks,terminal,control-center,keyring} libgnome-keyring gstreamer-vaapi intel-ucode libappindicator-{gtk2,gtk3} libreoffice libvdpau-va-gl lutris wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva libva-{intel,mesa}-driver lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader mokutil nautilus neofetch papirus-icon-theme pcsx2 pulseaudio pulseaudio-{jack,bluetooth} steam telegram-desktop unrar unzip xdg-user-dirs apparmor gvfs-{mtp,google} cups hplip qt5ct"
    fi
    packagesAur="firefox-esr68 minecraft-launcher plata-theme-gnome psensor-git scrcpy whatsapp-for-linux spotify"
    if [[ ! -f /usr/bin/yay ]]; then
        echo -ne "\n\n\n${red}${boldText}:: ERROR: Yay AUR Helper was not found on this system and it is being installed now. Please wait...${normalText} "
    aurSetup &>/dev/null && echo -e "${green}done${normalText}" || echo -e "${red}failed"
    fi
    if [[ "$(whoami)" != "root" ]]; then
    printf "[Appearance]
color_scheme_path=/usr/share/qt5ct/colors/darker.conf
custom_palette=true
icon_theme=Papirus-Dark
standard_dialogs=default
style=Fusion

[Fonts]
fixed=@Variant(\0\0\0@\0\0\0\f\0R\0o\0\x62\0o\0t\0o@&\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
general=@Variant(\0\0\0@\0\0\0\f\0R\0o\0\x62\0o\0t\0o@&\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)

[Interface]
activate_item_on_single_click=1
buttonbox_layout=3
cursor_flash_time=1200
dialog_buttons_have_icons=1
double_click_interval=400
gui_effects=General, AnimateMenu, AnimateCombo, AnimateTooltip, AnimateToolBox
keyboard_scheme=4
menus_have_icons=true
show_shortcuts_in_context_menus=true
stylesheets=@Invalid()
toolbutton_style=4
underline_shortcut=1" > /home/$USER/.config/qt5ct/qt5ct.conf
        else
            printf "[Appearance]
color_scheme_path=/usr/share/qt5ct/colors/darker.conf
custom_palette=true
icon_theme=Papirus-Dark
standard_dialogs=default
style=Fusion

[Fonts]
fixed=@Variant(\0\0\0@\0\0\0\f\0R\0o\0\x62\0o\0t\0o@&\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
general=@Variant(\0\0\0@\0\0\0\f\0R\0o\0\x62\0o\0t\0o@&\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)

[Interface]
activate_item_on_single_click=1
buttonbox_layout=3
cursor_flash_time=1200
dialog_buttons_have_icons=1
double_click_interval=400
gui_effects=General, AnimateMenu, AnimateCombo, AnimateTooltip, AnimateToolBox
keyboard_scheme=4
menus_have_icons=true
show_shortcuts_in_context_menus=true
stylesheets=@Invalid()
toolbutton_style=4
underline_shortcut=1" > /root/.config/qt5ct/qt5ct.conf
    fi
    yay -Syyy && yay -Syu --noconfirm --needed && yay -S ${packagesArch} ${packagesAur} --noconfirm --needed &>/dev/null
    freshclam &>/dev/null && systemctl enable --now clamav-freshclam && systemctl enable --now fail2ban
    printf "#!/bin/bash
PATH=/usr/bin
alert="Signature detected: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME"

# Send the alert to systemd logger if exist, othewise to /var/log
if [[ -z $(command -v systemd-cat) ]]; then
        echo "$(date) - $alert" >> /var/log/clamav/detections.log
else
        # This could cause your DE to show a visual alert. Happens in Plasma, but the next visual alert is much nicer.
        echo "$alert" | /usr/bin/systemd-cat -t clamav -p emerg
fi

# Send an alert to all graphical users.
XUSERS=($(who|awk '{print $1$NF}'|sort -u))

for XUSER in $XUSERS; do
    NAME=(${XUSER/(/ })
    DISPLAY=${NAME[1]/)/}
    DBUS_ADDRESS=unix:path=/run/user/$(id -u ${NAME[0]})/bus
    echo "run $NAME - $DISPLAY - $DBUS_ADDRESS -" >> /tmp/testlog 
    /usr/bin/sudo -u ${NAME[0]} DISPLAY=${DISPLAY} \
                       DBUS_SESSION_BUS_ADDRESS=${DBUS_ADDRESS} \
                       PATH=${PATH} \
                       /usr/bin/notify-send -i dialog-warning "clamAV" "$alert"
done" > /etc/clamav/detected.sh && aa-complain clamd &>/dev/null &>/dev/null && sed -i 's/#User clamav/User root/g' /etc/clamav/clamd.conf && sed -i 's/#LocalSocket /run/clamav/clamd.ctl/LocalSocket /run/clamav/clamd.ctl/g' /etc/clamav/clamd.conf && sudo systemctl restart clamav-daemon
    xdg-user-dirs-update
    sed -i 's/ON_BOOT=start/ON_BOOT=ignore/g' /usr/lib/libvirt/libvirt-guests.sh && sed -i 's/ON_SHUTDOWN=suspend/ON_SHUTDOWN=shutdown/g' /usr/lib/libvirt/libvirt-guests.sh && systemctl enable --now libvirt-guests
    systemctl enable --now apparmor && systemctl enable --now auditd

}

# Initialize script functions in this order
welcome
root
diskPartitioning
baseSetup
extrasSetup

