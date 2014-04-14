#!/bin/sh

# - STEPS (list of steps supported by the script)
# - STEPFROM (step to start from - can be empty)
# - STEPTO (step to go to - can be empty)
# - LOG (log file to use - will always be appended)
# - FAILED (temporary file; as long as it exists, the system did not fail)
# 
# Next, run the following functions:
# initTools;
#
# If you ever want to finish using the libraries, but want to keep the
# script alive, use cleanupTools;
##
## Helper commands
##

typeset STEPS="mountcontext profile python selinux reboot_1 label reboot_2 booleans";
export STEPS;

typeset STEPFROM=$1;
export STEPFROM;

typeset STEPTO=$2;
export STEPTO;

typeset LOG=/tmp/build.log;
export LOG;

typeset FAILED=$(mktemp);
export FAILED;

[ -f master.lib.sh ] && source ./master.lib.sh || exit 1;

# This does usage/help and that sort of stuff. Not necessary for this script.
#initTools;
# Initialize the 3rd file descriptor for logging purposes (since we are not
# using initTools
exec 3>&1;

# Give timestamp in logging
echo ">>> $(date +%Y%m%d-%H%M%S) - Starting log." >> ${LOG}; 


set_mount_context() {
  logMessage "   > Setting tmp_t context for /tmp... ";
  grep -q '^tmpfs.*object_r:tmp_t' /etc/fstab;
  if [ $? -ne 0 ];
  then
    typeset FILE=/etc/fstab;
    typeset META=$(initChangeFile ${FILE});
    # remove any current tmp mounts
    grep -v '[ 	]/tmp' ${FILE} > ${FILE}.new;
    echo "tmpfs   /tmp   tmpfs defaults,noexec,nosuid,rootcontext=system_u:object_r:tmp_t:s0   0 0" >> ${FILE}.new;
    mv ${FILE}.new ${FILE};
    applyMetaOnFile ${FILE} ${META};
    commitChangeFile ${FILE} ${META};
    logMessage "done\n";
  else
    logMessage "skipped\n";
  fi

  logMessage "   > Setting var_run_t context for /run... ";
  grep -q '^tmpfs.*object_r:var_run_t' /etc/fstab;
  if [ $? -ne 0 ];
  then
    typeset FILE=/etc/fstab;
    typeset META=$(initChangeFile ${FILE});
    # remove any current run mounts
    grep -v '[ 	]/run' ${FILE} > ${FILE}.new;
    echo "tmpfs   /run   tmpfs mode=0755,nosuid,nodev,rootcontext=system_u:object_r:var_run_t:s0   0 0" >> ${FILE}.new;
    mv ${FILE}.new ${FILE};
    applyMetaOnFile ${FILE} ${META};
    commitChangeFile ${FILE} ${META};
    logMessage "done\n";
  else
    logMessage "skipped\n";
  fi

  logMessage "   > Creating /selinux mountpoint... ";
  if [ ! -d /selinux ];
  then
    mkdir /selinux;
    logMessage "done\n";
  else
    logMessage "skipped\n";
  fi

  grep -q 'selinuxfs' /etc/fstab;
  if [ $? -ne 0 ];
  then
    typeset FILE=/etc/fstab;
    typeset META=$(initChangeFile ${FILE});
    # remove any current selinux mounts
    grep -v '[ 	]/selinux' ${FILE} > ${FILE}.new;
    echo "none   /selinux   selinuxfs       defaults   0 0" >> ${FILE}.new;
    mv ${FILE}.new ${FILE};
    applyMetaOnFile ${FILE} ${META};
    commitChangeFile ${FILE} ${META};
  fi
}

set_profile() {
  logMessage "   > Switching profile to 'hardened/linux/amd64/no-multilib/selinux'... ";
  eselect profile list | grep -q 'hardened/linux/amd64/no-multilib/selinux \*$';
  if [ $? -ne 0 ];
  then
    eselect profile set hardened/linux/amd64/no-multilib/selinux || die "Failed to switch profiles";
    logMessage "done\n";
  else
    logMessage "skipped\n";
  fi
}

set_python() {
  logMessage "   > Switching python to 'python2.7'... ";
  eselect python list | grep -q 'python2.7 \*$';
  if [ $? -ne 0 ];
  then
    eselect python set python2.7 || die "Failed to switch python";
    logMessage "done\n";
  else
    logMessage "skipped\n";
  fi
}

configure_selinux() {
  logMessage "   > Installing SELinux utilities.\n";
  logMessage "     - Installing checkpolicy... ";
  installSoftware -1 checkpolicy || die "Failed to install checkpolicy";
  logMessage "done\n";
  logMessage "     - Installing policycoreutils... ";
  installSoftware -1 policycoreutils || die "Failed to install policycoreutils";
  logMessage "done\n";
  logMessage "     - Installing selinux-base-policy... ";
  FEATURES="-selinux" installSoftware selinux-base-policy || die "Failed to install SELinux base policy";
  logMessage "done\n";
  logMessage "   > Upgrading system (-uDN world) (might reinit)\n";
  installSoftware -uDN world || die "Failed to upgrade system (upgrade world)";
  logMessage "   > Installing additional SELinux utilities.\n";
  logMessage "     - Installing setools... ";
  installSoftware setools || die "Failed to install setools";
  logMessage "done\n";
  logMessage "     - Installing sepolgen... ";
  installSoftware sepolgen || die "Failed to install sepolgen";
  logMessage "done\n";
  logMessage "     - Installing checkpolicy again... ";
  installSoftware checkpolicy || die "Failed to install checkpolicy";
  logMessage "done\n";
}

label_system() {
  logMessage "   > Labelling the dev system... ";
  mkdir -p /mnt/gentoo > /dev/null 2>&1;
  mount -o bind / /mnt/gentoo;
  TYPE=$(awk -F'=' '/^SELINUXTYPE/ {print $2}' /etc/selinux/config);
  setfiles -r /mnt/gentoo /etc/selinux/${TYPE}/contexts/files/file_contexts /mnt/gentoo/dev || die "Failed to run setfiles";
  setfiles -r /mnt/gentoo /etc/selinux/${TYPE}/contexts/files/file_contexts /mnt/gentoo/lib64 || die "Failed to run setfiles";
  umount /mnt/gentoo;
  logMessage "done\n";

  logMessage "   > Labelling the entire system... ";
  rlpkg -a -r || die "Failed to relabel the entire system";
  logMessage "done\n";

  logMessage "   > Adding selinux_gentoo to boot runlevel ";
  rc-update add selinux_gentoo boot >> ${LOG} 2>&1;
  logMessage "done\n";
}

set_booleans() {
  logMessage "   > Setting global_ssp boolean... ";
  setsebool -P global_ssp on || die "Failed to set global boolean";
  logMessage "done\n";
}

fail_reboot() {
  typeset NEXT_STEP=$(echo ${STEPS} | awk '{print $2}');
  logMessage "   ** PLEASE REBOOT THE ENVIRONMENT AND CONTINUE WITH THE NEXT STEP (${NEXT_STEP})**\n";
  die "Please reboot.";
}

##
## Main
## 

stepOK "mountcontext" && (
logMessage ">>> Step \"mountcontext\" starting...\n";
runStep set_mount_context;
);
nextStep;

stepOK "profile" && (
logMessage ">>> Step \"profile\" starting...\n";
runStep set_profile;
);
nextStep;

stepOK "python" && (
logMessage ">>> Step \"python\" starting...\n";
runStep set_python;
);
nextStep;

stepOK "selinux" && (
logMessage ">>> Step \"selinux\" starting...\n";
runStep configure_selinux;
);
nextStep;

stepOK "reboot_1" && (
logMessage ">>> Step \"reboot_1\" starting...\n";
runStep fail_reboot;
);
nextStep;

stepOK "label" && (
logMessage ">>> Step \"label\" starting...\n";
runStep label_system;
);
nextStep;

stepOK "reboot_2" && (
logMessage ">>> Step \"reboot_2\" starting...\n";
runStep fail_reboot;
);
nextStep;

stepOK "booleans" && (
logMessage ">>> Step \"booleans\" starting...\n";
runStep set_booleans;
);
nextStep;

cleanupTools;
rm ${FAILED};
