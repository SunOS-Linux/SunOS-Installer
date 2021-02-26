# Sun Installer v2021.03

<img src="https://github.com/SunOS-Linux/SunOS-Installer/blob/master/Sun:OS.png" />

This README contains the steps to do the install and configure a fully-functional Sun/OS installation containing a desktop environment, all the support packages (network, bluetooth, audio, printers, etc.), along with all applications and utilities **(FOR Advance Users...read the README (Advance) file)** . The shell scripts in this repo allow the entire process to be automated.)---> UEFI is currently supported on the installer!
**The Automated Install is in Public Beta! Do not test, unless you know what your doing! Added support for the Sun Kernel v1.10**

## Sun/OS Linux ISO
To get the Sun/OS ISO please go to the following website:
https://gitlab.com/Server2356/Sun-OS

---
## Advanced
To create users, encryption, LVM, or other please read the README (Advance) file for more instructions

[Advanced Installation Guide for Sun/OS](https://github.com/SunOS-Linux/SunOS-Installer/blob/master/README%20(Advance).md)

## 1. Setup Boot and Sun/OS-archiso on USB key

First, setup the boot USB, boot Sun/OS-archiso live usb, and run the `preinstall.sh` from terminal since Sun/OS Linux is based from Arch Linux.

### 2. Sun/OS Linux-2021.03 (Pre-Install)

This step installs Sun/OS to your hard drive. *IT WILL FORMAT THE DISK*

```bash
git clone https://github.com/SunOS-Linux/SunOS-Installer.git
sh preinstall.sh
and then run the follwoing commands below and create (vim arch.conf)
```

### 3. Sun/OS Linux - Install internals of Sun/OS Linux

```bash
pacman -S --no-confirm pacman-contrib curl git
git clone https://github.com/SunOS-Linux/SunOS-Installer.git
cd SunOS-Installer
./0-setup.sh
./1-base.sh
./2-software-pacman.sh
./3-software-aur.sh
./9-post-setup.sh
```
### 4. Creating root password
```bash
passwd root
password:"enter your password"
Confirm password:"Enter your password"
```
### 5. Create Arch.conf in /boot/loader/entries

As I mentioned before, create a new Vim file called Arch.conf and type the following:

```bash
Title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root="UUID=/dev/sd(x) UUID goes here with the quotations" rw
```
### 6. Enablining the GNOME Desktop and starting it
```bash
systemctl enable gdm.service
exit
reboot
```
Once you done that, login to your new installation of Sun/OS and type the following command:
```bash
systemctl start gdm.service
```
And follow the instruction on setup at the following link

---

### System Description

To boot use `systemd` because it's minimalist, comes built-in, and since the Linux kernel has an EFI image, all we need is a way to execute it.

Also install the LTS Kernel* along side the rolling one, and configure the bootloader to offer both as a choice during startup. This enables me to switch kernels in the event of a problem with the rolling one.

=======
### Troubleshooting Arch Linux and Sun/OS Linux

__[Arch Linux and Installation Gude](https://github.com/SunOS-Linux/SunOS-Installer/blob/Sun-OS-Installer-v2/README%20(Advance).md)__

#### No Wifi

```bash
sudo wifi-menu`
```

#### Initialize Xorg:
At the terminal, run:

```bash
xinit
```
#### Updating
To update the system, run the command below in order for the system to update
```bash
sudo pacman -Syu
```
Press y and press enter, and the update should install. Once the update is finished reboot your system and execute the "update.sh" file to update the system information, we will soon push a package for updating and curretly the text based installer that's supported on the Sun/OS operating system. (We will soon add a graphical installer and other.)

(C) 2021 Morales Research Corporation
