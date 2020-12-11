# Sun/OS Installer Script (GNOME) v1.2.0

<img src="https://i.imgur.com/Yn29sze.png" />

This README contains the steps to do the install and configure a fully-functional Sun-OS installation containing a desktop environment, all the support packages (network, bluetooth, audio, printers, etc.), along with all applications and utilities. The shell scripts in this repo allow the entire process to be automated.)

---

## Setup Boot and Sun/OS-archiso on USB key

First, setup the boot USB, boot arch live iso, and run the `preinstall.sh` from terminal since Sun/OS is based from Arch Linux.

### Arch Live ISO (Pre-Install)

This step installs Sun/OS to your hard drive. *IT WILL FORMAT THE DISK*

```bash
git clone https://github.com/Server2356/Sun-OS-Installer.git
sh preinstall.sh
and then run the follwoing commands below and create (vim arch.conf)
```

### Sun/OS First Boot

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
### Arch.conf

As I mentioned before, create a new Vim file called Arch.conf and type the following:

```bash
Title Sun/OS
linux /vmlinuz-linux
initrd /initramfs-linux-.img
options root="UUID="/dev/sd(x) UUID goes" rw
```
---

### System Description

To boot I use `systemd` because it's minimalist, comes built-in, and since the Linux kernel has an EFI image, all we need is a way to execute it.

I also install the LTS Kernel along side the rolling one, and configure my bootloader to offer both as a choice during startup. This enables me to switch kernels in the event of a problem with the rolling one.

### Troubleshooting Arch Linux

__[Arch Linux Installation Gude](https://github.com/rickellis/Arch-Linux-Install-Guide)__

#### No Wifi

```bash
sudo wifi-menu`
```

#### Initialize Xorg:
At the terminal, run:

```bash
xinit
```
