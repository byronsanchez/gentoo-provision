# Partition Schemes

Here are the common partition schemes I use depending on requirements of the
node.

Modify swap based on available RAM.

Red Hat swap space recommendations

  RAM | Recommended swap
  2gb | 2x
  2-8gb | =
  8-64gb | 0.5x
  >64gb | 4gb

### 50 GB binhost (8 GB RAM)

    disk.sda.1.size=128
    disk.sda.1.type=83
    disk.sda.1.purpose=/boot
    disk.sda.1.format=mkfs.ext4
    disk.sda.1.filesystem=ext4

    disk.sda.2.size=
    disk.sda.2.type=8e
    disk.sda.2.purpose=lvm:vg
    disk.sda.2.format=pvcreate

    disk.lvm.creategroup=vg

    disk.lvm.vg.swap.size=4096
    disk.lvm.vg.swap.format=mkswap
    disk.lvm.vg.swap.purpose=swap
    disk.lvm.vg.swap.filesystem=swap

    disk.lvm.vg.root.size=10240
    disk.lvm.vg.root.format=mkfs.ext4
    disk.lvm.vg.root.purpose=root
    disk.lvm.vg.root.filesystem=ext4

    disk.lvm.vg.home.size=2560
    disk.lvm.vg.home.format=mkfs.ext4
    disk.lvm.vg.home.purpose=/home
    disk.lvm.vg.home.filesystem=ext4

    disk.lvm.vg.opt.size=2560
    disk.lvm.vg.opt.format=mkfs.ext4
    disk.lvm.vg.opt.purpose=/opt
    disk.lvm.vg.opt.filesystem=ext4

    disk.lvm.vg.var.size=10240
    disk.lvm.vg.var.format=mkfs.ext4 -i 8192
    disk.lvm.vg.var.purpose=/var
    disk.lvm.vg.var.filesystem=ext4

    disk.lvm.vg.usr.size=20480
    disk.lvm.vg.usr.format=mkfs.ext4 -i 8192
    disk.lvm.vg.usr.purpose=/usr
    disk.lvm.vg.usr.filesystem=ext4

### 50 GB server (512mb RAM)

    disk.vda.1.size=128
    disk.vda.1.type=83
    disk.vda.1.purpose=/boot
    disk.vda.1.format=mkfs.ext4
    disk.vda.1.filesystem=ext4

    disk.vda.2.size=
    disk.vda.2.type=8e
    disk.vda.2.purpose=lvm:vg
    disk.vda.2.format=pvcreate

    disk.lvm.creategroup=vg

    disk.lvm.vg.swap.size=1024
    disk.lvm.vg.swap.format=mkswap
    disk.lvm.vg.swap.purpose=swap
    disk.lvm.vg.swap.filesystem=swap

    disk.lvm.vg.root.size=10240
    disk.lvm.vg.root.format=mkfs.ext4
    disk.lvm.vg.root.purpose=root
    disk.lvm.vg.root.filesystem=ext4

    disk.lvm.vg.home.size=2560
    disk.lvm.vg.home.format=mkfs.ext4
    disk.lvm.vg.home.purpose=/home
    disk.lvm.vg.home.filesystem=ext4

    disk.lvm.vg.opt.size=2560
    disk.lvm.vg.opt.format=mkfs.ext4
    disk.lvm.vg.opt.purpose=/opt
    disk.lvm.vg.opt.filesystem=ext4

    disk.lvm.vg.var.size=10240
    disk.lvm.vg.var.format=mkfs.ext4 -i 8192
    disk.lvm.vg.var.purpose=/var
    disk.lvm.vg.var.filesystem=ext4

    disk.lvm.vg.usr.size=20480
    disk.lvm.vg.usr.format=mkfs.ext4 -i 8192
    disk.lvm.vg.usr.purpose=/usr
    disk.lvm.vg.usr.filesystem=ext4

### 20 GB server (512mb RAM)

    disk.vda.1.size=128
    disk.vda.1.type=83
    disk.vda.1.purpose=/boot
    disk.vda.1.format=mkfs.ext4
    disk.vda.1.filesystem=ext4

    disk.vda.2.size=
    disk.vda.2.type=8e
    disk.vda.2.purpose=lvm:vg
    disk.vda.2.format=pvcreate

    disk.lvm.creategroup=vg

    disk.lvm.vg.swap.size=1024
    disk.lvm.vg.swap.format=mkswap
    disk.lvm.vg.swap.purpose=swap
    disk.lvm.vg.swap.filesystem=swap

    disk.lvm.vg.root.size=4096
    disk.lvm.vg.root.format=mkfs.ext4
    disk.lvm.vg.root.purpose=root
    disk.lvm.vg.root.filesystem=ext4

    disk.lvm.vg.home.size=1024
    disk.lvm.vg.home.format=mkfs.ext4
    disk.lvm.vg.home.purpose=/home
    disk.lvm.vg.home.filesystem=ext4

    disk.lvm.vg.opt.size=1024
    disk.lvm.vg.opt.format=mkfs.ext4
    disk.lvm.vg.opt.purpose=/opt
    disk.lvm.vg.opt.filesystem=ext4

    disk.lvm.vg.var.size=4096
    disk.lvm.vg.var.format=mkfs.ext4 -i 8192
    disk.lvm.vg.var.purpose=/var
    disk.lvm.vg.var.filesystem=ext4

    disk.lvm.vg.usr.size=8192
    disk.lvm.vg.usr.format=mkfs.ext4 -i 8192
    disk.lvm.vg.usr.purpose=/usr
    disk.lvm.vg.usr.filesystem=ext4

### 10 GB server (512mb RAM)

    disk.vda.1.size=128
    disk.vda.1.type=83
    disk.vda.1.purpose=/boot
    disk.vda.1.format=mkfs.ext4
    disk.vda.1.filesystem=ext4

    disk.vda.2.size=
    disk.vda.2.type=8e
    disk.vda.2.purpose=lvm:vg
    disk.vda.2.format=pvcreate

    disk.lvm.creategroup=vg

    disk.lvm.vg.swap.size=1024
    disk.lvm.vg.swap.format=mkswap
    disk.lvm.vg.swap.purpose=swap
    disk.lvm.vg.swap.filesystem=swap

    disk.lvm.vg.root.size=
    disk.lvm.vg.root.format=mkfs.ext4
    disk.lvm.vg.root.purpose=root
    disk.lvm.vg.root.filesystem=ext4

### Workstations (4gb RAM)

    disk.vda.1.size=128
    disk.vda.1.type=83
    disk.vda.1.purpose=/boot
    disk.vda.1.format=mkfs.ext4
    disk.vda.1.filesystem=ext4

    disk.vda.2.size=
    disk.vda.2.type=8e
    disk.vda.2.purpose=lvm:vg
    disk.vda.2.format=pvcreate

    disk.lvm.creategroup=vg

    disk.lvm.vg.swap.size=4096
    disk.lvm.vg.swap.format=mkswap
    disk.lvm.vg.swap.purpose=swap
    disk.lvm.vg.swap.filesystem=swap

    disk.lvm.vg.root.size=
    disk.lvm.vg.root.format=mkfs.ext4
    disk.lvm.vg.root.purpose=root
    disk.lvm.vg.root.filesystem=ext4

# Independent volumes

These volumes are context-dependent. They belong to the server that provides the 
corresponding service. Make sure to add them on top of one of the above 
partition schemes, or to account for the needed space.

File share - 500GB
Mirrors - 240GB
Mail - 5GB

