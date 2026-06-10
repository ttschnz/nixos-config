#!/usr/bin/env bash
set -euo pipefail

POOL="data"

# run: 
# lsblk -o NAME,SIZE,MODEL,SERIAL,MOUNTPOINTS
# ls -l /dev/disk/by-id/
# and then replace the disk ids:

DISK1="/dev/disk/by-id/wwn-0x5000039fffcb503b"
DISK2="/dev/disk/by-id/wwn-0x5000039ff6ee0655"

USER="tim"
GROUP="users"

echo "This will destroy all data on:"
echo "  $DISK1"
echo "  $DISK2"
echo
read -r -p "Type YES to continue: " confirm
[ "$confirm" = "YES" ]

# generate a key with  sudo dd if=/dev/urandom bs=32 count=1 of=/root/.zfs_key
zpool create \
  -o ashift=12 \
  -O compression=lz4 \
  -O atime=off \
  -O xattr=sa \
  -O acltype=posixacl \
  -O mountpoint=/data \
  -O encryption=aes-256-gcm \
  -O keyformat=raw \
  -O keylocation="file:///root/.zfs_key" \
  "$POOL" mirror "$DISK1" "$DISK2"

zfs create -o com.sun:auto-snapshot=true  "$POOL/tim"
zfs create -o com.sun:auto-snapshot=true  "$POOL/shared"
zfs create -o com.sun:auto-snapshot=false "$POOL/backup"

chown "$USER:$GROUP" /data/tim /data/shared /data/backup

chmod 0700 /data/tim
chmod 0775 /data/shared
chmod 0700 /data/backup

zpool status "$POOL"
zfs list -r "$POOL"