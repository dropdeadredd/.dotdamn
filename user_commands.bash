#!/bin/bash
#
# This file can contain commands that will be executed at the end of
# EndeavourOS install (online mode only) on the target system.
# The commands will be executed as root.
#
# This allows you to customize the installed system in several ways!
#
# If you add commands to this file, start the install process after
# saving this file.
#
# Tip: save your customized commands into a file on an internet server
# and fetch that file with command:
#
#     wget -O ~/user_commands.bash "URL-referring-the-file"
#
# Ideas for customization:
#   - install packages
#   - remove packages
#   - enable or disable system services
#   - writing dotfiles under $HOME
#   - etc.
#
# Example commands:
#
#     pacman -S --noconfirm --needed gufw geany chromium
#     pacman -Rsn --noconfirm xed
#     systemctl enable ufw
#
# There are some limitations to the commands:
#   - The 'pacman' commands mentioned above require option '--noconfirm',
#     otherwise the install process may hang because pacman waits for a
#     confirmation!
#   - Installing packages with 'yay' does not work because yay may not
#     be run as root.
#     The 'makepkg' command suffers from the same limitation.
#     This essentially blocks installing AUR packages here.
#
# Advanced tip (for ISOs since year 2022):
#    To write files directly into $HOME, you can find the new username
#    as the first parameter given to user_commands.bash, e.g.
#        username="$1"
#    Then you may write files under folder
#        /home/$username
#
# For ISOs released before year 2022:
#    Find your new username with command
#        username=$(cat /tmp/new_u                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        V
#        "install_mode"     (one of: online, offline, community)
#    before starting the calamares installer.
#    For example:
#        bash ~/user_commands.bash --iso-config online
#
#----------------------------------------------------------------------------------

#!/bin/bash

# Note: needs ISO since year 2022

username="$1"
# flatpak software
flatpak install one.ablaze.floorp -y
flatpak install eu.betterbird.Betterbird -y
flatpak install org.kde.krita -y
flatpak install com.github.Eloston.UngoogledChromium -y
flatpak install com.google.Chrome -y
flatpak install io.github.shiftey.Desktop -y
flatpak install com.google.AndroidStudio -y

# custom dracut
echo -e 'hostonly="yes"\nhostonlymode=strict' >> /etc/dracut.conf.d/smaller.conf
echo -e 'omit_dracutmodules+=" brltty il8n "\nforce_drivers+=" amdgpu radeon "' >> /etc/dracut.conf.d/drivermods.conf


# dotfiles
git clone https://github.com/dropdeadredd/.DAMNdotfiles.git /home/$username/.dotfiles/
cp -r /home/$username/.dotfiles/config/ /home/$username/.config/
for f in /home/$username/.dotfiles/home/*; do cp -- "/home/$username/.$f"; done
mkdir -p /home/$username/.config/sway/scripts
cp -r /home/$username/.dotfiles/bin/ /home/$username/.config/sway/scripts/
chmod +x /home/$username/.config/sway/scripts/*
echo -e "export PATH=$PATH:/home/$username/.config/sway/scripts/" | tee -a /home/$username/.bashrc
mkdir -p /home/$username/.config/sway/assets
cp -r /home/$username/.dotfiles/assets/ /home/$username/.config/sway/assets/
mkdir -p /home/$username/.local/share/fonts
for f in /home/$username/.dotfiles/local/fonts/*; do tar -xvf /home/$username/.dotfiles/local/fonts/$f -C /home/$username/.local/share/fonts/; done

# sysctl
echo -e "vm.vfs_cache_pressure=50" >> /etc/sysctl.d/90-vfs_cache.conf
echo -e "vm.swappiness=10" >> /etc/sysctl.d/99-swappiness.conf
sysctl --system system

# fstab
mkdir -p /xtr
echo -e "UUID=796e4d5e-b97e-4f55-96be-1b6b6b428a95  /xtr           ext4    defaults,nofail,x-systemd.device-timeout=20   0 0" >> /etc/fstab

# blackarch 
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
./strap.sh
pacman -Syu --noconfirm

# pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py

# finish up
kernel-install-for-dracut
rm -rf /home/$username/.cache/*
rm -rf /home/$username/.tmp/*
rm -rf /tmp/*