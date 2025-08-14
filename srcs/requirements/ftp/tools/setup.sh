#!/bin/bash
set -e

chown -R 33:33 /home/ftpuser
chmod -R 755 /home/ftpuser

# Default values if not set in environment
FTP_USER=${FTP_USER:-ftpuser}
FTP_PASS=${FTP_PASS:-ftppass}

# Ensure the user exists
if ! id "$FTP_USER" &>/dev/null; then
    useradd -m -u 33 -o -g 33 -s /bin/bash "$FTP_USER"
    echo "$FTP_USER:$FTP_PASS" | chpasswd
fi

# Start vsftpd
exec vsftpd /etc/vsftpd.conf


