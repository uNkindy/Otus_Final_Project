# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config| 
    
  config.vm.define "wordpress" do |wordpress|
    wordpress.vm.box = 'centos/7'

    
    wordpress.vm.host_name = 'wordpress'
    wordpress.vm.network "private_network", ip: "192.168.56.241"
    wordpress.vm.network "forwarded_port", guest: 80, host: 8081
    wordpress.vm.network "forwarded_port", guest: 9100, host: 9101
    wordpress.vm.network "forwarded_port", guest: 9080, host: 9081
      
    wordpress.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"

    end
  end
    

  config.vm.define "replica" do |replica|
    replica.vm.box = 'centos/7'
    
    replica.vm.host_name = 'replica'
    replica.vm.network "private_network", ip: "192.168.56.242"
      
    replica.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
    end
  end

  config.vm.define "monitoring" do |monitoring|
    monitoring.vm.box = 'centos/7'
        
    monitoring.vm.host_name = 'monitoring'
    monitoring.vm.network "private_network", ip: "192.168.56.243"
    monitoring.vm.network "forwarded_port", guest: 3000, host: 3000
    monitoring.vm.network "forwarded_port", guest: 9090, host: 9090
    monitoring.vm.network "forwarded_port", guest: 3100, host: 3100

    monitoring.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
    end
  end
end