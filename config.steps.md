## General stuff

### NVIDIA-drivers
```bash
sudo pacman -S nvidia nvidia-utils libva libva-nvidia-driver egl-wayland vulkan-icd-loader libvdpau

# ensure the NVIDIA modules load at boot:
sudo nano /etc/mkinitcpio.conf

# Make sure this line includes nvidia modules:
# MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

# then rebuild your initramfs:
sudo mkinitcpio -P

# Edit your bootloader config:
sudo nano /boot/loader/entries/arch.conf

# add this to the options line:
# nvidia_drm.modeset=1
# Full example:
# options root=UUID=xxxx rw nvidia_drm.modeset=1
```

#### Install yay
```bash
# install required stuff
sudo pacman -S --needed git base-devel

# clone repo
cd ~
git clone https://aur.archlinux.org/yay.git
cd yay

# build
makepkg -si
```

```bash
sudo pacman -S ttf-dejavu ttf-liberation noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono otf-font-awesome
```

## Set up ly

```bash
# install it
yay -S ly

# enable the service
sudo systemctl enable ly.service
```

Create or edit ~/.bash_profile:
```bash
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec Hyprland
fi
```
## Set up hyprland

```bash
mkdir -p ~/.config/hypr
```

## Set-up waybar

```bash
# if not yet installed
sudo pacman -S waybar

# Create a directory
mkdir -p ~/.config/waybar


# Copy default config and style:
# or (BETTER), copy the dot files
cp /etc/xdg/waybar/config.jsonc ~/.config/waybar/
cp /etc/xdg/waybar/style.css ~/.config/waybar/
