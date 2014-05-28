SELinux Setup and Configuration

Setup for SELinux is a little tricky since the entire process requires 3
reboots. Thus, this is a linear process and any errors in this process will
break the whole setup. It is best to have selinux setup via provision
scripts as opposed to puppet. The same issue will arise if you move this to
the provision phase - how to ensure automation despite 3 reboots.

The process/configs that occur before each reboot can be considered a phase.
Thus, everything up until the first reboot is Phase 1, everything after that
and up until the second reboot is Phase 2, etc.

Puppet allows the use of conditions to determine whether or not to apply a
resource. Thus, all configs of one phase can depend on something the end of
the previous phase does. This ensures the phases can be applied linearly.
Phase 2 can depend on a final persistent act of Phase 1, and Phase 3 can
depend on a final persistent act of Phase 2.

Thus, the only other questions is how to ensure automation despite the
necessary reboots. With puppet, this would be simple- just persistently call
puppet apply on a short internval. That way, Phase A would apply then a
reboot would occur. After the reboot, puppet apply would inevitably be
called again. Puppet would then see that the condition of Phase A has been
satisfied and Phase B would take place and then another reboot would occur.
Finally, the same would happen for Phase C. Then, SELinux is completely
setup and configured.

With provisions, this entire same process could be applied linearly. The
conditions may be similar as well. So it's technically possible to do it
through both methods. The question is, which method is more appropriate. To
do it via puppet once a kernel is installed and bootable from the hard
drive, or to do it during the provisioning process, while the hard drive is
still mounted on /mnt/gentoo.

Honestly, it seems most appropriate to setup SELinux on provision and then
maintain it via puppet. The process is too volatile to have puppet manage
it. One simple break could cause unexpected reboots on a live system. It
should be isolated into it's own shell script and automated along with the
provisioning process, but capable of intervention should things go wrong.

The one thing that would differ in the shell script implementation in
terms of design is how to continue setup after a reboot. In the puppet
design, puppet apply could be called on a regular interval, however the
shell script will have to be a little bit more clever than that. At the
start after boot, the automated scripts (local.d) must decide which phase of
the setup we are in and continue from there. There are 4 total possible
routes- The 3 SELinux Phases and the 1 Provision phase (installing the
kernel and bootloader and all the other standard linux stuff).

A good point of research in this area is to google "bash reboot and
continue." This functionality is a common requirement for many users and so
the challenge has been explored many times over.
A suggestion: `touch /tmp/some_file && reboot`

Currently, my provision script is downloaded into the ramfs and executed
from there. This wouldn't be a problem if I could still have persistent
state files to determine from where to resume the provisioning process.
If I can move the provisioning script to a writeable persistent filesystem
as soon as possible, that could be an approach - but then on reboot how
would I reference that filesystem from the ramdisk context? Check for
workdir/exptected_persistent.

Okay so now this new design expects 2 subphases for the Provisioning Phase -
PREPERSISTENT and POSTPERSISTENT phases. The goal of the pre phase is to get
the script on a persistent disk. The goal of the post phase is to install
the system and keep track of the main 4 phases by touching a file. This
design can work, but will require some testing.

Final Design

  Phase 1 - PREDISK - Create and format disks and move script to persistent
  workdir

  Phase 2- POSTDISK - Change workdir to this dir and continue with the normal
  provisioning process.

  Phase 3 - SELINUX PART 1

  Phase 4 - SELINUX PART 2

  Phase 5 - SELINUX PART 3


Troubleshooting the SELinux install

Ideas (for the puppet vs libsemanage/libselinux clash)
  - Stick to either ALL stable packages or all unstable (global ~amd64)
  - Add the puppet ebuild to my overlay to prevent the slot clash. This will
    probably work. Just remember, this is not stable! The risk is on you for any
    bugs or damages incurred

