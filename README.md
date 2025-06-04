# 🌀 Gerrit's Arch Linux Config

This repository automates the full installation of a custom Arch Linux system using `archinstall` with Hyprland, NVIDIA, yay, fonts, and more.  
It includes:

- 🔧 A full `archinstall` Python script
- 🎨 Hyprland + Waybar + Dunst config
- 🖥️ NVIDIA driver setup
- 🧰 Fonts, AUR helper (`yay`), `ly` login manager
- 🧱 Dotfiles and post-install scripts

---

## ⚡️ Quickstart (On a Fresh System)

### ✅ Prerequisites

- Boot into the **latest Arch Linux ISO** (from USB or VM)
- Ensure you have **internet access** (`ping archlinux.org` to test)

### 🚀 Steps

#### 1. Clone This Repo
```bash
git clone https://github.com/yourname/arch-config.git
cd arch-config/install
```

> If you don’t have git installed:
```bash
pacman -Sy git
```

---

#### 2. Run the Installer
This will use your disk `/dev/sda` — **all data will be wiped**.

```bash
python3 install.py
```

This sets up:
- GPT partitions (`/boot`, `/`)
- Mounts
- Installs base system, Hyprland, Waybar, NVIDIA drivers, fonts, etc.
- Creates user `gerrit` with sudo

---

#### 3. Chroot and Run Post-Install
```bash
arch-chroot /mnt
bash /root/arch-config/install/postinstall.sh
```

This configures:
- NVIDIA modules + initramfs
- Bootloader entry with NVIDIA DRM mode
- Installs `yay`, fonts, login manager (`ly`)
- Sets up wallpaper and Hyprland autostart

---

#### 4. Reboot!
```bash
exit
reboot
```

Log in as `gerrit` on `tty1`, and you’ll auto-start into Hyprland.

---

## 🔐 Default User Credentials

| User   | Password         |
|--------|------------------|
| root   | `my_root_password` |
| gerrit | `my_user_password` |

You can (and should) change these in `install.py`.

---

## 🛠️ Customization

- Config files live in `config/`
- Dotfiles go in `dotfiles/` and can be symlinked with `stow` or `chezmoi`
- Wallpapers go in `wallpapers/`

---

## QEMU instructions

```bash
# Create a drive
qemu-img create -f qcow2 archlinux2.qcow2 40G
```

### Before installing the system
```bash
qemu-system-x86_64 -m 8196 -cpu max -smp 4 -device virtio-vga-gl -display sdl,gl=on -drive file=archlinux2.qcow2,if=virtio -cdrom C:\Users\Gerrit\Downloads\archlinux.iso -boot d -device virtio-net,netdev=n0 -netdev user,id=n0 -rtc clock=host,base=localtime -usb -device usb-tablet -machine type=q35,accel=tcg
```
### afterwards (without the ISO and EUFI)
```bash
# switch to archlinux (without2) for old
qemu-system-x86_64 -m 8196 -cpu max -smp 4 -machine type=q35,accel=tcg -device virtio-vga-gl -display sdl,gl=on -drive if=virtio,file=archlinux2.qcow2,format=qcow2 -boot d -device virtio-net,netdev=n0 -netdev user,id=n0 -rtc clock=host,base=localtime -usb -device usb-tablet -drive if=pflash,format=raw,readonly=on,file="C:\Program Files\qemu\share\edk2-x86_64-code.fd" -drive if=pflash,format=raw,file="C:\Users\Gerrit\Desktop\edk2-i386-vars.fd"
```
