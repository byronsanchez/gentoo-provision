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
Truecrypt
  CONFIG_FUSE_FS=y
  CONFIG_CRYPTO_XTS=y
iptables REDIRECTS 
  CONFIG_NETFILTER_XT_TARGET_REDIRECT=y|m
  CONFIG_IP_NF_TARGET_REDIRECT=y|m
  CONFIG_BRIDGE_EBT_REDIRECT)=y|m
Docker (NOTE: don't disable grsec stuff, just use sysctl on nodes that need more 
permissive kernel grsec settings)
[RAID] - when you use it

### Hosts/non-guests

If >4gb memory, add high memory support

### Virtual guests

Virtio drivers (as well as the balloon driver)

If <4gb, make sure to remove high memory support>

### initramfs command

genkernel --kernel-config=/usr/src/linux/.config --lvm --install initramfs

