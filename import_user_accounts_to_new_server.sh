#!/bin/bash

# First, make a backup of current users and passwords:
mkdir /root/newsusers.bak
cp /etc/passwd /etc/shadow /etc/group /etc/gshadow /root/newsusers.bak

# Now restore passwd and other files in /etc/
cd {/path/to/location}
cat passwd.mig >> /etc/passwd
cat group.mig >> /etc/group
cat shadow.mig >> /etc/shadow
/bin/cp gshadow.mig /etc/gshadow

# Copy and extract home.tar.gz to new server /home
cd /
tar -zxvf {/path/to/location}/home.tar.gz

# Copy and extract mail.tar.gz (Mails) to new server /var/spool/mail
cd /
tar -zxvf /path/to/location/mail.tar.gz