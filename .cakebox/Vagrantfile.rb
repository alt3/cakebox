class Cakebox
  def Cakebox.configure(config, user_settings)
    require 'json'

    # Define absolutely required box settings
    settings =  Hash.new
    settings["vm"] =  Hash.new
    settings["vm"]["ip"] = "10.33.10.10"
    settings["vm"]["memory"] = 2048
    settings["vm"]["cpus"] = 1

    # Prevent merging empty vm user settings
    user_settings["vm"] = Hash.new if user_settings["vm"].nil?
    user_settings["vm"]["ip"] = settings["vm"]["ip"] if user_settings["vm"]["ip"].nil?
    user_settings["vm"]["memory"] = settings["vm"]["memory"] if user_settings["vm"]["memory"].nil?
    user_settings["vm"]["cpus"] = settings["vm"]["cpus"] if user_settings["vm"]["cpus"].nil?

    # Deep merge user settings found in Cakebox.yaml
    settings.deep_merge!(user_settings)

    # Specify base-box and hostname
    config.vm.box = "cakebox"
    config.vm.box_url = "http://alt3-aee.kxcdn.com/cakebox.box"
    config.vm.hostname = "cakebox"

    # Configure a private network IP (since DHCP is known to cause SSH timeouts)
    config.vm.network :private_network, ip: settings["vm"]["ip"]

    # Enable SSH Forwarding and prevent annoying "stdin: not a tty" errors
    config.ssh.forward_agent = true
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # Optimize box settings
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", settings["vm"]["memory"]]
      vb.customize ["modifyvm", :id, "--cpus", settings["vm"]["cpus"]]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      #vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    end

    # SSH copy bash aliases to the box without using a synced folder
    config.vm.provision "file", source: "aliases", destination: "/home/vagrant/.bash_aliases"

    # Mount (small and thus fast) scripts folder instead of complete box root folder.
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder '.cakebox', '/cakebox'

    # Create Vagrant Synced Folders for all yaml specified "folders" and use
    # loosened permissions for Windows users so they will be able to execute
    # (e.g. Composer installed) binaries.
    unless settings["synced_folders"].nil?
      settings["synced_folders"].each do |folder|
        if Vagrant::Util::Platform.windows?
            config.vm.synced_folder folder["map"], folder["to"], :mount_options => ["dmode=777","fmode=766"], create: true, type: folder["type"] ||= nil
        else
          config.vm.synced_folder folder["map"], folder["to"], create: true, type: folder["type"] ||= nil
        end
      end
    end

    # Install the cakebox-console so we can use it to provision all collections
    # specified in Cakebox.yaml.
    #config.vm.provision "shell" do |s|
    #    s.inline = "bash /cakebox/console-installer.sh"
    #end

    # Run `cakebox config $subcommand --options` for all yaml specified "personal"
    unless settings["personal"].nil?
        settings["personal"].each do |subcommand,options|
            arguments = ''
            options.each do |key, value|
                arguments.concat(" --#{key} #{value}")
            end
            config.vm.provision "shell" do |s|
                s.inline = "bash /cakebox/console/bin/cake config #{subcommand} $@"
                s.args = arguments
            end
        end
    end

    # Create Nginx site configuration files for all yaml specified "sites"
    unless settings["sites"].nil?
      settings["sites"].each do |site|
        config.vm.provision "shell" do |s|
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
          s.inline = "bash /cakebox/console/bin/cake database add $@"
          s.args = [ database["name"] ]
          s.args.push(database["options"]) if !database["options"].nil?
        end
      end
    end

    # Install fully working apps for all yaml specified "applications"
    unless settings["applications"].nil?
      settings["applications"].each do |app|
        config.vm.provision "shell" do |s|
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
            s.inline = "bash /cakebox/console/bin/cake package add $@"
          s.args = [ package["package"] ]
        end
      end
    end

  end
end
