#!/usr/bin/env zsh
set -x

ssd=$ARCH_SSD
if [ -z "$ssd" ]; then
  echo "Set ARCH_SSD first."
  exit 1
fi
#
##################################################################################################
#Installing Exarch
#
#For documentation switch tty with alt-arrow, open lynx and navigate to https://wiki.archlinux.org
#
#Step 1: Connect to the internet
#dhcp through systemd-networkd should work out of the box.
#
#Step 2: Update system clock
#
timedatectl set-ntp true
timedatectl status
#
#Step 3: Partition the disks
#
parted $ssd mklabel gpt
parted $ssd mkpart primary fat32 1MiB 261MiB
parted $ssd mkpart primary ntfs 261MiB 100%
#
mkfs.fat -F32 ${ssd}1
mkfs.ext4 ${ssd}2
#
#Step 4: Mount the file systems
#
mount ${ssd}2 /mnt
#
#Step 5: Installation
#
pacstrap /mnt base base-devel linux linux-firmware sudo grub efibootmgr iwd python-sphinx wget unzip zip git vi vim xclip zsh openvpn networkmanager-openvpn openresolv openssh dhcpcd xorg xorg-xinit sddm xmonad-contrib xmobar i3-gaps i3status dmenu rofi xss-lock network-manager-applet alacritty go fzf feh mesa vulkan-intel alsa-utils pulseaudio volumeicon stalonetray pavucontrol docker python3 docker-compose
#
#Step 6: Configuring
#
genfstab -U /mnt >> /mnt/etc/fstab
#
#Step 7: Chrooting
arch-chroot /mnt zsh <(curl -s "https://raw.githubusercontent.com/exsinod/exarch/main/configure.sh")
#
#Step 8: Create boot loader
arch-chroot /mnt mkdir /boot/EFI
arch-chroot /mnt mount ${ssd}1 /boot/EFI
arch-chroot /mnt grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo "All done? Press any key to unmount and reboot or Ctrl-C to cancel."
read -n 1
#
echo "First set root passwd"
arch-chroot /mnt passwd
echo "And set user passwd"
arch-chroot /mnt passwd sven

## Rebooting
umount -R /mnt
reboot
