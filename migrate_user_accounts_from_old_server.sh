#!/bin/bash

#Following files/dirs are required for traditional Linux user management:
#* /etc/passwd – contains various pieces of information for each user account
#* /etc/shadow – contains the encrypted password information for user’s accounts and optional the password aging information.
#* /etc/group – defines the groups to which users belong
#* /etc/gshadow – group shadow file (contains the encrypted password for group)
#* /var/spool/mail – Generally user emails are stored here.
#* /home – All Users data is stored here.

# Create a folder for storing old users
mkdir /root/move/

# Users that are added to the Linux system always start with UID and GID values of as specified by Linux distribution or set by admin. Limits according to different Linux distro:
#    RHEL/CentOS/Fedora Core : Default is 500 and upper limit is 65534 (/etc/libuser.conf).
#    Debian and Ubuntu Linux : Default is 1000 and upper limit is 29999 (/etc/adduser.conf).
# Setup UID filter limit (set this value as per your Linux distro)
export UGIDLIMIT=500
# Copy /etc/passwd accounts to /root/move/passwd.mig and filter out system account (i.e. only copy user accounts)
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/passwd > /root/move/passwd.mig
# Copy /etc/group file to /root/move/group.mig and filter out system groups (i.e. only copy user groups)
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534)' /etc/group > /root/move/group.mig
# Copy /etc/shadow file
awk -v LIMIT=$UGIDLIMIT -F: '($3>=LIMIT) && ($3!=65534) {print $1}' /etc/passwd | tee - |egrep -f - /etc/shadow > /root/move/shadow.mig
# Copy /etc/gshadow (rarely used)
cp /etc/gshadow /root/move/gshadow.mig
# Make a backup of /home and /var/spool/mail dirs
tar -zcvpf /root/move/home.tar.gz /home
tar -zcvpf /root/move/mail.tar.gz /var/spool/mail

# Use scp to copy /root/move to a new Linux system.
# scp -r /root/move/* user@new.linuxserver.com:/path/to/location

#useradd -d [HOME_DIR] -g [GROUP] LOGIN_NAME
#cat /etc/group | cut -d: -f1