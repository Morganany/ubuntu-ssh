#!/bin/bash
set -e
USER_NAME="${USER_NAME:-root}"
PASS="${USER_PASSWORD:?USER_PASSWORD kosong}"
if [ "$USER_NAME" = "root" ]; then
  echo "root:$PASS" | chpasswd
  sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
else
  id "$USER_NAME" >/dev/null 2>&1 || useradd -m -s /bin/bash -G sudo "$USER_NAME"
  echo "$USER_NAME:$PASS" | chpasswd
  echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-vpsuser
  chmod 440 /etc/sudoers.d/90-vpsuser
fi
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
ssh-keygen -A
exec /usr/sbin/sshd -D -e
