# -*- mode: ruby -*- 
# vi: set ft=ruby : 
# Every Vagrant development environment requires a box. You can search for 
# boxes at https://atlas.hashicorp.com/search. 

BOX_IMAGE = "ubuntu/xenial64" 
NODE_COUNT = 3

#This Script performs generic Updates and Upgrades the apt DB 
$genericupdateupgradescript = <<SCRIPT
echo I am Going to Update and Upgrade apt-get DB here...
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
ip addr | grep 10.0.0.
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
yes | cp /vagrant/ansible.cfg /etc/ansible/ansible.cfg
export ANSIBLE_HOST_KEY_CHECKING=False
ip addr | grep 10.0.0.
SCRIPT

#This Creates the Master SSH Keys
$createmastersshkey = <<SCRIPT
echo Creating master ssh Key
yes | ssh-keygen -f id_rsa -t rsa -N '' -C "vagrant"
#yes | cp id_rsa.pub ~/.ssh/id_rsa.pub
yes | cp id_rsa.pub /vagrant
yes | cp id_rsa ~/.ssh/id_rsa
yes | cp id_rsa /vagrant
cat id_rsa.pub >> ~/.ssh/authorized_keys
sudo chmod 0700 ~/.ssh
sudo chmod 0600 ~/.ssh/id_rsa
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
SCRIPT

#This Copies the Master SSH Pub key to the slave nodes
$copymastersshkey = <<SCRIPT
echo Copying master ssh public Key to node
yes | cp /vagrant/id_rsa ~/.ssh/id_rsa
#yes | cp /vagrant/id_rsa.pub ~/.ssh/id_rsa.pub
cat /vagrant/id_rsa.pub >> ~/.ssh/authorized_keys
sudo chmod 0700 ~/.ssh
sudo chmod 0600 ~/.ssh/id_rsa
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
SCRIPT

Vagrant.configure("2") do |config|
  
  config.vm.provider "virtualbox" do |v|
    #v.name = v.hostname
    v.memory = 666
    v.cpus = 1
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "25"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.define "master" do |subconfig|     
    subconfig.vm.box = BOX_IMAGE     
    subconfig.vm.hostname = "master"     
    subconfig.vm.network :private_network, ip: "10.0.0.10" 
    subconfig.vm.provision "shell", inline: ""
    # Install Ansible from the Vagrant VM
    subconfig.vm.provision "shell", inline: $ansibleinstallscript
    subconfig.vm.provision "shell", inline: $createmastersshkey
  end     
  
  (1..NODE_COUNT).each do |i|     
    config.vm.define "node#{i}" do |subconfig|       
      subconfig.vm.box = BOX_IMAGE       
      subconfig.vm.hostname = "node#{i}"       
      subconfig.vm.network :private_network, ip: "10.0.0.#{i + 10}"
      subconfig.vm.provision "shell", inline: $genericupdateupgradescript
      subconfig.vm.provision "shell", inline: $copymastersshkey
    end   
  end   
  
  
end