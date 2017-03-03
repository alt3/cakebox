# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'.freeze

root_folder = File.dirname(__FILE__).to_s

vagrant_file = root_folder + File::SEPARATOR + '.cakebox' + File::SEPARATOR + 'Vagrantfile.rb'
require vagrant_file

require 'yaml'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  user_yaml = root_folder + File::SEPARATOR + 'Cakebox.yaml'

  unless File.exist?(user_yaml)
    raise Vagrant::Errors::VagrantError.new, 'Fatal: your Cakebox.yaml is missing'
  end

  Cakebox.configure(config, YAML.safe_load(File.read(user_yaml)))
end
