Vagrant.configure("2") do |config|
  config.vm.box = "generic/gentoo"

  config.vm.provider "virtualbox" do |vb|    
    vb.cpus = 10
    vb.memory = 8000
  end

  config.vm.synced_folder ".", "/ft_linux", type: "virtualbox"
    
  config.vm.provision "shell", name: "Setting up the host", privileged: true,  inline: <<-SHELL
    set -eux
    echo -e "\nexport LFS=/mnt/lfs" >> /etc/bash/bashrc
  SHELL

end