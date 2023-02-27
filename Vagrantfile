# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config| 

  config.vm.define "proxy" do |proxy|
    proxy.vm.box = 'centos/7'
    
    proxy.vm.host_name = 'proxy'
    proxy.vm.network "private_network", ip: "192.168.56.240"
    proxy.vm.network "forwarded_port", guest: 80, host: 8080
    
    proxy.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
    end
  end
    
    
  config.vm.define "wordpress" do |wordpress|
    wordpress.vm.box = 'centos/7'

    
    wordpress.vm.host_name = 'wordpress'
    wordpress.vm.network "private_network", ip: "192.168.56.241"
    wordpress.vm.network "forwarded_port", guest: 80, host: 8081
      
    wordpress.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"

    end
  end
    
    
  config.vm.define "replica" do |replica|
    replica.vm.box = 'centos/7'
    
    replica.vm.host_name = 'replica'
    replica.vm.network "private_network", ip: "192.168.56.242"
#    replica.vm.network "forwarded_port", guest: 80, host: 8082
      
    replica.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
    end
  end

  config.vm.define "monitoring" do |monitoring|
    monitoring.vm.box = 'centos/7'
        
    monitoring.vm.host_name = 'monitoring'
    monitoring.vm.network "private_network", ip: "192.168.56.243"
          
    monitoring.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
    end
  end
end