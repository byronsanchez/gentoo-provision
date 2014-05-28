# Xorg

### Notes

This setup configures a 1280x720 resolution monitor. To add one that is more
suitable, xinitrc is used. Xrandr creates the necessary resolution and sets it
prior to launching the window manager. The xinitrc is not tracked by this repo
as it is very specific to an individual system (It's placed in my dotfiles repo
instead).

Personal reminder: YOUR GRAPHICS CARD IS RADEON HD6530D!

Compile the radeon drivers (sumo) into the kernel

When provisioning a system using Xorg, make sure to have the following in the bootloader configuration:

    title Gentoo Linux (Hardened)
    root (hd0,0)
    kernel /boot/kernel root=/dev/ram0 real_root=/dev/vg/root dolvm rootfstype=ext4 video=DVI-D-1:1600x900-24@75
    initrd /boot/initramfs

Adapt it to fit your needs. However, the monitor you are using is weird, so for 
KMS you need to be specific. It uses a refresh rate of 75Hz, NOT 60 (it will be 
unreadable). This will ensure the console resolution is 1600x900 and works!

As for Xorg, you will need to use xrandr to create the appropriate modeline. You can install Xorg and boot a window manager at a lower resolution. In the booted X, use xrandr to create the modeline for 1600x900@75. It does autodetect the res at 60, but again this is wrong and will be unreadable and unusable.

The xorg script can be dotfiles territory- have xinitrc create the modeline via xrandr prior to starting the wm or DE.

Or, for the node you can try to perform the xrandr modeline creation for everyone on starting X. For now, I have gone with the xinitrc approach.

