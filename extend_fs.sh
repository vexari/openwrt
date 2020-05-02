#This script describes how to configure OpenWrt to use a storage device (usb or sata or sdcard or whatever) to expand your root filesystem, to install freely all the packages you need.
#https://openwrt.org/docs/guide-user/additional-software/extroot_configuration

echo "[I]Installing dependencies"
opkg update && opkg install block-mount kmod-fs-ext4 kmod-usb-storage e2fsprogs kmod-usb-ohci kmod-usb-uhci fdisk

echo "[I]Configuring rootfs_data"
DEVICE="$(awk -e '/\s\/overlay\s/{print $1}' /etc/mtab)"
uci -q delete fstab.rwm
uci set fstab.rwm="mount"
uci set fstab.rwm.device="${DEVICE}"
uci set fstab.rwm.target="/rwm"
uci commit fstab

echo "[I]Format the partition /dev/sda1 as ext4"
mkfs.ext4 /dev/sda1

ehco "[I]Configure /dev/sda1 as new overlay via fstab uci subsystem"
DEVICE="/dev/sda1"
eval $(block info "${DEVICE}" | grep -o -e "UUID=\S*")
uci -q delete fstab.overlay
uci set fstab.overlay="mount"
uci set fstab.overlay.uuid="${UUID}"
uci set fstab.overlay.target="/overlay"
uci commit fstab

echo "[I]We now transfer the content of the current overlay inside the external drive"
mount /dev/sda1 /mnt
cp -a -f /overlay/. /mnt
umount /mnt

echo "[I]Preserving software package lists across boots."
sed -i -r -e "s/^(lists_dir\sext\s).*/\1\/usr\/lib\/opkg\/lists/" /etc/opkg.conf
opkg update

echo "[I]All done! It's now time to restart your system..."