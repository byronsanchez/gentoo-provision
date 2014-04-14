# Kernel Configuration

This list is a simple reminder list of what to search for online (specifically
in the Gentoo docs) for configuring the kernel in case it ever needs to be done 
from scratch again.

### Global

Udev
NFS
Samba (CIFS)
KVM Virtualization (Guest or Host)
Host Virtualization
GRsecurity minus RBAC
SELinux
Xorg
ALSA
NIC Interfaces (lspci -k on live CDs to see which driver was autoloaded if any)
Kernel Mode Setting (install linux-firmware)
LVM
ALSA
Bridged Networking
iptables
OpenVPN
IMA
EVM
LUKS
Truecrypt (enable CONFIG_FUSE_FS && CONFIG_CRYPTO_XTS)
[RAID] - when you use it

### Hosts/non-guests

If >4gb memory, add high memory support

### Virtual guests

Virtio drivers (as well as the balloon driver)

If <4gb, make sure to remove high memory support>

### initramfs command

genkernel --kernel-config=/usr/src/linux/.config --lvm --install initramfs

