require 'chef_metal'

mario_config = <<-ENDCONFIG
  config.vm.box = "centos65"
  config.vm.network "forwarded_port", guest: 443, host: 9443
  config.vm.network "forwarded_port", guest: 4002, host: 4002
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 8773, host: 8773
  config.vm.network "forwarded_port", guest: 8774, host: 8774
  config.vm.network "forwarded_port", guest: 35357, host: 35357
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
    v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.vm.network "private_network", ip: "192.168.100.60"
ENDCONFIG

machine 'mario' do
  machine_options :vagrant_config => mario_config
  role 'allinone-compute'
  role 'os-image-upload'
  chef_environment 'vagrant-aio-neutron'
  file '/etc/chef/openstack_data_bag_secret','/Users/jasghar/repo/singlestack/.chef/encrypted_data_bag_secret'
  converge true
end
