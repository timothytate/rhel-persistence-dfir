#!/bin/bash

# RHEL Persistence Artifact Collection Script (Developed on RHEL 8.2)
# Author: Timothy Tate

# Working directory
mkdir $HOSTNAME
cd ./$HOSTNAME

# Startup script persistence
ls -laR /etc/grub.d/ > etc-grub.d-list.txt
mkdir grub.d
find /etc/grub.d/ -type f -exec cp {} ./grub.d \;
find /etc/grub.d/ -type l -exec cp {} ./grub.d \;
cat /etc/inittab > etc-inittab-content.txt
mkdir rc.d
find /etc/rc.d/ -type f -exec cp {} ./rc.d \;
find /etc/rc.d/ -type l -exec cp {} ./rc.d \;
mkdir xinet.d
find /etc/xinet.d/ -type f -exec cp {} ./xinet.d \;
find /etc/xinet.d/ -type l -exec cp {} ./xinet.d \;

# Kernel Module persistence
mkdir $(uname -r)
find /lib/modules/$(uname -r) -type f -exec cp {} ./$(uname -r) \;
find /lib/modules/$(uname -r) -type l -exec cp {} ./$(uname -r) \;
ls -laR /etc/modprobe.d/ > etc-modprobe.d-list.txt
mkdir modprobe.d
find /etc/modprobe.d/ -type f -exec cp {} ./modprobe.d \;
find /etc/modprobe.d/ -type l -exec cp {} ./modprobe.d \;

# Software Packages persistence
rpm -qai > rpm-packages.txt

# Cron and AT job persistence
cat /var/spool/cron/crontabs > var-spool-cron-crontabs.txt
cat /var/spool/cron/atjobs > var-spool-cron-atjobs.txt
ls -la /etc/cron.d/ > etc-cron.d-list.txt
mkdir cron.d
find /etc/cron.d/ -type f -exec cp {} ./cron.d \;
find /etc/cron.d/ -type l -exec cp {} ./cron.d \;
ls -la /etc/at.d/ > etc-at.d-list.txt
mkdir at.d
find /etc/at.d/ -type f -exec cp {} ./at.d \;
find /etc/at.d/ -type l -exec cp {} ./at.d \;
cat /etc/anacrontab > etc-anacrontab.txt

# User persistence
cat /etc/passwd > etc-passwd.txt
cat /etc/shadow > etc-shadow.txt
awk -F: '($3 == 0) { print $1 }' /etc/passwd > root-users.txt
awk -F: '($2 == "*") { print $1 }' /etc/shadow > accounts-disabled.txt
mkdir bashrc
myarray=$(sudo find /home/*/ -name .bashrc -type f -exec ls {} \;)
for i in $myarray; do sudo cp $i ./bashrc/$(sudo ls $i | awk -F '/' '{ print $3 }').bashrc.txt; done
myarray=$(sudo find /home/*/ -name .bashrc -type l -exec ls {} \;)
for i in $myarray; do sudo cp $i ./bashrc/$(sudo ls $i | awk -F '/' '{ print $3 }').bashrc.txt; done
mkdir bash_profile
myarray=$(sudo find /home/*/ -name .bash_profile -type f -exec ls {} \;)
for i in $myarray; do sudo cp $i ./bash_profile/$(sudo ls $i | awk -F '/' '{ print $3 }').bash_profile.txt; done
myarray=$(sudo find /home/*/ -name .bash_profile -type l -exec ls {} \;)
for i in $myarray; do sudo cp $i ./bash_profile/$(sudo ls $i | awk -F '/' '{ print $3 }').bash_profile.txt; done
mkdir profile.d
find /etc/profile.d/ -type f -exec cp {} ./profile.d \;
find /etc/profile.d/ -type l -exec cp {} ./profile.d \;
cat /etc/profile > etc-profile.txt
cat /etc/bashrc > etc-bashrc.txt

# Filesystem persistence
find /sbin -exec rpm -qf {} \; | grep "is not" > sbin-nopackage-association.txt
find / -user root -perm -4000 -print0 | xargs -0 ls -l > suid-root-executables.txt
find / -perm -200 -print0 | xargs -0 ls -l > sgid-programs.txt

# Systemd Generator persistence
mkdir systemd-generators
cd systemd-generators
ls -laR /etc/systemd/system-generators/ > etc-systemd-generators-list.txt
mkdir etc-systemd-generators
find /etc/systemd/system-generators/ -type f -exec cp {} ./etc-systemd-generators \;
find /etc/systemd/system-generators/ -type l -exec cp {} ./etc-systemd-generators \;
ls -laR /usr/local/lib/systemd/system-generators/ > usr-local-lib-systemd-generators-list.txt
mkdir usr-local-lib-systemd-generators
find /usr/local/lib/systemd/system-generators/ -type f -exec cp {} ./usr-local-lib-systemd-generators \;
find /usr/local/lib/systemd/system-generators/ -type l -exec cp {} ./usr-local-lib-systemd-generators \;
ls -laR /lib/systemd/system-generators/ > lib-systemd-system-generators-list.txt
mkdir lib-systemd-system-generators
find /lib/systemd/system-generators/ -type f -exec cp {} ./lib-systemd-system-generators \;
find /lib/systemd/system-generators/ -type l -exec cp {} ./lib-systemd-system-generators \;
ls -laR /etc/systemd/user-generators/ > etc-systemd-user-generators-list.txt
mkdir etc-systemd-user-generators
find /etc/systemd/user-generators/ -type f - exec cp {} ./etc-systemd-user-generators \;
find /etc/systemd/user-generators/ -type l - exec cp {} ./etc-systemd-user-generators \;
ls -laR /usr/local/lib/systemd/user-generators/ > usr-local-lib-systemd-user-generators-list.txt
mkdir usr-local-lib-systemd-user-generators
find /usr/local/lib/systemd/user-generators/ -type f -exec cp {} ./usr-local-lib-systemd-user-generators \;
find /usr/local/lib/systemd/user-generators/ -type l -exec cp {} ./usr-local-lib-systemd-user-generators \;
ls -laR /usr/lib/systemd/user-generators/ > user-lib-systemd-user-generators-list.txt
mkdir user-lib-systemd-user-generators
find /usr/lib/systemd/user-generators/ -type f -exec cp {} ./user-lib-systemd-user-generators \;
find /usr/lib/systemd/user-generators/ -type l -exec cp {} ./user-lib-systemd-user-generators \;
cd ..

# Systemd Service paths persistence
mkdir service-paths
systemd-analyze unit-paths > ./service-paths/system-service-paths-list.txt
for i in $(ls /home | cat); do sudo -u $i systemd-analyze unit-paths --user > ./service-paths/$i-service-paths-list.txt; done
mkdir service-files
sh -c 'for i in $(cat ./service-paths/*); do find $i -type l -exec cp -rH --backup {} ./service-files/ \;; done'
sh -c 'for i in $(cat ./service-paths/*); do find $i -type f -exec cp -rH --backup {} ./service-files/ \;; done'

cd ..
mv ./$HOSTNAME ./bin

