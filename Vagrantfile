# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

path = "#{File.dirname(__FILE__)}"
require path + '/.cakebox/Vagrantfile.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Cakebox.configure(config, YAML::load(File.read(path + '/Cakebox.yaml')))
end





#Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|


  # Set up Berkshelf
#  config.berkshelf.enabled = true
#  config.berkshelf.berksfile_path = './Berksfile'

  # Enable SSH agent forwarding
#  config.ssh.forward_agent = true

  # Load default vm/Chef settings from node.json
#  raise Vagrant::Errors::VagrantError.new, 'Error: configuration file node.json not found' unless File.exist?('node.json')
#  settings = JSON.parse(File.read('node.json'))

  # Load user-settings (if present)
#  settings.deep_merge!(YAML::load_file('Vagrantfile.yml')) if File.exist?('Vagrantfile.yml')

  # Default box configuration
#  config.vm.box = 'opscode-ubuntu-14.04'
#  config.vm.box_url = 'https://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-14.04_chef-provisionerless.box'

#  config.vm.hostname = settings['vm']['hostname']
#  config.vm.network :private_network, ip: settings['vm']['ip_address']

  # Asign more memory
#	config.vm.provider "virtualbox" do |vb|
#	  vb.customize ["modifyvm", :id, "--memory", "2048"]
#	end

  # Do not mount /vagrant. Mount local blogs directory to /blogs instead
#  config.vm.synced_folder '.', '/vagrant', disabled: true
#  config.vm.synced_folder 'apps', '/apps', create: true, owner: 'vagrant', group: 'vagrant'

  # Provision vm using Berkshelf
#  config.vm.provision :chef_solo do |chef|
#    chef.custom_config_path = '.chefconfig'
#    chef.run_list = settings['run_list']
#    chef.json = settings['attributes']
#  end

  # Make the vm work using VMWare Workstation too
#  config.vm.provider :vmware_desktop do |v, override|
#    override.vm.box = 'puppetlabs/vmware_desktop'
#    override.vm.box_url = 'https://vagrantcloud.com/puppetlabs/boxes/ubuntu-14.04-64-nocm/versions/3/providers/vmware_desktop.box'
#  end

  # Make vm work using VMWare Fusion too
#  config.vm.provider :vmware_fusion do |v, override|
#    override.vm.box = 'puppetlabs/vmware_fusion'
#    override.vm.box_url = 'https://vagrantcloud.com/puppetlabs/boxes/ubuntu-14.04-64-nocm/versions/3/providers/vmware_fusion.box'
#  end

#end
