* [lfs - version 11.2-systemd](http://fr.linuxfromscratch.org/view/lfs-systemd-stable/)
* [erata](https://www.linuxfromscratch.org/lfs/errata/11.2-systemd/


* root:ft_linux

#### To do:

* `vagrant up`
* `vagrant halt`
* add ft_linux.vdi as a new sata hard disk in virtualbox
* `vagrant up`
* `vagrant ssh`

* `sudo su -`
* `sh /ft_linux/scripts/mount_partritions.sh`

* make sure virtual file systems are mounted : `findmnt | grep $LFS`
* if not: `sh /ft_linux/scripts/mount_virtual_fs.sh`

* enter the chroot env: `sh /ft_linux/scripts/enter_chroot_env.sh`

* go to (8.32)[http://fr.linuxfromscratch.org/view/lfs-systemd-stable/chapter08/bison.html]

