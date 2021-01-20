#!/usr/bin/env bash
#-------------------------------------------------------------------------
#  Sun/OS Installer and Post-Installer for archiso and Sun/OS
#   Version 2021.02   (C) Abdon Morales
#-------------------------------------------------------------------------

echo -e "\nINSTALLING SOFTWARE\n"
echo -e"\nDetected Base System for Sun/OS \n"

PKGS=(

    # SYSTEM --------------------------------------------------------------

    'linux'             # Rolling kernel
    'rpm-tools'         # Adds support for RPM packages for Sun/OS and Arch
    'linux-lts'         # Long term support kernel

    # TERMINAL UTILITIES --------------------------------------------------

    'bash-completion'       # Tab completion for Bash
    'bleachbit'             # File deletion utility
    'cronie'                # cron jobs
    'curl'                  # Remote content retrieval
    'file-roller'           # Archive utility
    'htop'                  # System monitoring via terminal
    'gufw'                  # Firewall manager
    'hardinfo'              # Hardware info app
    'htop'                  # Process viewer
    'neofetch'              # Shows system info when you launch terminal
    'ntp'                   # Network Time Protocol to set time via network.
    'numlockx'              # Turns on numlock in X11
    'openssh'               # SSH connectivity tools
    'p7zip'                 # 7z compression program
    'rsync'                 # Remote file sync utility
    'speedtest-cli'         # Internet speed via terminal
    'tlp'                   # Advanced laptop power management
    'unrar'                 # RAR compression program
    'unzip'                 # Zip compression program
    'wget'                  # Remote content retrieval
    'vim'                   # Terminal Editor
    'zenity'                # Display graphical dialog boxes via shell scripts
    'zip'                   # Zip compression program
    'fish'                  # The interactive Fish shell 
    # DISK UTILITIES ------------------------------------------------------

    'android-tools'         # ADB for Android
    'android-file-transfer' # Android File Transfer
    'autofs'                # Auto-mounter
    'btrfs-progs'           # BTRFS Support
    'dosfstools'            # DOS Support
    'exfat-utils'           # Mount exFat drives
    'gparted'               # Disk utility
    'gvfs-mtp'              # Read MTP Connected Systems
    'gvfs-smb'              # More File System Stuff
    'nautilus-share'        # File Sharing in Nautilus
    'ntfs-3g'               # Open source implementation of NTFS file system
    'parted'                # Disk utility
    'samba'                 # Samba File Sharing
    'smartmontools'         # Disk Monitoring
    'smbclient'             # SMB Connection 
    # GENERAL UTILITIES ---------------------------------------------------

    'flameshot'             # Screenshots
    'freerdp'               # RDP Connections
    'libvncserver'          # VNC Connections
    'nautilus'              # Filesystem browser
    'remmina'               # Remote Connection
    'veracrypt'             # Disc encryption utility
    'variety'               # Wallpaper changer

    # DEVELOPMENT ---------------------------------------------------------

    'gedit'                 # Text editor
    'clang'                 # C Lang compiler
    'cmake'                 # Cross-platform open-source make system
    'code'                  # Visual Studio Code
    'electron'              # Cross-platform development using Javascript
    'git'                   # Version control system
    'gcc'                   # C/C++ compiler
    'glibc'                 # C libraries
    'meld'                  # File/directory comparison
    'npm'                   # Node package manager
    'python'                # Scripting language
    'yarn'                  # Dependency management (Hyper needs this)

    # MEDIA ---------------------------------------------------------------

    'obs-studio'            # Record your screen
  
    # GRAPHICS AND DESIGN -------------------------------------------------

    'gcolor2'               # Colorpicker
    'gimp'                  # GNU Image Manipulation Program
    'ristretto'             # Multi image viewer

    # PRODUCTIVITY --------------------------------------------------------

    'hunspell'              # Spellcheck libraries
    'hunspell-en'           # English spellcheck library
    'xpdf'                  # PDF viewer

)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

echo -e "\nDone!\n"
