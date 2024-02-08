Vagrant.configure("2") do |config|
    # Define environment configuration
    config.ssh.insert_key = false
    config.vm.synced_folder '.', '/vagrant', disabled: true
  
    # Configure VM sizing
    config.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.cpus = 2
    end

    # Define OpenVPN AS VM
    config.vm.define "PRDOVPN" do |v|
      v.vm.box      = "generic/rocky9"
      v.vm.hostname = "PRDOVPN"
      v.vm.network "private_network", ip: "10.100.1.10", hostname: true
      v.vm.disk :disk, size: "10GB", primary: true
      v.vm.disk :disk, size: "5GB", name: "storage"
    end
 end
