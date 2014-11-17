# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

path = "#{File.dirname(__FILE__)}"
require path + '/.cakebox/Vagrantfile.rb'

require 'yaml'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Cakebox.configure(config, YAML::load(File.read(path + '/Cakebox.yaml')))
end
