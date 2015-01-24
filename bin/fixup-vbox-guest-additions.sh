#!/bin/sh
version=$(perl -e 'print((`vboxmanage --version` =~ /([\d\.]+)/)[0])')
vagrant ssh -c 'sudo yum -y update kernel-devel kernel kernel-firmware kerenl-headers'
vagrant reload
iso=VBoxGuestAdditions_$version.iso
vagrant ssh -c 'sudo su -' <<EOF
cd /tmp
wget http://download.virtualbox.org/virtualbox/$version/$iso
mount -t iso9660 -o loop $iso /mnt
cd /mnt
sh VBoxLinuxAdditions.run
cd /tmp
umount /mnt
rm -f $iso
EOF
