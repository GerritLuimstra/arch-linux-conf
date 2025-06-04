#!/bin/bash
set -e

# NVIDIA module configuration
sed -i 's/^MODULES=.*/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
mkinitcpio -P

# Patch bootloader
BOOT_ENTRY="/boot/loader/entries/arch.conf"
UUID=$(blkid -s UUID -o value /dev/sda2)
sed -i "s|options root=UUID=.* rw|options root=UUID=$UUID rw nvidia_drm.modeset=1|" "$BOOT_ENTRY"

# Setup yay
sudo -u gerrit bash <<EOF
cd /home/gerrit
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
EOF

# Enable services
systemctl enable NetworkManager
systemctl enable ly

# Wallpaper and Hyprland autostart
mkdir -p /home/gerrit/Pictures
cp /usr/share/backgrounds/archlinux/arch-wallpaper.jpg /home/gerrit/Pictures/wall.jpg
chown -R gerrit:gerrit /home/gerrit/Pictures

mkdir -p /home/gerrit/.config/hypr
echo -e "exec-once = dunst &\nexec-once = hyprpaper &" >> /home/gerrit/.config/hypr/hyprland.conf
echo -e "preload = ~/Pictures/wall.jpg\nwallpaper = eDP-1,~/Pictures/wall.jpg" > /home/gerrit/.config/hypr/hyprpaper.conf

# Waybar config
mkdir -p /home/gerrit/.config/waybar
cp /etc/xdg/waybar/config.jsonc /home/gerrit/.config/waybar/
cp /etc/xdg/waybar/style.css /home/gerrit/.config/waybar/
chown -R gerrit:gerrit /home/gerrit/.config
