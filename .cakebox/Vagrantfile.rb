class Cakebox
  def Cakebox.configure(config, user_settings)
    require 'vagrant/util/deep_merge'
    require 'json'
    require 'tempfile'

    # Define absolutely required box settings
    settings =  Hash.new
    settings["vm"] =  Hash.new
    settings["vm"]["hostname"] = "cakebox"
    settings["vm"]["ip"] = "10.33.10.10"
    settings["vm"]["memory"] = 1024
    settings["vm"]["cpus"] = 1
    settings["cakebox"] =  Hash.new
    settings["cakebox"]["version"] = "dev-master"

    if user_settings == false
        user_settings = Hash.new
    end

    # Deep merge user settings found in Cakebox.yaml. Uses the Vagrant Util
    # class to prevent a Vagrant plugin dependency + our custom 'compact' Hash
    # cleaner class to prevent non-DRY checking per setting.
    settings = Vagrant::Util::DeepMerge.deep_merge(settings, user_settings.compact!)

    # Determine Cakebox Dashboard protocol only once
    if settings['cakebox']['https'] == true
      settings['cakebox']['protocol'] = 'https'
    else
      settings['cakebox']['protocol'] = 'http'
    end

    # Specify Vagrant post-up message
    config.vm.post_up_message = "Your box is ready and waiting at " + settings['cakebox']['protocol'] + '://' + settings["vm"]["ip"]

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

    # SSH copy bash aliases file to the box
    config.vm.provision "file", source: ".cakebox/aliases", destination: "/home/vagrant/.bash_aliases"

    # SSH copy local Cakebox.yaml to /home/vagrant/.cakebox when --provision is
    # being used so it can be used for virtual machine information.
    config.vm.provision "file", source: "Cakebox.yaml", destination: "/home/vagrant/.cakebox/last-known-cakebox-yaml"

    # SSH copy most recent local Git commit for alt3/cakebox to /home/vagrant/.cakebox
    composerVersionParts = settings['cakebox']['version'].split('-')
    if composerVersionParts[1].nil?
      raise Vagrant::Errors::VagrantError.new, 'Fatal: unable to extract local git branch from composer version "'  + settings['cakebox']['version'] + '"'
    end
    config.vm.provision "file", source: ".git/refs/heads/dev", destination: "/home/vagrant/.cakebox/last-known-cakebox-commit"

    # Write vagrant box version to file before ssh copying to /home/vagrant/.cakebox
    tempfile = Tempfile.new('last-known-box-version')
    boxes = `vagrant box list`
    boxes.match(/cakebox\s+\(virtualbox,\s(.+)\)/)
    tempfile.write($1)
    config.vm.provision "file", source: tempfile, destination: "/home/vagrant/.cakebox/last-known-box-version"
    tempfile.close

    # Mount small (and thus fast) scripts folder instead of complete box root folder
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder '.cakebox', '/cakebox', :mount_options => ["dmode=777","fmode=766"], create: true

    # Temporarily mount .vagrant directory so we can replace the Vagrant 1.7.x
    # secure private key until these issues are resolved:
    # https://github.com/mitchellh/vagrant/issues/5090
    # https://github.com/mitchellh/vagrant/issues/4967
    config.vm.synced_folder '.vagrant', '/vagrant', :mount_options => ["dmode=777","fmode=766"], create: true

    # Create Vagrant Synced Folders for all yaml specified "folders".
    unless settings["synced_folders"].nil?
      settings["synced_folders"].each do |folder|

        # Convert user defined ~ paths in yaml to Dir.home for user's convenience
        if ( folder["local"] =~ /^~/ )
            folder["local"] = folder["local"].sub(/^~/, Dir.home)
        end

        # On Windows mounts are always created with loosened permissions so the
        # vagrant user will be able to execute files (like composer installed
        # binaries) inside the shared folders.
        if Vagrant::Util::Platform.windows?
            config.vm.synced_folder folder["local"], folder["remote"], :mount_options => ["dmode=777","fmode=766"], create: true
        end

        # On Linux/Mac mounts are by created with the same loose permissions as
        # as used on Windows UNLESS the user specifies his own (Vagrant supported)
        # mount options in Cakebox.yaml.
        unless Vagrant::Util::Platform.windows?
          if folder["mount_options"].nil?
            config.vm.synced_folder folder["local"], folder["remote"], :mount_options => ["dmode=777","fmode=766"], create: true
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
        if ( public_key =~ /^~/ )
          public_key = public_key.sub(/^~/, Dir.home)
        end
        unless File.exists?(public_key)
          raise Vagrant::Errors::VagrantError.new, "Fatal: your public ssh key does not exist (#{settings["security"]["box_public_key"]})"
        end

        # A public key MUST be an accompanied by a private key
        if settings["security"]["box_private_key"].nil?
          raise Vagrant::Errors::VagrantError.new, "Fatal: using a public ssh key also requires specifying a local private ssh key in your Cakebox.yaml"
        end
        private_key = settings["security"]["box_private_key"]
        if ( private_key =~ /^~/ )
            private_key = private_key.sub(/^~/, Dir.home)
        end
        unless File.exists?(private_key)
          raise Vagrant::Errors::VagrantError.new, "Fatal: your private ssh key does not exist (#{settings["security"]["box_private_key"]})"
        end

        # Copy user's public key to the vm so it can be validated and applied
        config.vm.provision "file", source: public_key, destination: "/home/vagrant/.ssh/" + File.basename(public_key)

        # Add user's private key to all Vagrant-usable local private keys so all
        # required login scenarios will keep functioning as expected:
        # - initial non-secure vagrant up
        # - users protecting their box with a personally generated public key
        config.ssh.private_key_path = [
          private_key,
          Dir.home + '/.vagrant.d/insecure_private_key'
        ]

        # Run bash script to replace insecure public key in authorized_keys
        config.vm.provision "shell" do |s|
          s.inline = "bash /cakebox/bash/ssh-authentication.sh $@"
          s.args = [ File.basename(public_key), File.basename(private_key) ]
        end

        # Prevent Vagrant 1.7.x from generating a new private key and inserting
        # corresponding public key (overwriting our just set custom key).
        config.ssh.insert_key = false
      end
    end

    # Always display SSH Agent Forwarding sanity checks
    config.vm.provision "shell" do |s|
      s.privileged = false
      s.inline = "bash /cakebox/bash/check-ssh-agent.sh"
    end

    # Install the cakebox-console so it can be used for yaml-provisioning
    config.vm.provision "shell" do |s|
      s.privileged = false
      s.inline = "bash /cakebox/bash/console-installer.sh $@"
      s.args = settings["cakebox"]["version"]
    end

    # Set Cakebox Dashboard protocol to HTTP or HTTPS
    config.vm.provision "shell" do |s|
      s.privileged = false
      s.inline = "bash /cakebox/console/bin/cake config dashboard --force --protocol $@"
      s.args = settings["cakebox"]["protocol"]
    end

    # Turn CakePHP debug mode on/off for Cakebox Commands and Dashboard
    config.vm.provision "shell" do |s|
      s.privileged = false
      s.inline = "bash /cakebox/console/bin/cake config debug $@"
      if settings["cakebox"]["debug"] == false
        s.args = 'off'
      else
        s.args = 'on'
      end
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

    # Install fully working framework applications for all yaml specified "apps".
    # The --repair parameter is appended so only missing components will be
    # installed when the sources already exist (e.g. when recreating a new box
    # with existing sources in a mapped Synced Folder)
    unless settings["apps"].nil?
      settings["apps"].each do |app|
        config.vm.provision "shell" do |s|
          s.privileged = false
          s.inline = "bash /cakebox/console/bin/cake application add $@"
          s.args = [ app["url"] ]
          s.args.push(app["options"]) if !app["options"].nil?
          s.args.push('--repair')
        end
      end
    end

    # Install additional packages from the Ubuntu Package Archive
    unless settings["apt_packages"].nil?
      settings["apt_packages"].each do |package|
        config.vm.provision "shell" do |s|
          s.privileged = false
          s.inline = "bash /cakebox/console/bin/cake package add $@"
          s.args = [package]
        end
      end
    end

    # Upload and run user created customization bash script (if found) to allow
    # the user to create fully re-provisionable box customizations
    unless settings['user_script'].nil?
      if ( settings['user_script'] =~ /^~/ )
        settings['user_script'] = settings['user_script'].sub(/^~/, Dir.home)
      end

      if File.exists?(settings['user_script'])
        config.vm.provision "file", source: settings['user_script'], destination: "/home/vagrant/.cakebox/last-known-user-script.sh"
        config.vm.provision "shell" do |s|
          s.privileged = false
          s.inline = "bash /home/vagrant/.cakebox/last-known-user-script.sh"
        end
      end
    end

  end
end

# Hash cleaner, removes nil/empty values recursively from a hash.
#
# Very handy to avoid errors when user yaml file does not include all required parts
# After removing nil values, it can safely be deep merged into default settings,
# without the need to check for all keys being present or having a value
class Hash
  def compact!
    self.delete_if do |key, val|
      if block_given?
        yield(key,val)
      else
        test1 = val.nil?
        test2 = val.empty? if val.respond_to?('empty?')
        test3 = val.strip.empty? if val.is_a?(String) && val.respond_to?('empty?')

        test1 || test2 || test3
      end
    end

    self.each do |key, val|
      if self[key].is_a?(Hash) && self[key].respond_to?('compact!')
        if block_given?
          self[key] = self[key].compact!(&Proc.new)
        else
          self[key] = self[key].compact!
        end
      end
    end

    return self
  end
end
