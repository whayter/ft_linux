## Last setup

* create the required repositories, beeing the root user (4.2):
```shell
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac
```

* for chapter 6:
`mkdir -pv $LFS/tools`


* add the LFS user (4.3):
```shell
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
```
* give a password:
`passwd lfs`
--> give full rights on $LFS:
```shell
chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac
```
* if the previous command doesn't end correctly, run `fg` to bring the lfs user to the front.

* now connect:
```shell
su - lfs
```



--> add this file to create a new .bash_profile being lfs user:
```shell
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
```

--> create the .bashrc file being lfs user:
```shell
cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF
```

--> make sure /etc/bash.bashrc is not present, being the root user:
```sh
[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE
```

--> load the newly created user profile:
```shell
source ~/.bash_profile
```