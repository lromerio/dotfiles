#!/usr/bin/env bash

SWAP_SIZE=4
HOSTNAME=Aridhol
KEYMAP=fr_CH-latin1
DISK=/dev/nvme0n1
PART_1=/dev/nvme0n1p1
PART_2=/dev/nvme0n1p2
USERNAME=lucio
DESKTOP=i3
CRYPT_PASSWORD="yolo"

## create partitions
## /dev/nvme0n1p1 -> boot (FAT32)
## /dev/nvme0n1p2 -> root (LUKS(BTRFS))
parted --script $DISK \
    mklabel gpt \
    mkpart ESP fat32 1MiB 551MiB \
    set 1 esp on \
    mkpart primary ext4 551MiB 100%

## encrypt disk
cryptsetup luksFormat $PART_2
echo -n "${CRYPT_PASSWORD}" | cryptsetup -q luksFormat $PART_2 -
echo -n "${CRYPT_PASSWORD}" | cryptsetup open --type luks $PART_2 root -

## create some filesystems
mkfs.fat -F32 -n efi $PART_1
mkfs.btrfs -L archroot /dev/mapper/cryptroot

## create btrfs subvolumes
mount -o compress=zstd,noatime /dev/mapper/cryptroot /mnt
btrfs subvol create /mnt/@
btrfs subvol create /mnt/@home
btrfs subvol create /mnt/@tmp
btrfs subvol create /mnt/@log
btrfs subvol create /mnt/@pkg
btrfs subvol create /mnt/@swap
btrfs subvol create /mnt/@snapshots
## laisy unmount
umount -l /mnt

## mount all volumes in their respective directories
mount -o noatime,space_cache=v2,compress=zstd,subvol=@           /dev/mapper/cryptroot /mnt/
mkdir -p /mnt/{boot/efi,home,var/log,var/cache/pacman/pkg,tmp,.snapshots}
mount -o noatime,space_cache=v2,compress=zstd,subvol=@home       /dev/mapper/cryptroot /mnt/home
mount -o noatime,space_cache=v2,compress=zstd,subvol=@tmp        /dev/mapper/cryptroot /mnt/tmp
mount -o noatime,space_cache=v2,compress=zstd,subvol=@log        /dev/mapper/cryptroot /mnt/var/log
mount -o noatime,space_cache=v2,compress=zstd,subvol=@pkg        /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg
mount -o noatime,space_cache=v2,compress=zstd,subvol=@snapshots  /dev/mapper/cryptroot /mnt/.snapshots
## mount /boot
mount $PART_1 /mnt/boot

## install some base packages
pacstrap /mnt base base-devel \
    linux linux-headers linux-lts linux-lts-headers linux-firmware amd-ucode linux-firmware \
    pacman-contrib openssh sudo curl wget git gvim vim neovim git zsh zsh-autosuggestions \
    btrfs-progs

## Generate fstab
genfstab -pU /mnt >> /mnt/etc/fstab

## enter the chroot environment
arch-chroot /mnt

## setup locales
[[ -f /etc/locale.gen.backup ]] || cp /etc/locale.gen{,.backup}
echo "en_US.UTF-8 UTF-8"   > /etc/locale.gen
echo "fr_CH.UTF-8 UTF-8"   >> /etc/locale.gen
echo "LANG=en_US.UTF-8"    > /etc/locale.conf
echo "KEYMAP=${KEYMAP}"    > /etc/vconsole.conf
locale-gen

## setup clocks
hwclock --systohc --utc
timedatectl set-timezone Europe/Zurich
timedatectl set-ntp true

## setup hostname
echo ${HOSTNAME} > /etc/hostname
cat <<EOF > /etc/hosts
# Static table lookup for hostnames.
# See hosts(5) for details.
127.0.0.1       localhost
::1             localhost
127.0.1.1       ${HOSTNAME}.localdomain ${HOSTNAME}
EOF

## Install packages
pacman --noconfirm -S \
    libinput \
    xf86-input-libinput \
    qpdfview \
    alsa-lib \
    alsa-plugins \
    alsa-tools \
    alsa-utils \
    arandr \
    dkms \
    pavucontrol \
    rofi \
    feh \
    ranger \
    file-roller \
    p7zip \
    unzip \
    firefox \
    firefox-tridactyl
    gtk2 \
    gtk3 \
    htop \
    lsof \
    nmap \
    tmux \
    xfce4-taskmanager \
    python \
    python-pip \
    python-virtualenv \
    python-virtualenvwrapper \
    python-cryptography \
    python-jedi \
    python-isort \
    python-pipenv \
    python-pynvim \
    wpa_supplicant \
    lightdm \
    lightdm-gtk-greeter \
    lightdm-gtk-greeter-settings \
    xorg \
    xorg-xinit \
    xorg-xinput \
    xorg-setxkbmap \
    xorg-xrandr \
    xorg-xwininfo \
    xorg-xrdb \
    arc-gtk-theme \
    arc-icon-theme \
    arc-solid-gtk-theme \
    vlc \
    podman \
    podman-compose \
    dmidecode \
    pacman-contrib \
    libreoffice-fresh \
    libreoffice-fresh-fr \
    libreoffice-fresh-br \
    libreoffice-fresh-it \
    hunspell \
    hunspell-en_GB \
    hunspell-en_US \
    hunspell-fr \
    hunspell-it \
    openconnect \
    openvpn \
    pulseaudio \
    pulseaudio-alsa \
    pulsemixer \
    vpnc \
    jq \
    bat \
    fd \
    ripgrep \
    dhclient \
    dunst \
    scrot \
    alacritty \
    neovim \
    zsh \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    qt5ct \
    otf-font-awesome \
    ttf-font-awesome \
    ttf-fira-mono \
    ttf-dejavu \
    ttf-droid \
    ttf-inconsolata \
    ttf-linux-libertine \
    reflector \
    noto-fonts \
    noto-fonts-emoji


## install WM
pacman -S --noconfirm i3

## add proper modules to boot
# echo "MODULES=(i915 btrfs)" > /etc/mkinitcpio.conf # docking station intel
echo "BINARIES=("/usr/bin/btrfs")" >> /etc/mkinitcpio.conf
echo "FILES=()" >> /etc/mkinitcpio.conf
echo "HOOKS=(base systemd autodetect keyboard sd-vconsole modconf block sd-encrypt filesystems fsck)" >> /etc/mkinitcpio.conf

## generate initrd
mkinitcpio -P

## Install systemd-boot (efi only)
bootctl --path=/boot install

## create systemd-boot entries
cat <<EOF > /boot/loader/loader.conf
timeout 1
default arch-lts.conf
EOF

## create entry for linux kernel
ROOT_PARTITION_UUID=$(cryptsetup luksUUID $PART_2)
cat <<EOF > /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux.img
options rd.luks.name=${ROOT_PARTITION_UUID}=cryptroot root=/dev/mapper/cryptroot rd.luks.options=discard,timeout=0 rootflags=x-systemd.device-timeout=0,subvol=@ net.ifnames=0 transparent_hugepage=never amd_iommu=on quiet rw
EOF

## create entry for linux-lts kernel
cat <<EOF > /boot/loader/entries/arch-lts.conf
title Arch Linux LTS
linux /vmlinuz-linux-lts
initrd /amd-ucode.img
initrd /initramfs-linux-lts.img
options rd.luks.name=${ROOT_PARTITION_UUID}=cryptroot root=/dev/mapper/cryptroot rd.luks.options=discard,timeout=0 rootflags=x-systemd.device-timeout=0,subvol=@ net.ifnames=0 transparent_hugepage=never amd_iommu=on quiet rw
EOF

## set default boot option
bootctl set-default arch-lts.conf

## pacman options
cp /etc/pacman.conf{,.backup}
sed -i ':a;N;s|#\[multilib\]\n#Include|\[multilib\]\nInclude|' /etc/pacman.conf
sed -i 's/#Color/Color/' /etc/pacman.conf

## makepkg options
cp /etc/makepkg.conf{,.backup}

## generate pacman mirrorlist based on speed
reflector --country Switzerland --country France --country Germany --country Italy --latest 200 --protocol https --protocol http --age 12 --sort rate --fastest 5 --save /etc/pacman.d/mirrorlist

## create username with password username (change after boot)
groupadd -r autologin

## create a user
useradd -m -g users -G wheel,games,power,optical,storage,scanner,lp,audio,video,docker,autologin -s $(which zsh) $USERNAME
echo -e "${USERNAME}\n${USERNAME}" | passwd ${USERNAME}
echo -e "root\nroot" | passwd root

chage -E -1 lightdm

## change keyboard speed
cat <<EOF > /etc/systemd/system/kbdrate.service
[Unit]
Description=Keyboard repeat rate in tty.

[Service]
Type=oneshot
RemainAfterExit=yes
StandardInput=tty
StandardOutput=tty
ExecStart=/usr/sbin/kbdrate -s -d 190 -r 80

[Install]
WantedBy=multi-user.target
EOF

## set keyboard config for Xorg
cat <<EOF > /etc/X11/xorg.conf.d/00-keyboard.conf
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "ch"
        Option "XkbModel" "pc105"
        Option "XkbVariant" "fr"
        Option "XkbOptions" "lv3:ralt_switch"
EndSection
EOF

## set touchpad options
cat <<EOF > /etc/X11/xorg.conf.d/30-touchpad.conf
Section "InputClass"
    Identifier "MyTouchpad"
    MatchIsTouchpad "on"
    Driver "libinput"
    Option "Tapping" "on"
    Option "Natural Scrolling" "off"
    Option "AccelSpeed" "0.5"
    Option "ClickMethod" "buttonareas"
    Option "DisableWhileTyping" "on"
EndSection
EOF

## lightdm configuration
cp /etc/lightdm/lightdm.conf{,.backup}
cat <<EOF > /etc/lightdm/lightdm.conf
[LightDM]
run-directory=/run/lightdm

[Seat:*]
autologin-user=${USERNAME}
autologin-user-timeout=0
user-session=${DESKTOP}
greeter-session=lightdm-gtk-greeter
session-wrapper=/etc/lightdm/Xsession

[XDMCPServer]

[VNCServer]
EOF

## lightdm-gtk-greeter
cp /etc/lightdm/lightdm-gtk-greeter.conf{,.backup}
cat <<EOF > /etc/lightdm/lightdm-gtk-greeter.conf
[greeter]
theme-name = Arc
icon-theme-name = Arc
background = /usr/share/pixmaps/lightdm_background.jpg
default-user-image = /var/lib/AccountsService/icons/icon.png
screensaver-timeout = 0
user-background = false

[monitor: eDP1]
background = /usr/share/pixmaps/lightdm_background.jpg

[monitor: DP2-1]
background = /usr/share/pixmaps/lightdm_background.jpg

[monitor: DP1-2]
background = /usr/share/pixmaps/lightdm_background.jpg
EOF

## create specific sudoers configuration file
cat <<EOF > /etc/sudoers.d/lucio
##
## Defaults
##
Defaults !tty_tickets
Defaults !mail_badpass
Defaults editor=/usr/sbin/vim, !env_editor
Defaults passwd_timeout=620
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
##
## User privilege specification
##
${USERNAME}   ALL=(ALL:ALL) ALL, NOPASSWD: /usr/sbin/pacman -Syu, \\
                                       /usr/sbin/pacman -Syy, \\
                                       /usr/sbin/yay -Syy, \\
                                       /usr/sbin/yay -Syu, \\
                                       /usr/sbin/yay -Syu --topdown --cleanafter, \\
                                       /usr/sbin/paru -Syy, \\
                                       /usr/sbin/paru -Syu, \\
                                       /usr/sbin/paru -Syu --topdown --cleanafter, \\
                                       /usr/sbin/systemctl start [a-z0-9_-]*, \\
                                       /usr/sbin/systemctl status [a-z0-9_-]*, \\
                                       /usr/sbin/systemctl restart [a-z0-9_-]*, \\
                                       /usr/sbin/systemctl stop [a-z0-9_-]*, \\
                                       /usr/sbin/systemctl list-unit-files [a-z0-9_-]*, \\
                                       /usr/sbin/systemctl list-units [a-z0-9_-]*, \\
                                       /usr/sbin/systemctl is-enabled [a-z0-9_-]*, \\
                                       /usr/sbin/systemctl shutdown, \\
                                       /usr/sbin/systemctl suspend, \\
                                       /usr/sbin/systemctl hibernate, \\
                                       /usr/sbin/systemctl reboot, \\
                                       /usr/sbin/systemctl poweroff, \\
                                       /usr/sbin/reboot, \\
                                       /usr/sbin/poweroff, \\
                                       /usr/sbin/lsof, \\
                                       /usr/sbin/dmidecode
EOF

## pacman hook to clean packages
mkdir -p /etc/pacman.d/hooks/
cat <<EOF > /etc/pacman.d/hooks/clean_package_cache.hook
[Trigger]
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Package
Target = *

[Action]
Description = Cleaning pacman cache...
When = PostTransaction
Exec = /usr/bin/paccache -rk 2
EOF

## set systemctl values
SYSCTL_PARAMS=(
   'vm.swappiness=10'
   'vm.vfs_cache_pressure=50'
   'net.ipv6.conf.vmnet1.disable_ipv6=1'
   'net.ipv6.conf.vmnet8.disable_ipv6=1'
   'vm.dirty_writeback_centisecs=6000'
   'kernel.nmi_watchdog=0'
)
for OPT in ${SYSCTL_PARAMS[@]}; do
    echo ${OPT} >> /etc/sysctl.d/99-sysctl.conf
done

# Install yay
chown -R $USERNAME: /home/$USERNAME
cd /home/$USERNAME
git clone https://aur.archlinux.org/yay.git


for DIR in yay; do
    cd $DIR
    sudo -u lucio makepkg -s
    cd ..
done
pacman --noconfirm -U /home/$USERNAME/yay/yay-*.pkg.*

## make sure one last time that everything has the proper permissions
chown -R $USERNAME: /home/$USERNAME

## Install AUR packages
sudo -u $USERNAME yay -S --sudoloop --noconfirm systemd-boot-pacman-hook
sudo -u $USERNAME yay -S --sudoloop --noconfirm polybar
# sudo -u $USERNAME yay -S --sudoloop --noconfirm libinput-gestures
sudo -u $USERNAME yay -S --sudoloop --noconfirm gksu
# sudo -u $USERNAME yay -S --sudoloop --noconfirm xcursor-oxygen xcursor-breeze-serie-obsidian

## Install full nerd-fonts
sudo -u $USERNAME mkdir /home/$USERNAME/downloads
cd /home/$USERNAME/downloads && sudo -u $USERNAME yay --getpkgbuild nerd-fonts-complete
cd nerd-fonts-complete
sudo -u $USERNAME wget -O nerd-fonts-2.1.0.tar.gz https://github.com/ryanoasis/nerd-fonts/archive/v2.1.0.tar.gz
chown -R $USERNAME: /home/$USERNAME
sudo -u $USERNAME makepkg -sci BUILDDIR=.

## enable services
systemctl enable kbdrate.service
systemctl enable fstrim.timer
systemctl enable lightdm.service
# systemctl enable docker
# systemctl enable bluetooth.service

### Create swapfile
mkdir /swapspace
mount -o noatime,space_cache=v2,compress=zstd,subvol=@swap /dev/mapper/cryptroot /swapspace

truncate -s 0 /swapspace/swapfile
chattr +C /swapspace/swapfile
btrfs property set /swapspace/swapfile compression none
dd if=/dev/zero of=/swapfile bs=1G count=4 status=progress || fallocate -l 4G /swapspace/swapfile
mkswap /swapspace/swapfile
chmod 600 /swapspace/swapfile
swapon /swapspace/swapfile

echo "Make sure to add the swapfile to the /etc/fstab"
echo "echo '/swapspace/swapfile none swap defaults 0 0' >> /etc/fstab"

