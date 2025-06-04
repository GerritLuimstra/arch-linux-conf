import archinstall
import subprocess

# === Configuration ===
disk = "/dev/sda"
hostname = "GerritArchPC"
timezone = "Europe/Amsterdam"
locale = "en_US.UTF-8"
root_password = "my_root_password"
user_name = "gerrit"
user_password = "my_user_password"

with archinstall.Installer() as installation:
    fs = archinstall.Filesystem(disk, wipe=True)
    fs.add_partition(size="512M", part_type="efi", mountpoint="/boot")
    fs.add_partition(size="100%", part_type="linux", mountpoint="/")

    fs.format("/boot", "vfat")
    fs.format("/", "ext4")
    fs.mount_all()

    installation.mountpoints = fs
    installation.set_kernel("linux")
    installation.set_hostname(hostname)
    installation.set_timezone(timezone)
    installation.set_locale(locale)
    installation.set_mirror_region("Netherlands")

    installation.add_additional_packages([
        "base", "linux", "linux-firmware", "vim", "git", "networkmanager",
        "grub", "efibootmgr", "sudo", "hyprland", "alacritty", "firefox",
        "waybar", "wofi", "xdg-desktop-portal-hyprland", "xdg-desktop-portal",
        "wl-clipboard", "ly", "dunst", "base-devel", "hyprpaper", "ttf-dejavu",
        "ttf-liberation", "noto-fonts", "noto-fonts-cjk", "noto-fonts-emoji",
        "ttf-jetbrains-mono", "otf-font-awesome", "libva", "libva-nvidia-driver",
        "egl-wayland", "vulkan-icd-loader", "libvdpau", "nvidia", "nvidia-utils"
    ])

    installation.add_user(user_name, password=user_password, sudo=True)
    installation.set_root_password(root_password)
    installation.set_bootloader("systemd-boot")
    installation.install()
