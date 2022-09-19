Partitioning

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

--> now the root partition
`n` for new
`p` for primary type
enter for default partition number
enter for default first sector
then `+17G` for last sector if I want a 17GB partition

--> now the boot partition
`n` for new
`p` for primary type
enter for default partition number
enter for default first sector
enter for default last sector

`w` to write the informations to the disk and quit the fdisk program

back to the book (2.5)