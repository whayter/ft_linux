# Walkthrough

## Creating target virtual machine

Create a new virtual machine in VirtualBox:
* name: ft_linux
* type: linux
* version: Ohter Linux (64-bit)

Allow at least 15GB for the virtual disk.

---

## Launching host system

* create and configure the host virtual machine according to the [Vagrantfile](Vagrantfile): `vagrant up`
* shuts down the host virtual machine: `vagrant halt`
* Open VirtualBox and attach ft_linux.vdi as a new SATA hard disk to the newly created virtual machine
* run the host virtual machine again: `vagrant up`
* SSH into a the running Vagrant machine: `vagrant ssh`
* get root access: `sudo su -`

---

## Creating partitions (root, swap and boot)

* start the fdisk program on sdb (you want to target ft_linux.vdi): `fdisk /dev/sdb`

### creating the swap partition:

* `n` for new
* `p` for primary type
* press <kbd>Enter</kbd> for default partition number
* press <kbd>Enter</kbd> for default first sector
* `+1G` for last sector
* `t` for defining type
* `l` to list hex codes (hex code for swap is 82)

### creating the boot partition:

* `n` for new
* `p` for primary type
* press <kbd>Enter</kbd> for default partition number
* press <kbd>Enter</kbd> for default first sector
* `+2G` for last sector

### creating the root partition:

* `n` for new
* `p` for primary type
* press <kbd>Enter</kbd> for default partition number
* press <kbd>Enter</kbd> for default first sector
* press <kbd>Enter</kbd> for default last sector
* `w` to write the informations to the disk and quit the fdisk program

### Formating partitions:

* `mkswap /dev/sdb1`
* `mkfs -v -t ext2 /dev/sdb2`
* `mkfs -v -t ext4 /dev/sdb3`

### Defining LFS variable:

* `export LFS=/mnt/lfs`

### Mouting partitions: 

* run the [mount_partitions script](/scripts/mount_partitions.sh)

---

## Downloading packages

* create the sources directory: `mkdir -v $LFS/sources; chmod -v a+wt $LFS/sources`
* place the wget-list into the sources directory: `cp /ft_linux/wget-list $LF/sources`
* download all packages from the wget-list: `wget --input-file=wget-list --continue --directory-prefix=$LFS/sources`
* place the md5sums file in the sources directory: `cp /ft_linux/md5sums $LFS/sources`
* make sure packets are available:
```
pushd $LFS/sources
  md5sum -c md5sums
popd
```

---

## Creating the required repositories

* run the [create_basic_repositories script](/scripts/create_basic_repositories.sh)

---

## Creating the LFS user

* add the group and user:

```shell
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
```

* give a password: `passwd lfs`

* give full rights on $LFS to the new lfs user:

```shell
chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac
```

* if the previous command doesn't end correctly, run `fg` to bring the lfs user to the front.

* connect as lfs user: `su - lfs`

---

## Configuring the environment

* run the [env_config script](/scripts/env_config.sh)
* load the newly created user profile: `source ~/.bash_profile`

---

## Compiling a cross-tool chain

The programs compiled in this chapter will be installed in the $LFS/tools directory in order to keep them separate from the files installed later. The libraries, on the other hand, are installed in their final location, as they belong to the system we want to build. As lfs user, follow the book instructions from [5.1](http://fr.linuxfromscratch.org/view/lfs-systemd-stable/chapter05/binutils-pass1.html) to [5.6](http://fr.linuxfromscratch.org/view/lfs-systemd-stable/chapter05/gcc-libstdc++.html).

### build procedure:

Go to the source code directory. For each package:
* using the tar program, unzip the package to be built. 
* go to the directory created when the package was unpacked.
* Follow the instructions in the book to build the package.
* Return to the source code directory.
* delete the source directory you extracted unless instructed otherwise.

---

## Cross-compilation of temporary tools

The basic utilities are cross-compiled here using the cross-toolchain that has just been built. These utilities are installed in their final location, but cannot be used yet. The basic tasks still use the host's tools. However, the installed libraries are used when editing the links. As lfs user, follow the book instructions from [6.2](http://fr.linuxfromscratch.org/view/lfs-systemd-stable/chapter06/m4.html) to [6.18](http://fr.linuxfromscratch.org/view/lfs-systemd-stable/chapter06/gcc-pass2.html).

### build procedure:

Go to the source code directory. For each package:
* using the tar program, unzip the package to be built. 
* go to the directory created when the package was unpacked.
* Follow the instructions in the book to build the package.
* Return to the source code directory.
* delete the source directory you extracted unless instructed otherwise.

---

## Entering the chroot

Now that all the packages required to build the rest of the necessary tools are on the system, it is time to enter the chroot environment to finish installing the remaining temporary tools. We will also use this environment for the final system installation.

* connect as root user
* change the owner of the $LFS directory to the root user:

```shell
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac
```

* run the [mount_virtual_fs script](/scripts/mount_virtual_fs.sh) to prepare virtual kernel file systems
* run the [enter_chroot_env script](/scripts/enter_chroot_env.sh)

---

## Creating the complete structure of the LFS file system

```shell
mkdir -pv /{boot,home,mnt,opt,srv}

mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{include,src}
mkdir -pv /usr/local/{bin,lib,sbin}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}

ln -sfv /run /var/run
ln -sfv /run/lock /var/lock

install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
```

---

## Creating essential files and symbolic links

```shell
ln -sv /proc/self/mounts /etc/mtab
```

```shell
cat > /etc/hosts << EOF
127.0.0.1  localhost $(hostname)
::1        localhost
EOF
```

```shell
cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/usr/bin/false
systemd-journal-remote:x:74:74:systemd Journal Remote:/:/usr/bin/false
systemd-journal-upload:x:75:75:systemd Journal Upload:/:/usr/bin/false
systemd-network:x:76:76:systemd Network Management:/:/usr/bin/false
systemd-resolve:x:77:77:systemd Resolver:/:/usr/bin/false
systemd-timesync:x:78:78:systemd Time Synchronization:/:/usr/bin/false
systemd-coredump:x:79:79:systemd Core Dumper:/:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
systemd-oom:x:81:81:systemd Out Of Memory Daemon:/:/usr/bin/false
nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
EOF
```

```shell
cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
kvm:x:61:
systemd-journal-gateway:x:73:
systemd-journal-remote:x:74:
systemd-journal-upload:x:75:
systemd-network:x:76:
systemd-resolve:x:77:
systemd-timesync:x:78:
systemd-coredump:x:79:
uuidd:x:80:
systemd-oom:x:81:
wheel:x:97:
users:x:999:
nogroup:x:65534:
EOF
```

```shell
echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd
echo "tester:x:101:" >> /etc/group
install -o tester -d /home/tester
```

```shell
exec /usr/bin/bash --login
```

```shell
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp
```

---

## Building additional temporary tools

Follow the book instructions from [7.7](http://fr.linuxfromscratch.org/view/lfs-systemd-stable/chapter07/gettext.html) to [7.12](http://fr.linuxfromscratch.org/view/lfs-systemd-stable/chapter07/util-linux.html).

---

## Temporary system cleaning

```shell
rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools
```

---

## Building the LFS system

Follow the book instructions from [8.3](http://fr.linuxfromscratch.org/view/lfs-systemd-stable/chapter08/man-pages.html) to [8.77](http://fr.linuxfromscratch.org/view/lfs-systemd-stable/chapter08/e2fsprogs.html).

---

## Cleaning

```shell
save_usrlib="$(cd /usr/lib; ls ld-linux*[^g])
             libc.so.6
             libthread_db.so.1
             libquadmath.so.0.0.0
             libstdc++.so.6.0.30
             libitm.so.1.0.0
             libatomic.so.1.2.0"

cd /usr/lib

for LIB in $save_usrlib; do
    objcopy --only-keep-debug $LIB $LIB.dbg
    cp $LIB /tmp/$LIB
    strip --strip-unneeded /tmp/$LIB
    objcopy --add-gnu-debuglink=$LIB.dbg /tmp/$LIB
    install -vm755 /tmp/$LIB /usr/lib
    rm /tmp/$LIB
done

online_usrbin="bash find strip"
online_usrlib="libbfd-2.39.so
               libhistory.so.8.1
               libncursesw.so.6.3
               libm.so.6
               libreadline.so.8.1
               libz.so.1.2.12
               $(cd /usr/lib; find libnss*.so* -type f)"

for BIN in $online_usrbin; do
    cp /usr/bin/$BIN /tmp/$BIN
    strip --strip-unneeded /tmp/$BIN
    install -vm755 /tmp/$BIN /usr/bin
    rm /tmp/$BIN
done

for LIB in $online_usrlib; do
    cp /usr/lib/$LIB /tmp/$LIB
    strip --strip-unneeded /tmp/$LIB
    install -vm755 /tmp/$LIB /usr/lib
    rm /tmp/$LIB
done

for i in $(find /usr/lib -type f -name \*.so* ! -name \*dbg) \
         $(find /usr/lib -type f -name \*.a)                 \
         $(find /usr/{bin,sbin,libexec} -type f); do
    case "$online_usrbin $online_usrlib $save_usrlib" in
        *$(basename $i)* )
            ;;
        * ) strip --strip-unneeded $i
            ;;
    esac
done

unset BIN LIB save_usrlib online_usrbin online_usrlib
```

```shell
rm -rf /tmp/*
find /usr/lib /usr/libexec -name \*.la -delete
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf
userdel -r tester
```

---

## Configuring the system

See [chapter 9](http://fr.linuxfromscratch.org/view/lfs-systemd-stable/chapter09/chapter09.html)