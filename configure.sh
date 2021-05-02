#!/usr/bin/env zsh
set -x
#Step 9: Configure

# locale.gen
sudo cat << EOF > /etc/locale.gen
en_US.UTF-8 UTF-8
en_US ISO-8859-1
EOF
locale-gen
#
# locale.conf
sudo echo "LANG=en_US.UTF-8" > /etc/locale.conf
#
# hostname
sudo echo "exarch" > /etc/hostname
#
# hosts
sudo cat << EOF > /etc/hosts
127.0.0.1    localhost
::1          localhost
127.0.1.1    exarch.localdomain	exarch
EOF

# Install more packages not found in pacstrap
pacman -S gtop fzf the_silver_searcher NetworkManager ntpd

# Enable important packages
systemctl enable NetworkManager
systemctl enable ntpd
systemctl enable sddm

#Step 10: Create users and privileges
#
useradd -mg users -G wheel,storage,power -s /bin/bash sven
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
echo "sven ALL=(ALL) NOPASSWD:/usr/bin/pacman, /usr/bin/makepkg" > /etc/sudoers.d/sven-install-privileges

# openvpn related
curl -o /etc/openvpn/update-resolv-conf https://raw.githubusercontent.com/masterkorp/openvpn-update-resolv-conf/master/update-resolv-conf.sh
chmod +x /etc/openvpn/update-resolv-conf

# Install user specific
zsh < <(curl -s "https://raw.githubusercontent.com/exsinod/exarch/main/user-specific.sh")
