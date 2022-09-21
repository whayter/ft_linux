#!/bin/bash

set -eux

/sbin/swapon -v /dev/sdb1  
mkdir -p $LFS
mount -v -t ext4 /dev/sdb3 $LFS
mkdir -p $LFS/boot
mount -v -t ext2 /dev/sdb2 $LFS/boot