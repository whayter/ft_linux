`mkdir -v $LFS/sources`
`chmod -v a+wt $LFS/sources`

--> create the wget=list file, then:
`wget --input-file=wget-list-systemd --continue --directory-prefix=$LFS/sources`

--> make sure packets are available. first create the md5sums file in `$LFS/sources`, then:
```
pushd $LFS/sources
  md5sum -c md5sums
popd
```

--> 3.3: manually download stuff