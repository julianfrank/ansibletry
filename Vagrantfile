# -*- mode: ruby -*- 
# vi: set ft=ruby : 
# Every Vagrant development environment requires a box. You can search for 
# boxes at https://atlas.hashicorp.com/search. 

BOX_IMAGE = "ubuntu/xenial64" 
NODE_COUNT = 6 

#This Script performs generic Updates and Upgrades the apt DB 
$genericupdateupgradescript = <<SCRIPT
echo I am Going to Update and Upgrade apt-get DB here...
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
SCRIPT

#This Script Installs Ansible
$ansibleinstallscript = <<SCRIPT
echo I am Going to Install Ansible here...
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
sudo apt-get install -y ansible && echo Ansible Installed || echo Ansible could NOT be Installed
echo Copying hosts
sudo cp /vagrant/hosts /etc/ansible/hosts
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.define "master.mylab.local" do |subconfig|     
    subconfig.vm.box = BOX_IMAGE     
    subconfig.vm.hostname = "master.mylab.local"     
    subconfig.vm.network :private_network, ip: "10.0.0.10" 
    subconfig.vm.provision "shell", inline: ""
    # Install Ansible from the Vagrant VM
    subconfig.vm.provision "shell", inline: $ansibleinstallscript
  end     
  
  (1..NODE_COUNT).each do |i|     
    config.vm.define "node#{i}.mylab.local" do |subconfig|       
      subconfig.vm.box = BOX_IMAGE       
      subconfig.vm.hostname = "node#{i}.mylab.local"       
      subconfig.vm.network :private_network, ip: "10.0.0.#{i + 10}"
      subconfig.vm.provision "shell", inline: $genericupdateupgradescript
    end   
  end   
  
  config.vm.provider "virtualbox" do |v|
    #v.name = v.hostname
    v.memory = 666
    v.cpus = 1
  end
  # Install avahi on all machines     
  #config.vm.provision "shell", inline: <<-SHELL     
    #apt-get install -y avahi-daemon libnss-mdns   
  #SHELL 
end