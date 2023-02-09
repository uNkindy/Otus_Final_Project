# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config| 

    config.vm.define "host1" do |host1|
      host1.vm.box = 'centos/7'
    
      host1.vm.host_name = 'host1'
      host1.vm.network "private_network", ip: "192.168.56.240"
    
      host1.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
      end
      end
    
    
    config.vm.define "host2" do |host2|
        host2.vm.box = 'centos/7'
    
        host2.vm.host_name = 'host2'
        host2.vm.network "private_network", ip: "192.168.56.241"
      
        host2.vm.provider "virtualbox" do |vb|
          vb.memory = "2048"
        end
        end
    
    
      config.vm.define "host3" do |host3|
        host3.vm.box = 'centos/7'
    
        host3.vm.host_name = 'host3'
        host3.vm.network "private_network", ip: "192.168.56.242"
      
        host3.vm.provider "virtualbox" do |vb|
          vb.memory = "2048"
        end
        end

        config.vm.define "host4" do |host4|
            host4.vm.box = 'centos/7'
        
            host4.vm.host_name = 'host4'
            host4.vm.network "private_network", ip: "192.168.56.243"
          
            host4.vm.provider "virtualbox" do |vb|
              vb.memory = "2048"
            end
            end
    end