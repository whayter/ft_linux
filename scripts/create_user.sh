#!/bin/bash

set -eux

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
echo -e "ft_linux_42\nft_linux_42" | passwd lfs

chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac