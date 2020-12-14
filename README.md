# Sun/OS Installer Script (GNOME) v1.5 (Beta)

<img src="https://github.com/Server2356/Sun-OS-Installer/blob/master/Sun:OS.png" />

This README contains the steps to do the install and configure a fully-functional Sun-OS installation containing a desktop environment, all the support packages (network, bluetooth, audio, printers, etc.), along with all applications and utilities. The shell scripts in this repo allow the entire process to be automated.)

---

## 1. Setup Boot and Sun/OS-archiso on USB key

First, setup the boot USB, boot Sun/OS-archiso live usb, and run the `preinstall.sh` from terminal since Sun/OS is based from Arch Linux.

### 2. Archiso-Sun/OS-2021.01.01 (Pre-Install)

This step installs Sun/OS to your hard drive. *IT WILL FORMAT THE DISK*

```bash
git clone https://github.com/Server2356/Sun-OS-Installer.git
sh preinstall.sh
and then run the follwoing commands below and create (vim arch.conf)
```

### 3. Sun/OS - Install internals of Sun/OS

```bash
pacman -S --no-confirm pacman-contrib curl git
git clone https://github.com/ChrisTitusTech/ArchMatic
cd ArchMatic
./0-setup.sh
./1-base.sh
./2-software-pacman.sh
./3-software-aur.sh
./9-post-setup.sh
```
### 2. Create Arch.conf in /boot/loader/entries

As I mentioned before, create a new Vim file called Arch.conf and type the following:

```bash
Title Sun/OS
linux /vmlinuz-linux
initrd /initramfs-linux-.img
options root="UUID=/dev/sd(x) UUID goes here with the quotations" rw
```
### 3. Enablining the GNOME Desktop and starting it
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
*Update to the latest kernel --> Linux Kernel 5.10.1 LTS ---> Now supported on Sun/OS 2021.01.01
=======
### Troubleshooting Arch Linux and Sun/OS

__[Arch Linux and Installation Gude](https://github.com/rickellis/Arch-Linux-Install-Guide)__

#### No Wifi

```bash
sudo wifi-menu`
```

#### Initialize Xorg:
At the terminal, run:

```bash
xinit
```
(C) 2021 Abdon Morales Jr
