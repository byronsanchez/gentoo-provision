#!/bin/sh

cur_dir="`pwd`"

emerge-webrsync;
layman -S;
emerge puppet-nitelite-development;
cd /etc/puppet;
eselect ruby set 1;
./init.sh;
puppet apply manifests/site.pp;

cd "${cur_dir}"
