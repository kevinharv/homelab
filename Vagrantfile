Vagrant.configure("2") do |config|
    # Define environment configuration
    config.ssh.insert_key = false
    config.vm.synced_folder '.', '/vagrant', disabled: true
  
    # Configure VM sizing
    config.vm.provider "libvirt" do |v|
      v.memory = 2048
      v.cpus = 2
    end

    # OpenVPN Access Server (AS)
#    config.vm.define "PRDOVPN" do |v|
#      v.vm.box      = "generic/rocky9"
#      v.vm.hostname = "PRDOVPN"
#      v.vm.network "private_network", ip: "10.100.1.10", hostname: true
#      v.vm.disk :disk, size: "20GB", primary: true
#    end
    
    # Lab NAS
#    config.vm.define "PRDNAS1" do |v|
#      v.vm.box      = "generic/rocky9"
#      v.vm.hostname = "PRDNAS1"
#      v.vm.network "private_network", ip: "10.100.1.13", hostname: true
#      v.vm.disk :disk, size: "20GB", primary: true
#      v.vm.disk :disk, size: "50GB", name: "storage"
#    end

    # FreeIPA Server
#    config.vm.define "PRDIPA1" do |v|
#      v.vm.box      = "generic/rocky9"
#      v.vm.hostname = "PRDIPA1"
#      v.vm.network "private_network", ip: "10.100.1.16", hostname: true
#      v.vm.disk :disk, size: "20GB", primary: true
#    end

    # Puppet Open-Source Master
#    config.vm.define "PRDPUPM" do |v|
#      v.vm.box      = "generic/rocky9"
#      v.vm.hostname = "PRDPUPM"
#      v.vm.network "private_network", ip: "10.100.1.18", hostname: true
#      v.vm.disk :disk, size: "20GB", primary: true
#    end

    # Kubernetes Cluster
    (1..3).each do |i|
      config.vm.define "PRDKUB#{i}" do |v|
        v.vm.box      = "generic/rocky9"
        v.vm.hostname = "PRDKUB#{i}"
        v.vm.network :private_network, :ip => "10.100.1.2#{i}", hostname: true
        v.vm.disk :disk, size: "20GB", primary: true
      end
    end

    # NixOS Development Box
#    config.vm.define "DEVNIX1" do |v|
#      v.vm.box      = "hennersz/nixos-23.05"
#      v.vm.hostname = "DEVNIX1"
#      v.vm.network "private_network", ip: "10.100.1.5", hostname: true
#      v.vm.disk :disk, size: "20GB", primary: true
#    end
end
