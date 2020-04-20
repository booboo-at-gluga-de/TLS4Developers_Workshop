# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "generic/centos8"
    config.vm.synced_folder ".", "/vagrant"
    config.vm.provision :shell, path: "vagrant.bootstrap.sh"
    config.vm.network "forwarded_port", guest: 11443, host_ip: "127.0.0.1", host: 11443
    config.vm.network "forwarded_port", guest: 12080, host_ip: "127.0.0.1", host: 12080
    config.vm.network "forwarded_port", guest: 12443, host_ip: "127.0.0.1", host: 12443
    config.vm.network "forwarded_port", guest: 13443, host_ip: "127.0.0.1", host: 13443
    config.vm.network "forwarded_port", guest: 14080, host_ip: "127.0.0.1", host: 14080
    config.vm.network "forwarded_port", guest: 14443, host_ip: "127.0.0.1", host: 14443
    config.vm.network "forwarded_port", guest: 16080, host_ip: "127.0.0.1", host: 16080
    config.vm.network "forwarded_port", guest: 16443, host_ip: "127.0.0.1", host: 16443
    config.vm.network "forwarded_port", guest: 21443, host_ip: "127.0.0.1", host: 21443
    config.vm.network "forwarded_port", guest: 22443, host_ip: "127.0.0.1", host: 22443
end
