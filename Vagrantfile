# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

rootFolder = "#{File.dirname(__FILE__)}"
require rootFolder + File::SEPARATOR + '.cakebox' + File::SEPARATOR + 'Vagrantfile.rb'
require 'yaml'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  raise Vagrant::Errors::VagrantError.new, 'Fatal: your Cakebox.yaml is missing' unless File.exist?(rootFolder + File::SEPARATOR + 'Cakebox.yaml')
  Cakebox.configure(config, YAML::load(File.read(rootFolder + File::SEPARATOR + 'Cakebox.yaml')))
end
