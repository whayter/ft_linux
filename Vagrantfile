Vagrant.configure("2") do |config|
    config.vm.box = "generic/gentoo"
    # config.vagrant.plugins = "vagrant-reload"
  
    config.vm.provider "virtualbox" do |vb|    
      vb.cpus = 10
      vb.memory = 8168
      # vb.gui = true
      # vb.customize ["modifyvm", :id, "--vram", "128"]
    end
  
    config.vm.synced_folder ".", "/home/vagrant/ft_linux", type: "virtualbox"
    # config.vm.provision "shell", name: "Setting up VM UI", privileged: false,  inline: <<-SHELL
    #   set -ex
      
    #   sudo apt-get update
    #   DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends gdm3 ubuntu-desktop-minimal python3-pip
    #   echo "display manager and desktop installed."
     
    #   gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed s/.$//), 'org.gnome.Terminal.desktop']"
    #   echo "Terminal added to favorites."
    # SHELL
    
    # config.vm.provision :reload
      
    config.vm.provision "shell", name: "Setting up the host", privileged: true,  inline: <<-SHELL
      set -ex
      
      /sbin/swapon -v /dev/sdb1
      echo -e "\nexport LFS=/mnt/lfs" >> /etc/bash/bashrc

      mkdir -p $LFS
      mount -v -t ext4 /dev/sdb3 $LFS
      mount -v -t ext2 /dev/sdb2 $LFS/boot

      groupadd lfs
      useradd -s /bin/bash -g lfs -m -k /dev/null lfs
      echo -e "ft_linux_42\nft_linux_42" | passwd lfs

      echo "done"
    SHELL
  
  end