Vagrant.configure("2") do |config|
    # Define environment configuration
    config.ssh.insert_key = false
    config.vm.synced_folder '.', '/vagrant', disabled: true
  
    # Configure VM sizing
    config.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 2
    end

    # Define PRDOVPN configuration
    #config.vm.define "prdovpn" do |prdovpn|
     # prdovpn.vm.box = "generic/ubuntu2204"
      #prdovpn.vm.hostname = "prdovpn"
     # prdovpn.vm.network :private_network, ip: "192.168.56.10"
    #end
  end
