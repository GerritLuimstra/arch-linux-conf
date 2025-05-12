# Installation guide

### Using this with QEMU (with GPU passthrough)
```bash
# Before installing the system
qemu-system-x86_64 -m 8196 -cpu max -smp 4 -device virtio-vga-gl -display sdl,gl=on -drive file=archlinux.qcow2,if=virtio -cdrom C:\Users\Gerrit\Downloads\archlinux.iso -boot d -device virtio-net,netdev=n0 -netdev user,id=n0 -rtc clock=host,base=localtime -usb -device usb-tablet -machine type=q35,accel=tcg

# afterwards (without the ISO and EUFI)
qemu-system-x86_64 -m 8196 -cpu max -smp 4 -machine type=q35,accel=tcg -device virtio-vga-gl -display sdl,gl=on -drive if=virtio,file=archlinux.qcow2,format=qcow2 -boot d -device virtio-net,netdev=n0 -netdev user,id=n0 -rtc clock=host,base=localtime -usb -device usb-tablet -drive if=pflash,format=raw,readonly=on,file="C:\Program Files\qemu\share\edk2-x86_64-code.fd" -drive if=pflash,format=raw,file="C:\Users\Gerrit\Desktop\edk2-i386-vars.fd"
```


### Drive set up
```bash
# First, we check which drives are available
lsblk

# Pick the correct *drive* (not partition)
cfdisk disk
# label type: gpt
# create a new partition: 512M - EFI
# create a new partition: everything else - Linux filesystem
# write the changes to disk

# Format the partitions
mkfs.fat -F32 /dev/sda1    # EFI partition
mkfs.ext4 /dev/sda2        # Root partition

# Mount the drives
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# Done, we can now install stuff on /mnt

```
### Install the system
```bash
# Set-up (well, fix..) the keyring
timedatectl set-ntp true
pacman-key --init
pacman-key --populate archlinux
pacman -Sy archlinux-keyring

# Install the base + some goodies
pacstrap /mnt base linux linux-firmware vim git networkmanager grub efibootmgr sudo

# Make sure Linux knows which drives to mount
# by creating a filesystem table
genfstab -U /mnt >> /mnt/etc/fstab
```

### Setting up the system
```bash
# Chroot into installed system
arch-chroot /mnt /bin/bash

# inside here, do the keyring BS again
pacman-key --init
pacman-key --populate archlinux
pacman -Sy archlinux-keyring

# Set timezone
ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
hwclock --systohc

# Set localization
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname and hosts
echo "GerritArchPC" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 GerritArchPC.localdomain GerritArchPC" >> /etc/hosts

# Set root password
echo "root:!!PASSWORD_HERE!!" | chpasswd

# Install Hyprland, Firefox, Alacritty and necessary 'dependencies'
pacman -S hyprland alacritty firefox waybar wofi xdg-desktop-portal-hyprland xdg-desktop-portal wl-clipboard ly

# Enable the network manager
systemctl enable NetworkManager

# Install systemd-boot
bootctl --path=/boot install

# Create bootloader config
echo "default arch" > /boot/loader/loader.conf
echo "timeout 3" >> /boot/loader/loader.conf

## Open the thing with INSERT MODE
cat <<BOOT > /boot/loader/entries/arch.conf

# then type
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=$(blkid -s UUID -o value /dev/nvme0n1p2) rw

# and end with
BOOT

# Create user
useradd -m -G wheel -s /bin/bash gerrit
echo "gerrit:!!PASSWORD_HERE!!" | chpasswd

# Allow wheel group sudo
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
```

Voila. Reboot

