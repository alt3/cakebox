class Cakebox
  def Cakebox.configure(config, user_settings)
    require 'vagrant/util/deep_merge'
    require 'json'

    # Define absolutely required box settings
    settings =  Hash.new
    settings["vm"] =  Hash.new
    settings["vm"]["hostname"] = "cakebox"
    settings["vm"]["ip"] = "10.33.10.10"
    settings["vm"]["memory"] = 2048
    settings["vm"]["cpus"] = 1

    # Prevent merging empty vm user settings
    user_settings["vm"] = Hash.new if user_settings["vm"].nil?
    user_settings["vm"]["hostname"] = settings["vm"]["hostname"] if user_settings["vm"]["hostname"].nil?
    user_settings["vm"]["ip"] = settings["vm"]["ip"] if user_settings["vm"]["ip"].nil?
    user_settings["vm"]["memory"] = settings["vm"]["memory"] if user_settings["vm"]["memory"].nil?
    user_settings["vm"]["cpus"] = settings["vm"]["cpus"] if user_settings["vm"]["cpus"].nil?

    # Deep merge user settings found in Cakebox.yaml without plugin dependency
    settings = Vagrant::Util::DeepMerge.deep_merge(settings, user_settings)

    # Specify CDN base-box and hostname for the vm
    config.vm.box = "cakebox"
    config.vm.box_url = "https://alt3-aee.kxcdn.com/cakebox.box"
    config.vm.hostname = settings["vm"]["hostname"]

    # Configure a private network IP (since DHCP is known to cause SSH timeouts)
    config.vm.network :private_network, ip: settings["vm"]["ip"]

    # Optimize box settings
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", settings["vm"]["memory"]]
      vb.customize ["modifyvm", :id, "--cpus", settings["vm"]["cpus"]]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      #vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    end

    # Mount small (and thus fast) scripts folder instead of complete box root folder.
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder '.cakebox', '/cakebox'

    # Create Vagrant Synced Folders for all yaml specified "folders".
    unless settings["synced_folders"].nil?
      settings["synced_folders"].each do |folder|

        # On Windows mounts are created with loosened permissions so the vagrant
        # user will be able to execute files (like composer installed binaries)
        # inside shared folder.
        if Vagrant::Util::Platform.windows?
            config.vm.synced_folder folder["local"], folder["remote"], :mount_options => ["dmode=777","fmode=766"], create: true
        end

        # On Linux/Mac mounts are created using the vagrant default settings
        # UNLESS the user has specified supported mount options in Cakebox.yaml.
        unless Vagrant::Util::Platform.windows?
          if folder["mount_options"].nil?
            config.vm.synced_folder folder["local"], folder["remote"], create: true
          else
            config.vm.synced_folder folder["local"], folder["remote"], create: true, :mount_options => [folder["mount_options"]]
          end
        end

      end
    end

    # Enable SSH Forwarding and prevent annoying "stdin: not a tty" errors
    config.ssh.forward_agent = true
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
    config.ssh.username = "vagrant"

    # Replace insecure Vagrant ssh public key with user generated public key
    unless settings["security"].nil?
      unless settings["security"]["box_public_key"].nil?
        public_key = settings["security"]["box_public_key"]
        unless File.exists?(public_key)
          raise Vagrant::Errors::VagrantError.new, "Fatal: your public ssh key does not exist (#{settings["security"]["box_public_key"]})"
        end

        # A public key MUST be an accompanied by a private key
        if settings["security"]["box_private_key"].nil?
          raise Vagrant::Errors::VagrantError.new, "Fatal: using a public ssh key also requires specifying a local private ssh key in your Cakebox.yaml"
        end
        unless File.exists?(settings["security"]["box_private_key"])
          raise Vagrant::Errors::VagrantError.new, "Fatal: your private ssh key does not exist (#{settings["security"]["box_private_key"]})"
        end

        # Copy user's public key to the vm so it can be validated and applied
        config.vm.provision "file", source: settings["security"]["box_public_key"], destination: "/home/vagrant/.ssh/" + File.basename(settings["security"]["box_public_key"])

        # Add user's private key to all Vagrant-usable local private keys so all
        # required login scenarios will keep functioning as expected:
        # - initial non-secure vagrant up
        # - users protecting their box with a personally generated public key
        config.ssh.private_key_path = [
          '~/.vagrant.d/insecure_private_key',
          settings["security"]["box_private_key"]
        ]

        # Run bash script to replace insecure public key in authorized_keys
        config.vm.provision "shell" do |s|
          s.inline = "bash /cakebox/bash/replace-insecure-key.sh $@"
          s.args = "/home/vagrant/.ssh/" + File.basename(settings["security"]["box_public_key"])
        end
      end
    end

    # SSH copy bash aliases file to the box
    config.vm.provision "file", source: ".cakebox/aliases", destination: "/home/vagrant/.bash_aliases"

    # Always display SSH Agent Forwarding sanity checks
    config.vm.provision "shell" do |s|
      s.privileged = false
      s.inline = "bash /cakebox/bash/check-ssh-agent.sh"
    end

    # Install the cakebox-console so it can be used for yaml-provisioning
    config.vm.provision "shell" do |s|
      s.privileged = false
      s.inline = "bash /cakebox/bash/console-installer.sh"
    end

    # Set global git username and email using `cakebox config git [options]`
    unless settings["git"].nil?
      if !settings["git"]["username"].nil? || !settings["git"]["email"].nil?

        arguments = ''
        settings["git"].each do |key, value|
          arguments.concat(" --#{key} #{value}")
        end

        config.vm.provision "shell" do |s|
          s.privileged = false
          s.inline = "bash /cakebox/console/bin/cake config git $@"
          s.args = arguments
        end

      end
    end

    # Create Nginx site configuration files for all yaml specified "sites"
    unless settings["sites"].nil?
      settings["sites"].each do |site|
        config.vm.provision "shell" do |s|
          s.privileged = false
          s.inline = "bash /cakebox/console/bin/cake site add $@"
          s.args = [ site["url"], site["webroot"] ]
          s.args.push(site["options"]) if !site["options"].nil?
        end
      end
    end

    # Create MySQL databases for all yaml specified "databases"
    unless settings["databases"].nil?
      settings["databases"].each do |database|
        config.vm.provision "shell" do |s|
          s.privileged = false
          s.inline = "bash /cakebox/console/bin/cake database add $@"
          s.args = [ database["name"] ]
          s.args.push(database["options"]) if !database["options"].nil?
        end
      end
    end

    # Install fully working framework applications for all yaml specified "apps"
    unless settings["apps"].nil?
      settings["apps"].each do |app|
        config.vm.provision "shell" do |s|
          s.privileged = false
          s.inline = "bash /cakebox/console/bin/cake application add $@"
          s.args = [ app["url"] ]
          s.args.push(app["options"]) if !app["options"].nil?
        end
      end
    end

    # Install all yaml specified "additional_software" packages
    unless settings["additional_software"].nil?
      settings["additional_software"].each do |package|
        config.vm.provision "shell" do |s|
          s.privileged = false
          s.inline = "bash /cakebox/console/bin/cake package add $@"
          s.args = [ package["package"] ]
        end
      end
    end

    # Provide user with box-info
    config.vm.provision "shell" do |s|
        s.inline = "bash /cakebox/bash/box-info.sh $@"
        s.args = [ settings["vm"]["ip"] ]
    end

  end
end
