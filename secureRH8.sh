#!/bin/bash -xv
echo \*\*\*\* Executing Level 1 - Server profile remediation

# Ensure mounting of cramfs filesystems is disabled
echo
echo \*\*\*\* Ensure\ mounting\ of\ cramfs\ filesystems\ is\ disabled
modprobe -n -v cramfs | grep "^install /bin/true$" || echo "install cramfs /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^cramfs\s" && rmmod cramfs


# Ensure mounting of squashfs filesystems is disabled
echo
echo \*\*\*\* Ensure\ mounting\ of\ squashfs\ filesystems\ is\ disabled
modprobe -n -v squashfs | grep "^install /bin/true$" || echo "install squashfs /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^squashfs\s" && rmmod squashfs

# Ensure mounting of udf filesystems is disabled
echo
echo \*\*\*\* Ensure\ mounting\ of\ udf\ filesystems\ is\ disabled
modprobe -n -v udf | grep "^install /bin/true$" || echo "install udf /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^udf\s" && rmmod udf

# Ensure /tmp is configured
echo
echo \*\*\*\* Ensure\ /tmp\ is configured
echo Ensure\ /tmp\ is configured

# Ensure nodev option set on /tmp partition
echo
echo \*\*\*\* Ensure\ nodev\ option\ set\ on\ /tmp\ partition
echo Ensure\ nodev\ option\ set\ on\ /tmp\ partition not configured

# Ensure nosuid option set on /tmp partition
echo
echo \*\*\*\* Ensure\ nosuid\ option\ set\ on\ /tmp\ partition
echo Ensure\ nosuid\ option\ set\ on\ /tmp\ partition not configured

# Ensure noexec option set on /tmp partition
echo
echo \*\*\*\* Ensure\ noexec\ option\ set\ on\ /tmp\ partition
echo Ensure\ noexec\ option\ set\ on\ /tmp\ partition not configured

# Ensure nodev option set on /var/tmp partition
echo
echo \*\*\*\* Ensure\ nodev\ option\ set\ on\ /var/tmp\ partition
echo Ensure\ nodev\ option\ set\ on\ /var/tmp\ partition not configured

# Ensure nosuid option set on /var/tmp partition
echo
echo \*\*\*\* Ensure\ nosuid\ option\ set\ on\ /var/tmp\ partition
echo Ensure\ nosuid\ option\ set\ on\ /var/tmp\ partition not configured

# Ensure noexec option set on /var/tmp partition
echo
echo \*\*\*\* Ensure\ noexec\ option\ set\ on\ /var/tmp\ partition
echo Ensure\ noexec\ option\ set\ on\ /var/tmp\ partition not configured

# Ensure nodev option set on /home partition
echo
echo \*\*\*\* Ensure\ nodev\ option\ set\ on\ /home\ partition
echo Ensure\ nodev\ option\ set\ on\ /home\ partition not configured

# Ensure nodev option set on /dev/shm partition
echo
echo \*\*\*\* Ensure\ nodev\ option\ set\ on\ /dev/shm\ partition
echo Ensure\ nodev\ option\ set\ on\ /dev/shm\ partition not configured

# Ensure nosuid option set on /dev/shm partition
echo
echo \*\*\*\* Ensure\ nosuid\ option\ set\ on\ /dev/shm\ partition
echo Ensure\ nosuid\ option\ set\ on\ /dev/shm\ partition not configured

# Ensure noexec option set on /dev/shm partition
echo
echo \*\*\*\* Ensure\ noexec\ option\ set\ on\ /dev/shm\ partition
echo Ensure\ noexec\ option\ set\ on\ /dev/shm\ partition not configured

# Ensure sticky bit is set on all world-writable directories
echo
echo \*\*\*\* Ensure\ sticky\ bit\ is\ set\ on\ all\ world-writable\ directories
df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null

# Disable Automounting
echo
echo \*\*\*\* Disable\ Automounting
systemctl systemctl --now disable autofs

# Disable USB Storage
echo
echo \*\*\*\* Disable USB Storage
echo Disable USB Storage
modprobe -n -v usb-storage | grep "^install /bin/true$" || echo "install usb-storage" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^usb-storage\s" && rmmod usb-storage

# Ensure gpgcheck is globally activated
echo
echo \*\*\*\* Ensure\ gpgcheck\ is\ globally\ activated
egrep -q "^(\s*)gpgcheck\s*=\s*\S+(\s*#.*)?\s*$" /etc/yum.conf && sed -ri "s/^(\s*)gpgcheck\s*=\s*\S+(\s*#.*)?\s*$/\1gpgcheck=1\2/" /etc/yum.conf || echo "gpgcheck=1" >> /etc/yum.conf
ficheros=`ls /etc/yum.repos.d/`
for file in $ficheros; do
	egrep -q "^(\s*)gpgcheck\s*=\s*\S+(\s*#.*)?\s*$" $file && sed -ri "s/^(\s*)gpgcheck\s*=\s*\S+(\s*#.*)?\s*$/\1gpgcheck=1\2/" $file || echo "gpgcheck=1" >> $file
done

# Ensure sudo is installed
echo
echo \*\*\*\* Ensure\ sudo\ is\ installed
rpm -q sudo || dnf -y install sudo

# Ensure sudo commands use pty
echo
echo \*\*\*\* Ensure\ sudo\ commands use pty
egrep -q '^\s*Defaults\s+(\[^#]+,\s*)?use_pty' /etc/sudoers || (echo -e "\n## Use pty for sudo commands" >> /etc/sudoers && echo -e "Defaults use_pty" >> /etc/sudoers)
ficheros=`ls /etc/sudoers.d/`
for file in $ficheros; do
	egrep -q '^\s*Defaults\s+(\[^#]+,\s*)?use_pty' $file || (echo -e "\n## Use pty for sudo commands" >> $file && echo -e "Defaults use_pty" >> $file)
done

# Ensure sudo log file exists
echo
echo \*\*\*\* Ensure\ sudo\ log file exists
egrep -q '^\s*Defaults\s+([^#]+,\s*)?logfile=' /etc/sudoers || (echo -e "\n## Ensure sudo log file exists" >> /etc/sudoers && echo -e "Defaults logfile=\"/var/log/sudo.log\"" >> /etc/sudoers)
ficheros=`ls /etc/sudoers.d/`
for file in $ficheros; do
	egrep -q '^\s*Defaults\s+([^#]+,\s*)?logfile=' $file || (echo -e "\n## Ensure sudo log file exists" >> $file && echo -e "Defaults logfile=\"/var/log/sudo.log\"" >> $file)
done


# Ensure AIDE is installed
echo
echo \*\*\*\* Ensure\ AIDE\ is\ installed
rpm -q aide || dnf -y install aide
#Initialize aide
aide --init
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

# Ensure filesystem integrity is regularly checked
echo
echo \*\*\*\* Ensure\ filesystem\ integrity\ is\ regularly\ checked
crontab -u root -l | egrep -q "^.*/usr/sbin/aide --check$" || echo "0 5 * * * /usr/sbin/aide --check" 

# Ensure permissions on bootloader config are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ bootloader\ config\ are\ configured
chown root:root /boot/grub2/grub.cfg
chmod og-rwx /boot/grub2/grub.cfg
chown root:root /boot/grub2/grubenv
chmod og-rwx /boot/grub2/grubenv

# Ensure bootloader password is set
echo
echo \*\*\*\* Ensure\ bootloader\ password\ is\ set
echo Ensure\ bootloader\ password\ is\ set not configured.

# Ensure authentication required for single user mode
echo
echo \*\*\*\* Ensure\ authentication\ required\ for\ single\ user\ mode
egrep -q "^\s*ExecStart" /usr/lib/systemd/system/rescue.service && sed -ri "s/(^[[:space:]]*ExecStart[[:space:]]*=[[:space:]]*).*$/\1-\/bin\/sh -c \"\/sbin\/sulogin; \/usr\/bin\/systemctl --fail --no-block default\"/" /usr/lib/systemd/system/rescue.service || echo "ExecStart=-/bin/sh -c \"/sbin/sulogin; /usr/bin/systemctl --fail --no-block default\"" >> /usr/lib/systemd/system/rescue.service
egrep -q "^\s*ExecStart" /usr/lib/systemd/system/emergency.service && sed -ri "s/(^[[:space:]]*ExecStart[[:space:]]*=[[:space:]]*).*$/\1-\/bin\/sh -c \"\/sbin\/sulogin; \/usr\/bin\/systemctl --fail --no-block default\"/" /usr/lib/systemd/system/emergency.service || echo "ExecStart=-/bin/sh -c \"/sbin/sulogin; /usr/bin/systemctl --fail --no-block default\"" >> /usr/lib/systemd/system/emergency.service

# Ensure core dumps are restricted
echo
echo \*\*\*\* Ensure\ core\ dumps\ are\ restricted
egrep -q "^(\s*)\*\s+hard\s+core\s+\S+(\s*#.*)?\s*$" /etc/security/limits.conf && sed -ri "s/^(\s*)\*\s+hard\s+core\s+\S+(\s*#.*)?\s*$/\1* hard core 0\2/" /etc/security/limits.conf || echo "* hard core 0" >> /etc/security/limits.conf
egrep -q "^(\s*)\*\s+hard\s+core\s+\S+(\s*#.*)?\s*$" /etc/security/limits.d/* && sed -ri "s/^(\s*)\*\s+hard\s+core\s+\S+(\s*#.*)?\s*$/\1* hard core 0\2/" /etc/security/limits.d/* || for i in /etc/security/limits.d/*; do echo "* hard core 0" >> $i; done
egrep -q "^(\s*)fs.suid_dumpable\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)fs.suid_dumpable\s*=\s*\S+(\s*#.*)?\s*$/\1fs.suid_dumpable = 0\2/" /etc/sysctl.conf || echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf
egrep -q "^(\s*)fs.suid_dumpable\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)fs.suid_dumpable\s*=\s*\S+(\s*#.*)?\s*$/\1fs.suid_dumpable = 0\2/" /etc/sysctl.d/* || for i in /etc/sysctl.d/* ; do echo "fs.suid_dumpable = 0" >> $i; done

# Ensure address space layout randomization (ASLR) is enabled
echo
echo \*\*\*\* Ensure\ address\ space\ layout\ randomization\ \(ASLR\)\ is\ enabled
egrep -q "^(\s*)kernel.randomize_va_space\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)kernel.randomize_va_space\s*=\s*\S+(\s*#.*)?\s*$/\1kernel.randomize_va_space = 2\2/" /etc/sysctl.conf || echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf
egrep -q "^(\s*)kernel.randomize_va_space\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)kernel.randomize_va_space\s*=\s*\S+(\s*#.*)?\s*$/\1kernel.randomize_va_space = 2\2/" /etc/sysctl.d/*|| for i in /etc/sysctl.d/*; do echo "kernel.randomize_va_space = 2" >> $i; done

# Ensure SELinux is installed
echo
echo \*\*\*\* Ensure\ the\ SELinux\ is\ installed
rpm -q libselinux || dnf -y install libselinux

# Ensure SELinux is not disabled in bootloader configuration
echo
echo \*\*\*\* Ensure\ SELinux\ is\ not\ disabled\ in\ bootloader\ configuration
egrep -q "^(\s*)kernelopts=(\S+\s+)*(selinux=0|enforcing=0)+\b" /boot/grub2/grubenv && (sed -ri "s/(^\s*kernelopts\s*=\s*.*)(selinux=0)(.*)/\1\3/" /boot/grub2/grubenv ; sed -ri "s/(^\s*kernelopts\s*=\s*.*)(enforcing=0)(.*)/\1\3/" /boot/grub2/grubenv)

# Ensure SELinux policy is configured
echo
echo \*\*\*\* Ensure\ SELinux\ policy\ is\ configured
egrep -q "^(\s*)SELINUXTYPE\s*=\s*(targeted|mls)\b" /etc/selinux/config || sed -ri "s/^(\s*)SELINUXTYPE\s*=\s*\S+(\s*#.*)?\s*$/\1SELINUXTYPE=targeted\2/" /etc/selinux/config || echo "SELINUXTYPE=targeted" >> /etc/selinux/config

# Ensure the SELinux state is enforcing
echo
echo \*\*\*\* Ensure\ the\ SELinux\ state\ is\ enforcing
egrep -q "^(\s*)SELINUX\s*=\s*enforcing" /etc/selinux/config || sed -ri "s/^(\s*)SELINUX\s*=\s*\S+(\s*#.*)?\s*$/\1SELINUX=enforcing\2/" /etc/selinux/config || echo "SELINUX=enforcing" >> /etc/selinux/config

# Ensure no unconfined services exist
echo
echo \*\*\*\* Ensure no unconfined services exist
ps -eZ | grep unconfined_service_t

# Ensure SETroubleshoot is not installed
echo
echo \*\*\*\* Ensure\ SETroubleshoot\ is\ not\ installed
rpm -q setroubleshoot && dnf -y remove setroubleshoot

# Ensure the MCS Translation Service (mcstrans) is not installed
echo
echo \*\*\*\* Ensure\ the\ MCS\ Translation\ Service\ \(mcstrans\)\ is\ not\ installed
rpm -q mcstrans && dnf -y remove mcstrans

# Ensure message of the day is configured properly
echo
echo \*\*\*\* Ensure\ message\ of\ the\ day\ is\ configured\ properly
sed -ri 's/(\\v|\\r|\\m|\\s)//g' /etc/motd

# Ensure local login warning banner is configured properly
echo
echo \*\*\*\* Ensure\ local\ login\ warning\ banner\ is\ configured\ properly
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue

# Ensure remote login warning banner is configured properly
echo
echo \*\*\*\* Ensure\ remote\ login\ warning\ banner\ is\ configured\ properly
echo "Authorized uses only. All activity may be monitored and reported." > /etc/issue.net

# Ensure permissions on /etc/motd are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/motd\ are\ configured
chmod -t,u+r+w-x-s,g+r-w-x-s,o+r-w-x /etc/motd

# Ensure permissions on /etc/issue are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/issue\ are\ configured
chmod -t,u+r+w-x-s,g+r-w-x-s,o+r-w-x /etc/issue

# Ensure permissions on /etc/issue.net are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/issue.net\ are\ configured
chmod -t,u+r+w-x-s,g+r-w-x-s,o+r-w-x /etc/issue.net

# Ensure GDM login banner is configured
echo
echo \*\*\*\* Ensure\ GDM\ login\ banner\ is\ configured


# Ensure updates, patches, and additional security software are installed
echo
echo \*\*\*\*Ensure updates\, patches\, and additional security software are installed
dnf -y update --security

# Ensure system-wide crypto policy is not legacy
echo 
echo \*\*\*\* Ensure system-wide crypto policy is not legacy
egrep -q "^\s*LEGACY\s*(\s+#.*)?$" /etc/crypto-policies/config && (update-crypto-policies --set DEFAULT ; update-crypto-policies)

# This parameter makes Satellite unavailable
# Ensure system-wide crypto policy is FUTURE or FIPS
# echo
# echo \*\*\*\* Ensure system-wide crypto policy is FUTURE or FIPS
# update-crypto-policies --set FUTURE
# update-crypto-policie


#Ensure xinetd is not installed
echo 
echo \*\*\*\*Ensure xinetd is not installed
rpm -q xinetd && dnf -y remove xinetd

# Ensure time synchronization is in use
echo
echo \*\*\*\* Ensure\ time\ synchronization\ is\ in\ use
rpm -q chrony || dnf -y install chrony

# Ensure chrony is configured
echo
echo \*\*\*\* Ensure\ chrony\ is\ configured
egrep -q "^(\s*)(server|pool)" /etc/chrony.conf && sed -ri "s/^\s*(server|pool).*//" /etc/chrony.conf || (echo -e "\nserver ntp-server1.om.dsn.inet" >> /etc/chrony.conf && echo "server ntp-server2.om.dsn.inet" >> /etc/chrony.conf )
systemctl restart chronyd

# Ensure X Window System is not installed
echo
echo \*\*\*\* Ensure\ X\ Window\ System\ is\ not\ installed
rpm -q xorg-x11* && dnf -y remove xorg-x11*

# Ensure rsync service is not enabled
echo
echo \*\*\*\* Ensure\ rsync\ service\ is\ not\ enabled
systemctl --now disable rsyncd

# Ensure Avahi Server is not enabled
echo
echo \*\*\*\* Ensure\ Avahi\ Server\ is\ not\ enabled
systemctl --now disable avahi-daemon

# Ensure SNMP Server is not enabled
echo
echo \*\*\*\* Ensure\ SNMP\ Server\ is\ not\ enabled
systemctl --now disable snmpd

# Ensure HTTP Proxy Server is not enabled
echo
echo \*\*\*\* Ensure\ HTTP\ Proxy\ Server\ is\ not\ enabled
systemctl --now disable squid

# Ensure Samba is not enabled
echo
echo \*\*\*\* Ensure\ Samba\ is\ not\ enabled
systemctl --now disable smb

# Ensure IMAP and POP3 server is not enabled
echo
echo \*\*\*\* Ensure\ IMAP\ and\ POP3\ server\ is\ not\ enabled
systemctl --now disable dovecot

# Ensure HTTP server is not enabled
echo
echo \*\*\*\* Ensure\ HTTP\ server\ is\ not\ enabled
systemctl --now disable htttpd

# Ensure FTP Server is not enabled
echo
echo \*\*\*\* Ensure\ FTP\ Server\ is\ not\ enabled
systemctl --now disable vsftpd

# Ensure DNS Server is not enabled
echo
echo \*\*\*\* Ensure\ DNS\ Server\ is\ not\ enabled
systemctl --now disable named

# Ensure NFS is not enabled
echo
echo \*\*\*\* Ensure\ NFS\ id\ not\ enabled
systemctl --now disable nfs

# Ensure RPC is not enabled
echo
echo \*\*\*\* Ensure\ RPC\ is\ not\ enabled
systemctl --now disable rpcbind

# Ensure LDAP server is not installed
echo
echo \*\*\*\* Ensure\ LDAP\ server\ is\ not\ installed
systemctl --now disable slapd

# Ensure DHCP Server is not enabled
echo
echo \*\*\*\* Ensure\ DHCP\ Server\ is\ not\ enabled
systemctl --now disable dhcpd

# Ensure CUPS is not enabled
echo
echo \*\*\*\* Ensure\ CUPS\ is\ not\ enabled
systemctl --now disable cups

# Ensure NIS Server is not enabled
echo
echo \*\*\*\* Ensure\ NIS\ Server\ is\ not\ enabled
systemctl --now disable ypserv

# Ensure mail transfer agent is configured for local-only mode
echo
echo \*\*\*\* Ensure\ mail\ transfer\ agent\ is\ configured\ for\ local-only\ mode
echo Ensure\ mail\ transfer\ agent\ is\ configured\ for\ local-only\ mode Linux custom object not configured.
sed -i "s/^inet_interfaces.\+/inet_interfaces = loopback-only/g" /etc/postfix/main.cf
service postfix restart

# Ensure NIS Client is not installed
echo
echo \*\*\*\* Ensure\ NIS\ Server\ is\ not\ installed
rpm -q ypbind && dnf -y remove ypbind

# Ensure telnet server is not installed
echo
echo \*\*\*\* Ensure\ telnet\ server\ is\ not\ installed
rpm -q telnet && dnf -y remove telnet

# Ensure LDAP client is not installed
# echo
# echo \*\*\*\* Ensure\ LDAP\ client\ is\ not\ installed
# rpm -q openldap-clients && dnf -y remove openldap-clients

# Ensure IP forwarding is disabled
echo
echo \*\*\*\* Ensure\ IP\ forwarding\ is\ disabled
grep -Els "^\s*net\.ipv4\.ip_forward\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf | while read filename; do sed -ri "s/^\s*(net\.ipv4\.ip_forward\s*)(=)(\s*\S+\b).*$/# *REMOVED* \1/" $filename; done; sysctl -w net.ipv4.ip_forward=0; sysctl -w net.ipv4.route.flush=1
grep -Els "^\s*net\.ipv6\.conf\.all\.forwarding\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf | while read filename; do sed -ri "s/^\s*(net\.ipv6\.conf\.all\.forwarding\s*)(=)(\s*\S+\b).*$/# *REMOVED* \1/" $filename; done; sysctl -w net.ipv6.conf.all.forwarding=0; sysctl -w net.ipv6.route.flush=1

# Ensure packet redirect sending is disabled
echo
echo \*\*\*\* Ensure\ packet\ redirect\ sending\ is\ disabled
# grep -Els "^\s*net\.ipv4\.conf\.all\.send\_redirects\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf | while read filename; do sed -ri "s/^\s*(net\.ipv4\.conf\.all\.send\_redirects.*)/# *REMOVED* \1/" $filename; done; sysctl -w net.ipv4.conf.default.send_redirects=0 ; sysctl -w net.ipv4.route.flush=1
# grep -Els "^\s*net\.ipv4\.conf\.default\.send\_redirects\s*=\s*1" /etc/sysctl.conf /etc/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /run/sysctl.d/*.conf | while read filename; do sed -ri "s/^\s*(net\.ipv4\.conf\.default\.send\_redirects.*)/# *REMOVED* \1/" $filename; done; sysctl -w net.ipv4.conf.default.send_redirects=0 ; sysctl -w net.ipv4.route.flush=1

egrep -q "^(\s*)net.ipv4.conf.all.send_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.conf.all.send_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.all.send_redirects = 0\2/" /etc/sysctl.conf || echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.conf.all.send_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.conf.all.send_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.all.send_redirects = 0\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.conf.all.send_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.conf.all.send_redirects = 0" >> $i; done

egrep -q "^(\s*)net.ipv4.conf.default.send_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.conf.default.send_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.default.send_redirects = 0\2/" /etc/sysctl.conf || echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.conf.default.send_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.conf.default.send_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.default.send_redirects = 0\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.conf.default.send_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.conf.default.send_redirects = 0" >> $i; done

sysctl -w net.ipv4.conf.all.send_redirects=0 
sysctl -w net.ipv4.conf.default.send_redirects=0 
sysctl -w net.ipv4.route.flush=1

# Ensure source routed packets are not accepted
echo
echo \*\*\*\* Ensure\ source\ routed\ packets\ are\ not\ accepted
egrep -q "^(\s*)net.ipv4.conf.all.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.conf.all.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.all.accept_source_route = 0\2/" /etc/sysctl.conf || echo "net.ipv4.conf.all.accept_source_route = 0" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.conf.all.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.conf.all.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.all.accept_source_route = 0\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.conf.all.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.conf.all.accept_source_route = 0" >> $i; done

egrep -q "^(\s*)net.ipv4.conf.default.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.conf.default.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.default.accept_source_route = 0\2/" /etc/sysctl.conf || echo "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.conf.default.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.conf.default.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.default.accept_source_route = 0\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.conf.default.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.conf.default.accept_source_route = 0" >> $i; done

egrep -q "^(\s*)net.ipv6.conf.all.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv6.conf.all.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv6.conf.all.accept_source_route = 0\2/" /etc/sysctl.conf || echo "net.ipv6.conf.all.accept_source_route = 0" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv6.conf.all.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv6.conf.all.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv6.conf.all.accept_source_route = 0\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv6.conf.all.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv6.conf.all.accept_source_route = 0" >> $i; done

egrep -q "^(\s*)net.ipv6.conf.default.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv6.conf.default.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv6.conf.default.accept_source_route = 0\2/" /etc/sysctl.conf || echo "net.ipv6.conf.default.accept_source_route = 0" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv6.conf.default.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv6.conf.default.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv6.conf.default.accept_source_route = 0\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv6.conf.default.accept_source_route\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv6.conf.default.accept_source_route = 0" >> $i; done


sysctl -w net.ipv4.conf.all.accept_source_route=0 
sysctl -w net.ipv4.conf.default.accept_source_route=0 
sysctl -w net.ipv6.conf.all.accept_source_route=0 
sysctl -w net.ipv6.conf.default.accept_source_route=0 
sysctl -w net.ipv4.route.flush=1 
sysctl -w net.ipv6.route.flush=1

# Ensure ICMP redirects are not accepted
echo
echo \*\*\*\* Ensure\ ICMP\ redirects\ are\ not\ accepted
egrep -q "^(\s*)net.ipv4.conf.all.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.conf.all.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.all.accept_redirects = 0\2/" /etc/sysctl.conf || echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.conf.all.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.conf.all.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.all.accept_redirects = 0\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.conf.all.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.conf.all.accept_redirects = 0" >> $i; done

egrep -q "^(\s*)net.ipv4.conf.default.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.conf.default.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.default.accept_redirects = 0\2/" /etc/sysctl.conf || echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.conf.default.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.conf.default.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.default.accept_redirects = 0\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.conf.default.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.conf.default.accept_redirects = 0" >> $i; done

egrep -q "^(\s*)net.ipv6.conf.all.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv6.conf.all.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv6.conf.all.accept_redirects = 0\2/" /etc/sysctl.conf || echo "net.ipv6.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv6.conf.all.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv6.conf.all.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv6.conf.all.accept_redirects = 0\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv6.conf.all.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv6.conf.all.accept_redirects = 0" >> $i; done

egrep -q "^(\s*)net.ipv6.conf.default.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv6.conf.default.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv6.conf.default.accept_redirects = 0\2/" /etc/sysctl.conf || echo "net.ipv6.conf.default.accept_redirects = 0" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv6.conf.default.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv6.conf.default.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv6.conf.default.accept_redirects = 0\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv6.conf.default.accept_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv6.conf.default.accept_redirects = 0" >> $i; done

sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv6.conf.all.accept_redirects=0 
sysctl -w net.ipv6.conf.default.accept_redirects=0
sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv6.route.flush=1

# Ensure secure ICMP redirects are not accepted
echo
echo \*\*\*\* Ensure\ secure\ ICMP\ redirects\ are\ not\ accepted
egrep -q "^(\s*)net.ipv4.conf.all.secure_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.conf.all.secure_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.all.secure_redirects = 1\2/" /etc/sysctl.conf || echo "net.ipv4.conf.all.secure_redirects = 1" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.conf.all.secure_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.conf.all.secure_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.all.secure_redirects = 1\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.conf.all.secure_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.conf.all.secure_redirects = 1" >> $i; done

egrep -q "^(\s*)net.ipv4.conf.default.secure_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.conf.default.secure_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.default.secure_redirects = 1\2/" /etc/sysctl.conf || echo "net.ipv4.conf.default.secure_redirects = 1" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.conf.default.secure_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.conf.default.secure_redirects\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.default.secure_redirects = 1\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.conf.default.secure_redirects\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.conf.default.secure_redirects = 1" >> $i; done

sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
sysctl -w net.ipv4.route.flush=1

# Ensure suspicious packets are logged
echo
echo \*\*\*\* Ensure\ suspicious\ packets\ are\ logged
egrep -q "^(\s*)net.ipv4.conf.all.log_martians\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.conf.all.log_martians\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.all.log_martians = 1\2/" /etc/sysctl.conf || echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.conf.all.log_martians\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.conf.all.log_martians\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.all.log_martians = 1\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.conf.all.log_martians\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.conf.all.log_martians = 1" >> $i; done

egrep -q "^(\s*)net.ipv4.conf.default.log_martians\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.conf.default.log_martians\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.default.log_martians = 1\2/" /etc/sysctl.conf || echo "net.ipv4.conf.default.log_martians = 1" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.conf.default.log_martians\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.conf.default.log_martians\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.default.log_martians = 1\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.conf.default.log_martians\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.conf.default.log_martians = 1" >> $i; done

sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.conf.default.log_martians=1
sysctl -w net.ipv4.route.flush=1

# Ensure broadcast ICMP requests are ignored
echo
echo \*\*\*\* Ensure\ broadcast\ ICMP\ requests\ are\ ignored
egrep -q "^(\s*)net.ipv4.icmp_echo_ignore_broadcasts\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.icmp_echo_ignore_broadcasts\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.icmp_echo_ignore_broadcasts = 1\2/" /etc/sysctl.conf || echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.icmp_echo_ignore_broadcasts\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.icmp_echo_ignore_broadcasts\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.icmp_echo_ignore_broadcasts = 1\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.icmp_echo_ignore_broadcasts\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> $i; done
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w net.ipv4.route.flush=1

# Ensure bogus ICMP responses are ignored
echo
echo \*\*\*\* Ensure\ bogus\ ICMP\ responses\ are\ ignored
egrep -q "^(\s*)net.ipv4.icmp_ignore_bogus_error_responses\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.icmp_ignore_bogus_error_responses\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.icmp_ignore_bogus_error_responses = 1\2/" /etc/sysctl.conf || echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.icmp_ignore_bogus_error_responses\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.icmp_ignore_bogus_error_responses\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.icmp_ignore_bogus_error_responses = 1\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.icmp_ignore_bogus_error_responses\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> $i; done
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1
sysctl -w net.ipv4.route.flush=1

# Ensure Reverse Path Filtering is enabled
echo
echo \*\*\*\* Ensure\ Reverse\ Path\ Filtering\ is\ enabled
egrep -q "^(\s*)net.ipv4.conf.all.rp_filter\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.conf.all.rp_filter\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.all.rp_filter = 1\2/" /etc/sysctl.conf || echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.conf.all.rp_filter\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.conf.all.rp_filter\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.all.rp_filter = 1\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.conf.all.rp_filter\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.d/*; done

egrep -q "^(\s*)net.ipv4.conf.default.rp_filter\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.conf.default.rp_filter\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.default.rp_filter = 1\2/" /etc/sysctl.conf || echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.conf.default.rp_filter\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.conf.default.rp_filter\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.conf.default.rp_filter = 1\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.conf.default.rp_filter\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.conf.default.rp_filter = 1" >> $i; done

sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1
sysctl -w net.ipv4.route.flush=1

# Ensure TCP SYN Cookies is enabled
echo
echo \*\*\*\* Ensure\ TCP\ SYN\ Cookies\ is\ enabled
egrep -q "^(\s*)net.ipv4.tcp_syncookies\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv4.tcp_syncookies\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.tcp_syncookies = 1\2/" /etc/sysctl.conf || echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv4.tcp_syncookies\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv4.tcp_syncookies\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv4.tcp_syncookies = 1\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv4.tcp_syncookies\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv4.tcp_syncookies = 1" >> $i; done
sysctl -w net.ipv4.tcp_syncookies=1
sysctl -w net.ipv4.route.flush=1

# Ensure IPv6 router advertisements are not accepted
echo
echo \*\*\*\* Ensure\ IPv6\ router\ advertisements\ are\ not\ accepted
egrep -q "^(\s*)net.ipv6.conf.all.accept_ra\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv6.conf.all.accept_ra\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv6.conf.all.accept_ra = 0\2/" /etc/sysctl.conf || echo "net.ipv6.conf.all.accept_ra = 0" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv6.conf.all.accept_ra\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv6.conf.all.accept_ra\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv6.conf.all.accept_ra = 0\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv6.conf.all.accept_ra\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv6.conf.all.accept_ra = 0" >> $i; done

egrep -q "^(\s*)net.ipv6.conf.default.accept_ra\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.conf && sed -ri "s/^(\s*)net.ipv6.conf.default.accept_ra\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv6.conf.default.accept_ra = 0\2/" /etc/sysctl.conf || echo "net.ipv6.conf.default.accept_ra = 0" >> /etc/sysctl.conf
egrep -q "^(\s*)net.ipv6.conf.default.accept_ra\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/* && sed -ri "s/^(\s*)net.ipv6.conf.default.accept_ra\s*=\s*\S+(\s*#.*)?\s*$/\1net.ipv6.conf.default.accept_ra = 0\2/" /etc/sysctl.d/* || for i in $(egrep -Ls "^(\s*)net.ipv6.conf.default.accept_ra\s*=\s*\S+(\s*#.*)?\s*$" /etc/sysctl.d/*); do echo "net.ipv6.conf.default.accept_ra = 0" >> $i; done

sysctl -w net.ipv6.conf.all.accept_ra=0
sysctl -w net.ipv6.conf.default.accept_ra=0
sysctl -w net.ipv6.route.flush=1

# Ensure DCCP is disabled
echo
echo \*\*\*\* Ensure\ DCCP\ is\ disabled
modprobe -n -v dccp | grep "^install /bin/true$" || echo "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^dccp\s" && rmmod dccp

# Ensure SCTP is disabled
echo
echo \*\*\*\* Ensure\ SCTP\ is\ disabled
modprobe -n -v sctp | grep "^install /bin/true$" || echo "install sctp /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^sctp\s" && rmmod sctp

# Ensure RDS is disabled
echo
echo \*\*\*\* Ensure\ RDS\ is\ disabled
modprobe -n -v rds | grep "^install /bin/true$" || echo "install rds /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^rds\s" && rmmod rds

# Ensure TIPC is disabled
echo
echo \*\*\*\* Ensure\ TIPC\ is\ disabled
modprobe -n -v tipc | grep "^install /bin/true$" || echo "install tipc /bin/true" >> /etc/modprobe.d/CIS.conf
lsmod | egrep "^tipc\s" && rmmod tipc

# Ensure a Firewall package is installed
echo
echo \*\*\*\* Ensure a Firewall package is installed
rpm -q firewalld || dnf -y install firewalld

# Ensure firewalld service is enabled and running
echo
echo \*\*\*\* Ensure firewalld service is enabled and running
systemctl --now enable firewalld

# Ensure iptables is not enabled
echo
echo \*\*\*\* Ensure iptables is not enabled
systemctl --now mask iptables

# Ensure nftables is not enabled
echo
echo \*\*\*\* Ensure nftables is not enabled
systemctl --now mask nftables

# Ensure default zone is set
echo
echo \*\*\*\* Ensure default zone is set


# Ensure network interfaces are assigned to appropriate zone
echo
echo \*\*\*\* Ensure network interfaces are assigned to appropriate zone

# Ensure unnecessary services and ports are not accepted
echo
echo \*\*\*\* Ensure unnecessary services and ports are not accepted

# Ensure wireless interfaces are disabled
echo
echo \*\*\*\* Ensure wireless interfaces are disabled
nmcli radio all off

firewall-cmd --runtime-to-permanent

# Ensure auditd is installed
echo
echo \*\*\*\* Ensure auditd is installed
rpm -q audit audit-libs || dnf install audit audit-libs

# Ensure auditd service is enabled
echo
echo \*\*\*\* Ensure\ auditd\ service\ is\ enabled
systemctl --now enable auditd

# Ensure auditing for processes that start prior to auditd is enabled
echo
echo \*\*\*\* Ensure\ auditing\ for\ processes\ that\ start\ prior\ to\ auditd\ is\ enabled
egrep -q "^(\s*)GRUB_CMDLINE_LINUX\s*=\s*\"([^\"]+)?\"(\s*#.*)?\s*$" /etc/default/grub && sed -ri "s/^((\s*)GRUB_CMDLINE_LINUX\s*=\s*\"([^\"]+\s+)?)audit=\S+((\s+[^\"]+)?\"(\s*#.*)?\s*)$/\1audit=1\4/" /etc/default/grub
egrep -q "^(\s*)GRUB_CMDLINE_LINUX\s*=.*audit=.*" /etc/default/grub || sed -ri "s/^(\s*GRUB_CMDLINE_LINUX\s*=\s*.*)\"/\1 audit=1\"/" /etc/default/grub

# Ensure audit_backlog_limit is sufficient
echo
echo \*\*\*\* Ensure audit_backlog_limit is sufficient
#(LEVEL 2)
egrep -q "^(\s*)GRUB_CMDLINE_LINUX\s*=\s*\"([^\"]+)?\"(\s*#.*)?\s*$" /etc/default/grub && sed -ri "s/^((\s*)GRUB_CMDLINE_LINUX\s*=\s*\"([^\"]+\s+)?)audit_backlog_limit=\S+((\s+[^\"]+)?\"(\s*#.*)?\s*)$/\1audit_backlog_limit=8192\4/" /etc/default/grub; 
egrep -q "^(\s*)GRUB_CMDLINE_LINUX\s*=.*audit_backlog_limit=.*" /etc/default/grub || sed -ri "s/^(\s*GRUB_CMDLINE_LINUX\s*=\s*.*)\"/\1 audit_backlog_limit=8192\"/" /etc/default/grub

#Update grub2 configuration
grub2-mkconfig -o /boot/grub2/grub.cfg

# Ensure audit log storage size is configured
echo
echo \*\*\*\* Ensure\ audit\ log\ storage\ size\ is\ configured
egrep -q "^(\s*)max\_\log\_file\s*=.*" /etc/audit/auditd.conf && sed -ri "s/^(\s*max_log_file\s*=\s*).*/\110/" /etc/audit/auditd.conf
egrep -q "^(\s*)max\_\log\_file\s*=.*" /etc/audit/auditd.conf || echo " max_log_file = 10" >> /etc/audit/auditd.conf

# Ensure audit logs are not automatically deleted
# echo
# echo \*\*\*\* Ensure audit logs are not automatically deleted
# egrep -q "^(\s*)max\_\log\_file\_action\s*=.*" /etc/audit/auditd.conf && sed -ri "s/^(\s*max_log_file_action\s*=\s*).*/\1keep_logs/" /etc/audit/auditd.conf
# egrep -q "^(\s*)max\_\log\_file\_action\s*=.*" /etc/audit/auditd.conf || echo " max_log_file_action = keep_logs" >> /etc/audit/auditd.conf

# Ensure system is disabled when audit logs are full
# echo
# echo \*\*\*\* Ensure system is disabled when audit logs are full
# egrep -q "^(\s*)space\_left\_action\s*=.*" /etc/audit/auditd.conf && sed -ri "s/^(\s*space_left_action\s*=\s*).*/\1email/" /etc/audit/auditd.conf
# egrep -q "^(\s*)space\_left\_action\s*=.*" /etc/audit/auditd.conf || echo " space_left_action = email" >> /etc/audit/auditd.conf

# egrep -q "^(\s*)action\_mail\_acct\s*=.*" /etc/audit/auditd.conf && sed -ri "s/^(\s*action_mail_acct\s*=\s*).*/\1root/" /etc/audit/auditd.conf
# egrep -q "^(\s*)action\_mail\_acct\s*=.*" /etc/audit/auditd.conf || echo " action_mail_acct = root" >> /etc/audit/auditd.conf

# egrep -q "^(\s*)admin\_space\_left\_action\s*=.*" /etc/audit/auditd.conf && sed -ri "s/^(\s*admin_space_left_action\s*=\s*).*/\1halt/" /etc/audit/auditd.conf
# egrep -q "^(\s*)admin\_space\_left\_action\s*=.*" /etc/audit/auditd.conf || echo " admin_space_left_action = halt" >> /etc/audit/auditd.conf

# Ensure changes to system administration scope (sudoers) is collected
echo
echo \*\*\*\* Ensure changes to system administration scope \(sudoers\) is collected
egrep -q "^-w\s+/etc/sudoers\s+-p\s+wa\s+-k\s+scope\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/sudoers -p wa -k scope" >> /etc/audit/rules.d/audit.rules
egrep -q "^-w\s+/etc/sudoers.d\s+-p\s+wa\s+-k\s+scope\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/sudoers.d -p wa -k scope" >> /etc/audit/rules.d/audit.rules

# Ensure login and logout events are collected
echo
echo \*\*\*\* Ensure\ login\ and\ logout\ events\ are\ collected
egrep "^-w\s+/var/log/faillog\s+-p\s+wa\s+-k\s+logins\s*$" /etc/audit/rules.d/audit.rules || echo "-w /var/log/faillog -p wa -k logins" >> /etc/audit/rules.d/audit.rules
egrep "^-w\s+/var/log/lastlog\s+-p\s+wa\s+-k\s+logins\s*$" /etc/audit/rules.d/audit.rules || echo "-w /var/log/lastlog -p wa -k logins" >> /etc/audit/rules.d/audit.rules

# Ensure session initiation information is collected
echo
echo \*\*\*\* Ensure\ session\ initiation\ information\ is\ collected
egrep "^-w\s+/var/run/utmp\s+-p\s+wa\s+-k\s+session\s*$" /etc/audit/rules.d/audit.rules || echo "-w /var/run/utmp -p wa -k session" >> /etc/audit/rules.d/audit.rules
egrep "^-w\s+/var/log/wtmp\s+-p\s+wa\s+-k\s+logins\s*$" /etc/audit/rules.d/audit.rules || echo "-w /var/log/wtmp -p wa -k logins" >> /etc/audit/rules.d/audit.rules
egrep "^-w\s+/var/log/btmp\s+-p\s+wa\s+-k\s+logins\s*$" /etc/audit/rules.d/audit.rules || echo "-w /var/log/btmp -p wa -k logins" >> /etc/audit/rules.d/audit.rules

# Ensure events that modify date and time information are collected
echo
echo \*\*\*\* Ensure\ events\ that\ modify\ date\ and\ time\ information\ are\ collected
egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+adjtimex\s+-S\s+settimeofday\s+-S\s+stime\s+-k\s+time-change\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" >> /etc/audit/rules.d/audit.rules
egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+clock_settime\s+-k\s+time-change\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S clock_settime -k time-change" >> /etc/audit/rules.d/audit.rules
egrep "^-w\s+/etc/localtime\s+-p\s+wa\s+-k\s+time-change\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/localtime -p wa -k time-change" >> /etc/audit/rules.d/audit.rules
uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+adjtimex\s+-S\s+settimeofday\s+-k\s+time-change\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change" >> /etc/audit/rules.d/audit.rules
uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+clock_settime\s+-k\s+time-change\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S clock_settime -k time-change" >> /etc/audit/rules.d/audit.rules

# Ensure events that modify the system's Mandatory Access Controls are collected
echo
echo \*\*\*\* Ensure\ events\ that\ modify\ the\ system\'s\ Mandatory\ Access\ Controls\ are\ collected
egrep "^-w\s+/etc/selinux/\s+-p\s+wa\s+-k\s+MAC-policy\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/selinux/ -p wa -k MAC-policy" >> /etc/audit/rules.d/audit.rules
echo "-w /usr/share/selinux/ -p wa -k MAC-policy" >> /etc/audit/rules.d/audit.rules

# Ensure events that modify the system's network environment are collected
echo
echo \*\*\*\* Ensure\ events\ that\ modify\ the\ system\'s\ network\ environment\ are\ collected
egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+sethostname\s+-S\s+setdomainname\s+-k\s+system-locale\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/rules.d/audit.rules
egrep "^-w\s+/etc/issue\s+-p\s+wa\s+-k\s+system-locale\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/issue -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules
egrep "^-w\s+/etc/issue.net\s+-p\s+wa\s+-k\s+system-locale\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/issue.net -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules
egrep "^-w\s+/etc/hosts\s+-p\s+wa\s+-k\s+system-locale\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/hosts -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules
egrep "^-w\s+/etc/sysconfig/network\s+-p\s+wa\s+-k\s+system-locale\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/sysconfig/network -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules
egrep "^-w\s+/etc/sysconfig/network-scripts\s+-p\s+wa\s+-k\s+system-locale\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/sysconfig/network-scripts/ -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules
uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+sethostname\s+-S\s+setdomainname\s+-k\s+system-locale\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/rules.d/audit.rules

# Ensure discretionary access control permission modification events are collected
echo
echo \*\*\*\* Ensure\ discretionary\ access\ control\ permission\ modification\ events\ are\ collected
egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+chmod\s+-S\s+fchmod\s+-S\s+fchmodat\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+perm_mod\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+chown\s+-S\s+fchown\s+-S\s+fchownat\s+-S\s+lchown\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+perm_mod\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+setxattr\s+-S\s+lsetxattr\s+-S\s+fsetxattr\s+-S\s+removexattr\s+-S\s+lremovexattr\s+-S\s+fremovexattr\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+perm_mod\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+chmod\s+-S\s+fchmod\s+-S\s+fchmodat\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+perm_mod\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+chown\s+-S\s+fchown\s+-S\s+fchownat\s+-S\s+lchown\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+perm_mod\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+setxattr\s+-S\s+lsetxattr\s+-S\s+fsetxattr\s+-S\s+removexattr\s+-S\s+lremovexattr\s+-S\s+fremovexattr\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+perm_mod\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules

# Ensure unsuccessful unauthorized file access attempts are collected
echo
echo \*\*\*\* Ensure\ unsuccessful\ unauthorized\ file\ access\ attempts\ are\ collected
egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+creat\s+-S\s+open\s+-S\s+openat\s+-S\s+truncate\s+-S\s+ftruncate\s+-F\s+exit=-EACCES\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+access\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/audit.rules
egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+creat\s+-S\s+open\s+-S\s+openat\s+-S\s+truncate\s+-S\s+ftruncate\s+-F\s+exit=-EPERM\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+access\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/audit.rules
uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+creat\s+-S\s+open\s+-S\s+openat\s+-S\s+truncate\s+-S\s+ftruncate\s+-F\s+exit=-EACCES\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+access\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/audit.rules
uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+creat\s+-S\s+open\s+-S\s+openat\s+-S\s+truncate\s+-S\s+ftruncate\s+-F\s+exit=-EPERM\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+access\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/audit.rules

# Ensure events that modify user/group information are collected
echo
echo \*\*\*\* Ensure\ events\ that\ modify\ user/group\ information\ are\ collected
egrep "^-w\s+/etc/group\s+-p\s+wa\s+-k\s+identity\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/group -p wa -k identity" >> /etc/audit/rules.d/audit.rules
egrep "^-w\s+/etc/passwd\s+-p\s+wa\s+-k\s+identity\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/passwd -p wa -k identity" >> /etc/audit/rules.d/audit.rules
egrep "^-w\s+/etc/gshadow\s+-p\s+wa\s+-k\s+identity\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/gshadow -p wa -k identity" >> /etc/audit/rules.d/audit.rules
egrep "^-w\s+/etc/shadow\s+-p\s+wa\s+-k\s+identity\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/shadow -p wa -k identity" >> /etc/audit/rules.d/audit.rules
egrep "^-w\s+/etc/security/opasswd\s+-p\s+wa\s+-k\s+identity\s*$" /etc/audit/rules.d/audit.rules || echo "-w /etc/security/opasswd -p wa -k identity" >> /etc/audit/rules.d/audit.rules

# Ensure successful file system mounts are collected
echo
echo \*\*\*\* Ensure\ successful\ file\ system\ mounts\ are\ collected
egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+mount\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+mounts\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/rules.d/audit.rules
uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+mount\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+mounts\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/rules.d/audit.rules

# Ensure use of privileged commands is collected
echo
echo \*\*\*\* Ensure\ use\ of\ privileged\ commands\ is\ collected
for file in `find / -xdev \( -perm -4000 -o -perm -2000 \) -type f`; do egrep -q "^\s*-a\s+(always,exit|exit,always)\s+-F\s+path=$file\s+-F\s+perm=x\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+privileged\s*(#.*)?$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F path=$file -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules; done

# Ensure file deletion events by users are collected
echo
echo \*\*\*\* Ensure\ file\ deletion\ events\ by\ users\ are\ collected
egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+unlink\s+-S\s+unlinkat\s+-S\s+rename\s+-S\s+renameat\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+delete\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/rules.d/audit.rules
uname -p | grep -q 'x86_64' && egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+unlink\s+-S\s+unlinkat\s+-S\s+rename\s+-S\s+renameat\s+-F\s+auid>=1000\s+-F\s+auid!=4294967295\s+-k\s+delete\s*$" /etc/audit/rules.d/audit.rules || echo "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete" >> /etc/audit/rules.d/audit.rules

# Ensure kernel module loading and unloading is collected
echo
echo \*\*\*\* Ensure\ kernel\ module\ loading\ and\ unloading\ is\ collected
egrep "^-w\s+/sbin/insmod\s+-p\s+x\s+-k\s+modules\s*$" /etc/audit/rules.d/modules.rules || echo "-w /sbin/insmod -p x -k modules" >> /etc/audit/rules.d/modules.rules
egrep "^-w\s+/sbin/rmmod\s+-p\s+x\s+-k\s+modules\s*$" /etc/audit/rules.d/modules.rules || echo "-w /sbin/rmmod -p x -k modules" >> /etc/audit/rules.d/modules.rules
egrep "^-w\s+/sbin/modprobe\s+-p\s+x\s+-k\s+modules\s*$" /etc/audit/rules.d/modules.rules || echo "-w /sbin/modprobe -p x -k modules" >> /etc/audit/rules.d/modules.rules
egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b32\s+-S\s+init_module\s+-S\s+delete_module\s+-k\s+modules\s*$" /etc/audit/rules.d/modules.rules || echo "-a always,exit -F arch=b32 -S init_module -S delete_module -k modules" >> /etc/audit/rules.d/modules.rules
egrep "^-a\s+(always,exit|exit,always)\s+-F\s+arch=b64\s+-S\s+init_module\s+-S\s+delete_module\s+-k\s+modules\s*$" /etc/audit/rules.d/modules.rules || echo "-a always,exit -F arch=b64 -S init_module -S delete_module -k modules" >> /etc/audit/rules.d/modules.rules

# Ensure system administrator actions (sudolog) are collected
echo
echo \*\*\*\* Ensure\ system\ administrator\ actions\ \(sudolog\)\ are\ collected
egrep "^-w\s+/var/log/sudo.log\s+-p\s+wa\s+-k\s+actions\s*$" /etc/audit/rules.d/audit.rules || echo "-w /var/log/sudo.log -p wa -k actions" >> /etc/audit/rules.d/audit.rules

# Ensure the audit configuration is immutable
echo
echo \*\*\*\* Ensure\ the\ audit\ configuration\ is\ immutable
egrep "^-e\s+2\s*$" /etc/audit/rules.d/99-finalize.rules || echo "-e 2" >> /etc/audit/rules.d/99-finalize.rules

# Ensure rsyslog is installed (Scored)
echo
echo Ensure rsyslog is installed \(Scored\)
rpm -q rsyslog || dnf -y install rsyslog

# Ensure rsyslog Service is enabled
echo
echo \*\*\*\* Ensure\ rsyslog\ Service\ is\ enabled
systemctl --now enable rsyslog

# Ensure rsyslog default file permissions configured
echo
echo \*\*\*\* Ensure\ rsyslog\ default\ file\ permissions\ configured
echo Ensure\ rsyslog\ default\ file\ permissions\ configured not configured.
grep -q "^\$FileCreateMode" /etc/rsyslog.conf || echo '$FileCreateMode 0640' >> /etc/rsyslog.conf
for i in /etc/rsyslog.d/*.conf
do
	grep -q "^\$FileCreateMode" $i || echo '$FileCreateMode 0640' >> $i
done

# Ensure rsyslog is configured to send logs to a remote log host
echo
echo \*\*\*\* Ensure\ rsyslog\ is\ configured\ to\ send\ logs\ to\ a\ remote\ log\ host

# Ensure journald is configured to send logs to rsyslog
echo
echo \*\*\*\* Ensure journald is configured to send logs to rsyslog
(egrep -q "^\s*ForwardToSyslog" /etc/systemd/journald.conf && sed -ri "s/^(\s*ForwardToSyslog\s*\=\s*).*/\1yes/" /etc/systemd/journald.conf)|| echo "ForwardToSyslog=yes" >> /etc/systemd/journald.conf

# Ensure journald is configured to compress large log files
echo
echo \*\*\*\* Ensure journald is configured to compress large log files
(egrep -q "^\s*Compress" /etc/systemd/journald.conf && sed -ri "s/^(\s*Compress\s*\=\s*).*/\1yes/" /etc/systemd/journald.conf) || echo "Compress=yes" >> /etc/systemd/journald.conf

# Ensure journald is configured to write logfiles to persistent disk
echo
echo \*\*\*\* Ensure journald is configured to write logfiles to persistent disk
(egrep -q "^\s*Storage" /etc/systemd/journald.conf && sed -ri "s/^(\s*Storage\s*\=\s*).*/\1persistent/" /etc/systemd/journald.conf) || echo "Storage=persistent" >> /etc/systemd/journald.conf

# Ensure permissions on all logfiles are configured

# echo
# echo \*\*\*\* Ensure\ permissions\ on\ all\ logfiles\ are\ configured
# chmod -R g-w-x,o-r-w-x /var/log/.*

# Ensure cron daemon is enabled
echo
echo \*\*\*\* Ensure\ cron\ daemon\ is\ enabled
systemctl --now enable crond

# Ensure permissions on /etc/crontab are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/crontab\ are\ configured
chown root:root /etc/crontab
chmod g-r-w-x,o-r-w-x /etc/crontab

# Ensure permissions on /etc/cron.hourly are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/cron.hourly\ are\ configured
chown root:root /etc/cron.hourly
chmod g-r-w-x,o-r-w-x /etc/cron.hourly

# Ensure permissions on /etc/cron.daily are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/cron.daily\ are\ configured
chown root:root /etc/cron.daily
chmod g-r-w-x,o-r-w-x /etc/cron.daily

# Ensure permissions on /etc/cron.weekly are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/cron.weekly\ are\ configured
chown root:root /etc/cron.weekly
chmod g-r-w-x,o-r-w-x /etc/cron.weekly

# Ensure permissions on /etc/cron.monthly are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/cron.monthly\ are\ configured
chown root:root /etc/cron.monthly
chmod g-r-w-x,o-r-w-x /etc/cron.monthly

# Ensure permissions on /etc/cron.d are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/cron.d\ are\ configured
chown root:root /etc/cron.d
chmod g-r-w-x,o-r-w-x /etc/cron.d

# Ensure at/cron is restricted to authorized users
echo
echo \*\*\*\* Ensure\ at \/cron\ is\ restricted\ to\ authorized\ users
rm -f /etc/cron.deny
rm -f /etc/at.deny
touch /etc/cron.allow
touch /etc/at.allow
chmod g-r-w-x,o-r-w-x /etc/cron.allow
chmod g-r-w-x,o-r-w-x /etc/at.allow
chown root:root /etc/cron.allow
chown root:root /etc/cron.at

# Ensure permissions on /etc/ssh/sshd_config are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/ssh/sshd_config\ are\ configured
chown root:root /etc/ssh/sshd_config
chmod g-r-w-x,o-r-w-x /etc/ssh/sshd_config

# Ensure SSH access is limited
echo
echo \*\*\*\* Ensure\ SSH\ access\ is\ limited
echo Ensure\ SSH\ access\ is\ limited not configured.

# Ensure permissions on SSH private host key files are configured
echo
echo \*\*\*\* Ensure permissions on SSH private host key files are configured
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chown root:root {} \;
find /etc/ssh -xdev -type f -name 'ssh_host_*_key' -exec chmod 0600 {} \;

# Ensure permissions on SSH public host key files are configured
echo
echo \*\*\*\* Ensure permissions on SSH public host key files are configured
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chmod 0644 {} \;
find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec chown root:root {} \;

# Ensure SSH LogLevel is appropriate
# echo
# echo \*\*\*\* Ensure SSH LogLevel is appropriate
# (egrep -q "^\s*LogLevel" /etc/ssh/sshd_config && sed -ri "s/^(\s*LogLevel\s*).*/\1INFO/" /etc/ssh/sshd_config) || echo "LogLevel yes" >> /etc/ssh/sshd_config

# Ensure SSH X11 forwarding is disabled
echo
echo \*\*\*\* Ensure\ SSH\ X11\ forwarding\ is\ disabled
egrep -q "^(\s*)X11Forwarding\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)X11Forwarding\s+\S+(\s*#.*)?\s*$/\1X11Forwarding no\2/" /etc/ssh/sshd_config || echo "X11Forwarding no" >> /etc/ssh/sshd_config

# Ensure SSH MaxAuthTries is set to 4 or less
echo
echo \*\*\*\* Ensure\ SSH\ MaxAuthTries\ is\ set\ to\ 4\ or\ less
egrep -q "^(\s*)MaxAuthTries\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)MaxAuthTries\s+\S+(\s*#.*)?\s*$/\1MaxAuthTries 4\2/" /etc/ssh/sshd_config || echo "MaxAuthTries 4" >> /etc/ssh/sshd_config

# Ensure SSH IgnoreRhosts is enabled
echo
echo \*\*\*\* Ensure\ SSH\ IgnoreRhosts\ is\ enabled
egrep -q "^(\s*)IgnoreRhosts\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)IgnoreRhosts\s+\S+(\s*#.*)?\s*$/\1IgnoreRhosts yes\2/" /etc/ssh/sshd_config || echo "IgnoreRhosts yes" >> /etc/ssh/sshd_config

# Ensure SSH HostbasedAuthentication is disabled
echo
echo \*\*\*\* Ensure\ SSH\ HostbasedAuthentication\ is\ disabled
egrep -q "^(\s*)HostbasedAuthentication\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)HostbasedAuthentication\s+\S+(\s*#.*)?\s*$/\1HostbasedAuthentication no\2/" /etc/ssh/sshd_config || echo "HostbasedAuthentication no" >> /etc/ssh/sshd_config

# Ensure SSH root login is disabled
echo
echo \*\*\*\* Ensure\ SSH\ root\ login\ is\ disabled
egrep -q "^(\s*)PermitRootLogin\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)PermitRootLogin\s+\S+(\s*#.*)?\s*$/\1PermitRootLogin no\2/" /etc/ssh/sshd_config || echo "PermitRootLogin no" >> /etc/ssh/sshd_config

# Ensure SSH PermitEmptyPasswords is disabled
echo
echo \*\*\*\* Ensure\ SSH\ PermitEmptyPasswords\ is\ disabled
egrep -q "^(\s*)PermitEmptyPasswords\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)PermitEmptyPasswords\s+\S+(\s*#.*)?\s*$/\1PermitEmptyPasswords no\2/" /etc/ssh/sshd_config || echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config

# Ensure SSH PermitUserEnvironment is disabled
echo
echo \*\*\*\* Ensure\ SSH\ PermitUserEnvironment\ is\ disabled
egrep -q "^(\s*)PermitUserEnvironment\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)PermitUserEnvironment\s+\S+(\s*#.*)?\s*$/\1PermitUserEnvironment no\2/" /etc/ssh/sshd_config || echo "PermitUserEnvironment no" >> /etc/ssh/sshd_config

# Ensure SSH Idle Timeout Interval is configured
echo
echo \*\*\*\* Ensure\ SSH\ Idle\ Timeout\ Interval\ is\ configured
egrep -q "^(\s*)ClientAliveInterval\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)ClientAliveInterval\s+\S+(\s*#.*)?\s*$/\1ClientAliveInterval 300\2/" /etc/ssh/sshd_config || echo "ClientAliveInterval 300" >> /etc/ssh/sshd_config
egrep -q "^(\s*)ClientAliveCountMax\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)ClientAliveCountMax\s+\S+(\s*#.*)?\s*$/\1ClientAliveCountMax 3\2/" /etc/ssh/sshd_config || echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config

# Ensure SSH LoginGraceTime is set to one minute or less
echo
echo \*\*\*\* Ensure\ SSH\ LoginGraceTime\ is\ set\ to\ one\ minute\ or\ less
egrep -q "^(\s*)LoginGraceTime\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)LoginGraceTime\s+\S+(\s*#.*)?\s*$/\1LoginGraceTime 60\2/" /etc/ssh/sshd_config || echo "LoginGraceTime 60" >> /etc/ssh/sshd_config

# Ensure SSH warning banner is configured
echo
echo \*\*\*\* Ensure\ SSH\ warning\ banner\ is\ configured
egrep -q "^(\s*)Banner\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)Banner\s+\S+(\s*#.*)?\s*$/\1Banner \/etc\/issue.net\2/" /etc/ssh/sshd_config || echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config

# Ensure SSH PAM is enabled
echo
echo \*\*\*\* Ensure SSH PAM is enabled
egrep -q "^(\s*)UsePAM\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)UsePAM\s+\S+(\s*#.*)?\s*$/\1UsePAM yes\2/" /etc/ssh/sshd_config || echo "UsePAM yes" >> /etc/ssh/sshd_config

# Ensure SSH AllowTcpForwarding is disabled
echo
echo \*\*\*\* Ensure SSH AllowTcpForwarding is disabled
egrep -q "^(\s*)AllowTcpForwarding\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)AllowTcpForwarding\s+\S+(\s*#.*)?\s*$/\1AllowTcpForwarding no\2/" /etc/ssh/sshd_config || echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config

# Ensure SSH MaxStartups is configured
echo
echo \*\*\*\* Ensure SSH MaxStartups is configured
egrep -q "^(\s*)maxstartups\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)maxstartups\s+\S+(\s*#.*)?\s*$/\1maxstartups 10\:30\:60\2/" /etc/ssh/sshd_config || echo "maxstartups 10:30:60" >> /etc/ssh/sshd_config

# Ensure SSH MaxSessions is set to 4 or less
echo
echo \*\*\*\* Ensure SSH MaxSessions is set to 4 or less
egrep -q "^(\s*)MaxSessions\s+\S+(\s*#.*)?\s*$" /etc/ssh/sshd_config && sed -ri "s/^(\s*)MaxSessions\s+\S+(\s*#.*)?\s*$/\1MaxSessions 4\2/" /etc/ssh/sshd_config || echo "MaxSessions 4" >> /etc/ssh/sshd_config

# Ensure system-wide crypto policy is not over-ridden
echo
echo \*\*\*\* Ensure system-wide crypto policy is not over-ridden
egrep -q "^(\s*)CRYPTO_POLICY\s*=\s*" /etc/sysconfig/sshd && sed -ri "s/^\s*(CRYPTO_POLICY\s*=.*)$/# \1/" /etc/sysconfig/sshd

# Ensure password creation requirements are configured
echo
echo \*\*\*\* Ensure\ password\ creation\ requirements\ are\ configured
egrep -q "^(\s*)minlen\s*=\s*\S+(\s*#.*)?\s*$" /etc/security/pwquality.conf && sed -ri "s/^(\s*)minlen\s*=\s*\S+(\s*#.*)?\s*$/\minlen=9\2/" /etc/security/pwquality.conf || echo "minlen = 9" >> /etc/security/pwquality.conf
egrep -q "^(\s*)dcredit\s*=\s*\S+(\s*#.*)?\s*$" /etc/security/pwquality.conf && sed -ri "s/^(\s*)dcredit\s*=\s*\S+(\s*#.*)?\s*$/\dcredit=-1\2/" /etc/security/pwquality.conf || echo "dcredit = -1" >> /etc/security/pwquality.conf
egrep -q "^(\s*)ucredit\s*=\s*\S+(\s*#.*)?\s*$" /etc/security/pwquality.conf && sed -ri "s/^(\s*)ucredit\s*=\s*\S+(\s*#.*)?\s*$/\ucredit=-1\2/" /etc/security/pwquality.conf || echo "ucredit = -1" >> /etc/security/pwquality.conf
egrep -q "^(\s*)ocredit\s*=\s*\S+(\s*#.*)?\s*$" /etc/security/pwquality.conf && sed -ri "s/^(\s*)ocredit\s*=\s*\S+(\s*#.*)?\s*$/\ocredit=-1\2/" /etc/security/pwquality.conf || echo "ocredit = -1" >> /etc/security/pwquality.conf
egrep -q "^(\s*)lcredit\s*=\s*\S+(\s*#.*)?\s*$" /etc/security/pwquality.conf && sed -ri "s/^(\s*)lcredit\s*=\s*\S+(\s*#.*)?\s*$/\lcredit=-1\2/" /etc/security/pwquality.conf || echo "lcredit = -1" >> /etc/security/pwquality.conf
egrep -q "^\s*password\s+requisite\s+pam_pwquality.so\s+" /etc/pam.d/system-auth && sed -ri '/^\s*password\s+requisite\s+pam_pwquality.so\s+/ { /^\s*password\s+requisite\s+pam_pwquality.so(\s+\S+)*(\s+try_first_pass)(\s+.*)?$/! s/^(\s*password\s+requisite\s+pam_pwquality.so\s+)(.*)$/\1try_first_pass \2/ }' /etc/pam.d/system-auth && sed -ri '/^\s*password\s+requisite\s+pam_pwquality.so\s+/ { /^\s*password\s+requisite\s+pam_pwquality.so(\s+\S+)*(\s+retry=[0-9]+)(\s+.*)?$/! s/^(\s*password\s+requisite\s+pam_pwquality.so\s+)(.*)$/\1retry=3 \2/ }' /etc/pam.d/system-auth && sed -ri 's/(^\s*password\s+requisite\s+pam_pwquality.so(\s+\S+)*\s+)retry=[0-9]+(\s+.*)?$/\1retry=3\3/' /etc/pam.d/system-auth || echo Ensure\ password\ creation\ requirements\ are\ configured - /etc/pam.d/system-auth not configured.
egrep -q "^\s*password\s+requisite\s+pam_pwquality.so\s+" /etc/pam.d/password-auth && sed -ri '/^\s*password\s+requisite\s+pam_pwquality.so\s+/ { /^\s*password\s+requisite\s+pam_pwquality.so(\s+\S+)*(\s+try_first_pass)(\s+.*)?$/! s/^(\s*password\s+requisite\s+pam_pwquality.so\s+)(.*)$/\1try_first_pass \2/ }' /etc/pam.d/password-auth && sed -ri '/^\s*password\s+requisite\s+pam_pwquality.so\s+/ { /^\s*password\s+requisite\s+pam_pwquality.so(\s+\S+)*(\s+retry=[0-9]+)(\s+.*)?$/! s/^(\s*password\s+requisite\s+pam_pwquality.so\s+)(.*)$/\1retry=3 \2/ }' /etc/pam.d/password-auth && sed -ri 's/(^\s*password\s+requisite\s+pam_pwquality.so(\s+\S+)*\s+)retry=[0-9]+(\s+.*)?$/\1retry=3\3/' /etc/pam.d/password-auth || echo Ensure\ password\ creation\ requirements\ are\ configured - /etc/pam.d/password-auth not configured.
# echo "password requisite pam_pwquality.so try_first_pass retry=3" >> /etc/pam.d/system-auth
# echo "password requisite pam_pwquality.so try_first_pass retry=3" >> /etc/pam.d/password-auth

# Ensure lockout for failed password attempts is configured
echo
echo \*\*\*\* Ensure lockout for failed password attempts is configured
# CP=$(authselect current | awk 'NR == 1 {print $3}' | grep custom/) 
# for FN in system-auth password-auth; do [[ -n $CP ]] && PTF=/etc/authselect/$CP/$FN || PTF=/etc/authselect/$FN [[ -n $(grep -E '^\s*auth\s+required\s+pam_faillock.so\s+.*deny=\S+\s*.*$' $PTF) ]] && sed -ri '/pam_faillock.so/s/deny=\S+/deny=5/g' $PTF || sed -ri 's/^\^\s*(auth\s+required\s+pam_faillock\.so\s+)(.*[^{}])(\{.*\}|)$/\1\2 deny=5 \3/' $PTF [[ -n $(grep -E '^\s*auth\s+required\s+pam_faillock.so\s+.*unlock_time=\S+\s*.*$' $PTF) ]] && sed -ri '/pam_faillock.so/s/unlock_time=\S+/unlock_time=900/g' $PTF || sed -ri 's/^\s*(auth\s+required\s+pam_faillock\.so\s+)(.*[^{}])(\{.*\}|)$/\1\2 unlock_time=900 \3/' $PTF 
# done 
# authselect apply-changes

# Ensure password reuse is limited
echo
echo \*\*\*\* Ensure\ password\ reuse\ is\ limited
CP=$(authselect current | awk 'NR == 1 {print $3}' | grep custom/) 
if [ -z $CP ]
then
  PTF=/etc/authselect/$CP/system-auth
else
  PTF=/etc/authselect/system-auth 
fi

egrep -q '^\s*password\s+(sufficient\s+pam_unix|requi(red|site)\s+pam_pwhistory).so\s+([^#]+\s+)*remember=\S+\s*.*$' $PTF && sed -ri 's/^\s*(password\s+(requisite|sufficient)\s+(pam_pwquality\.so|pam_unix\.so)\s+)(.*)(remember=\S+\s*)(.*)$/\1\4 remember=5 \6/' $PTF || sed -ri 's/^\s*(password\s+(requisite|sufficient)\s+(pam_pwquality\.so|pam_unix\.so)\s+)(.*)$/\1\4 remember=5/' $PTF 

authselect apply-changes

# Ensure password hashing algorithm is SHA-512
echo
echo \*\*\*\* Ensure\ password\ hashing\ algorithm\ is\ SHA-512
CP=$(authselect current | awk 'NR == 1 {print $3}' | grep custom/) 
for FN in system-auth password-auth; do [[ -z $(grep -E '^\s*password\s+sufficient\s+pam_unix.so\s+.*sha512\s*.*$' $PTF) ]] && sed -ri 's/^\s*(password\s+sufficient\s+pam_unix.so\s+)(.*)$/\1\2 sha512/' $PTF 
done 
authselect apply-changes

awk -F: '( $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' && $1 != "nfsnobody" ) { print $1 }' /etc/passwd | xargs -n 1 chage -d 0

# Ensure minimum days between password changes is 7 or more
echo
echo \*\*\*\* Ensure\ minimum\ days\ between\ password\ changes\ is\ 7\ or\ more
egrep -q "^(\s*)PASS_MIN_DAYS\s+\S+(\s*#.*)?\s*$" /etc/login.defs && sed -ri "s/^(\s*)PASS_MIN_DAYS\s+\S+(\s*#.*)?\s*$/\PASS_MIN_DAYS 7\2/" /etc/login.defs || echo "PASS_MIN_DAYS 7" >> /etc/login.defs
getent passwd | cut -f1 -d ":" | xargs -n1 chage --mindays 7

# Ensure password expiration warning days is 7 or more
echo
echo \*\*\*\* Ensure\ password\ expiration\ warning\ days\ is\ 7\ or\ more
egrep -q "^(\s*)PASS_WARN_AGE\s+\S+(\s*#.*)?\s*$" /etc/login.defs && sed -ri "s/^(\s*)PASS_WARN_AGE\s+\S+(\s*#.*)?\s*$/\PASS_WARN_AGE 7\2/" /etc/login.defs || echo "PASS_WARN_AGE 7" >> /etc/login.defs
getent passwd | cut -f1 -d ":" | xargs -n1 chage --warndays 7

# Ensure inactive password lock is 30 days or less
# No parece una buena política
# echo
# echo \*\*\*\* Ensure\ inactive\ password\ lock\ is\ 30\ days\ or\ less
# useradd -D -f 30
# getent passwd | cut -f1 -d ":" | xargs -n1 chage --inactive 30

# Ensure all users last password change date is in the past
echo
echo \*\*\*\* Ensure all users last password change date is in the past

# Ensure system accounts are secured

# Ensure default user shell timeout is 900 seconds or less
egrep -q "^(\s*)readonly\s*TMOUT\s+\S+(\s*#.*)?\s*$" /etc/bashrc && sed -ri "s/^(\s*)readonly\s*TMOUT.*$/\1readonly TMOUT=900 ; export TMOUT/" /etc/bashrc || echo "readonly TMOUT=900 ; export TMOUT" >> /etc/bashrc

# Ensure default group for the root account is GID 0
echo 
echo \*\*\*\* Ensure default group for the root account is GID 0
usermod -g 0 root

#Ensure default user umask is 027 or more restrictive
echo
echo \*\*\*\* Ensure\ default\ user\ umask\ is\ 027\ or\ more\ restrictive
egrep -q "^(\s*)umask\s+\S+(\s*#.*)?\s*$" /etc/bashrc && sed -ri "s/^(\s*)umask\s+\S+(\s*#.*)?\s*$/\1umask 027\2/" /etc/bashrc || echo "umask 027" >> /etc/bashrc
egrep -q "^(\s*)umask\s+\S+(\s*#.*)?\s*$" /etc/profile && sed -ri "s/^(\s*)umask\s+\S+(\s*#.*)?\s*$/\1umask 027\2/" /etc/profile || echo "umask 027" >> /etc/profile
for i in /etc/profile.d/*.sh
do
	egrep -q "^(\s*)umask\s+\S+(\s*#.*)?\s*$" $i && sed -ri "s/^(\s*)umask\s+\S+(\s*#.*)?\s*$/\1umask 027\2/" $i || echo "umask 027" >> $i
done

# Ensure root login is restricted to system console
echo
echo \*\*\*\* Ensure root login is restricted to system console
echo "Only for audit"
cat /etc/securetty

# Ensure access to the su command is restricted
echo
echo \*\*\*\* Ensure\ access\ to\ the\ su\ command\ is\ restricted
egrep -q "^\s*auth\s+required\s+pam_wheel.so(\s+.*)?$" /etc/pam.d/su && sed -ri '/^\s*auth\s+required\s+pam_wheel.so(\s+.*)?$/ { /^\s*auth\s+required\s+pam_wheel.so(\s+\S+)*(\s+use_uid)(\s+.*)?$/! s/^(\s*auth\s+required\s+pam_wheel.so)(\s+.*)?$/\1 use_uid\2/ }' /etc/pam.d/su || echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su

# Ensure permissions on /etc/passwd are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/passwd\ are\ configured
chown root:root /etc/passwd
chmod 644 /etc/passwd

# Ensure permissions on /etc/shadow are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/shadow\ are\ configured
chown root:root /etc/shadow
chown root:shadow /etc/shadow
chmod o-rwx,g-wx /etc/shadow

# Ensure permissions on /etc/group are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/group\ are\ configured
chown root:root /etc/group
chmod 644 /etc/shadow

# Ensure permissions on /etc/gshadow are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/gshadow\ are\ configured
chown root:root /etc/gshadow
chown root:shadow /etc/gshadow
chmod o-rwx,g-rw /etc/gshadow

#Ensure permissions on /etc/passwd- are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/passwd-\ are\ configured
chown root:root /etc/passwd-
chmod u-x,go-wx /etc/passwd-

# Ensure permissions on /etc/shadow- are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/shadow-\ are\ configured
chown root:root /etc/shadow-
chmod u-x,go-wx /etc/shadow-

#Ensure permissions on /etc/group- are configured
chown root:root /etc/group-
chmod u-x,go-wx /etc/group-

# Ensure permissions on /etc/gshadow- are configured
echo
echo \*\*\*\* Ensure\ permissions\ on\ /etc/gshadow-\ are\ configured
chown root:root /etc/gshadow-
chmod u-x,go-wx /etc/gshadow-

# Ensure no world writable files exist
echo
echo \*\*\*\* Ensure no world writable files exist
echo "Audit: no output is expected"
df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002


grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; 
do 
	if [ ! -d "$dir" ]; then 
		echo "The home directory ($dir) of user $user does not exist." 
	else 
		dirperm=$(ls -ld $dir | cut -f1 -d" ") 
		if [ $(echo $dirperm | cut -c6) != "-" ]; then 
			echo "Group Write permission set on the home directory ($dir) of user $user" 
		fi 
		if [ $(echo $dirperm | cut -c8) != "-" ]; then 
			echo "Other Read permission set on the home directory ($dir) of user $user" 
		fi 
		if [ $(echo $dirperm | cut -c9) != "-" ]; then 
			echo "Other Write permission set on the home directory ($dir) of user $user" 
		fi 
		if [ $(echo $dirperm | cut -c10) != "-" ]; then
			echo "Other Execute permission set on the home directory ($dir) of user $user" 
		fi 
	fi 
done

# Ensure users own their home directories
echo
echo \*\*\*\* Ensure users own their home directories
echo "Audit:"
grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; 
do 
	if [ ! -d "$dir" ]; then 
		echo "The home directory ($dir) of user $user does not exist." 
	else 
		owner=$(stat -L -c "%U" "$dir") 
		if [ "$owner" != "$user" ]; then 
			echo "The home directory ($dir) of user $user is owned by $owner." 
		fi 
	fi 
done




