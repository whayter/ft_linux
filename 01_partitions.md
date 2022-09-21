Partitions

* root
* swap
* boot

`sudo su -`
`fdisk /dev/sda`

--> first, let's create swap partition:
`n` for new
then `p` for primary type
then enter for default partition number
then enter for default first sector
then `+1G` for last sector if I want a 1GB partition
then `t` for defining type
`l` to list hex codes
hex code for swap is 82

--> now the boot partition
`n` for new
`p` for primary type
enter for default partition number
enter for default first sector
then `+2G` for last sector if I want a 2GB partition

--> now the root partition
`n` for new
`p` for primary type
enter for default partition number
enter for default first sector
enter for default last sector

`w` to write the informations to the disk and quit the fdisk program


--> need to format partitions (2.5):
`mkswap /dev/sda1`
`mkfs -v -t ext2 /dev/sda2`
`mkfs -v -t ext4 /dev/sda3`

--> define LFS variable (2.6):
`export LFS=/mnt/lfs`

--> Mouting partitions:
```
mkdir -pv $LFS
mount -v -t ext4 /dev/sda3 $LFS
```

need to mount the boot partition i guess (?):
```
mkdir -pv $LFS/boot
mount -v -t ext4 /dev/sda2 $LFS
```

make sure the swap partition is active:
`/sbin/swapon -v /dev/sda1`