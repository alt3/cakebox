# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

path = "#{File.dirname(__FILE__)}"
require path + '/.cakebox/Vagrantfile.rb'
require 'yaml'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  raise Vagrant::Errors::VagrantError.new, 'Fatal: your Cakebox.yaml is missing' unless File.exist?(path + '/Cakebox.yaml')
  Cakebox.configure(config, YAML::load(File.read(path + '/Cakebox.yaml')))
end
