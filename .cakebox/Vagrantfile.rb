class Cakebox
  def Cakebox.configure(config, settings)

    # Specify base-box and hostname
    config.vm.box = "cakebox"
    config.vm.box_url = "http://alt3-aee.kxcdn.com/cakebox.box"
    config.vm.hostname = "cakebox"

    # Configure a private network IP (since DHCP is known to cause SSH timeouts)
    config.vm.network :private_network, ip: settings["ip"] ||= "10.33.10.10"

    # Enable SSH Forwarding and prevent annoying "stdin: not a tty" errors
    config.ssh.forward_agent = true
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    # Optimize box settings
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
#      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
#      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      #vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
    end

    # Enable port forwarding to the box
#    config.vm.network "forwarded_port", guest: 80, host: 8000
#    config.vm.network "forwarded_port", guest: 3306, host: 33060
#    config.vm.network "forwarded_port", guest: 5432, host: 54320

    # Configure the public key to use for SSH access
#    config.vm.provision "shell" do |s|
#      s.inline = "echo $1 | tee -a /home/vagrant/.ssh/authorized_keys"
#      s.args = [File.read(File.expand_path(settings["authorize"]))]
#    end

    # Copy all specified SSH private keys to the box
#    settings["keys"].each do |key|
#      config.vm.provision "shell" do |s|
#        s.privileged = false
#        s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
#        s.args = [File.read(File.expand_path(key)), key.split('/').last]
#      end
#    end

    # SSH copy bash aliases to the box without using a synced folder
    config.vm.provision "file", source: "aliases", destination: "/home/vagrant/.bash_aliases"

    # Mount (small) scripts folder instead of complete box root folder.
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder '.cakebox', '/cakebox'

    # Create Vagrant Synced Folders for all yaml specified "folders" and use
    # loosened permissions for Windows users so they will be able to execute
    # (e.g. Composer installed) binaries.
    unless settings["folders"].nil?
      settings["folders"].each do |folder|
        if Vagrant::Util::Platform.windows?
            config.vm.synced_folder folder["map"], folder["to"], :mount_options => ["dmode=777","fmode=766"], create: true, type: folder["type"] ||= nil
        else
          config.vm.synced_folder folder["map"], folder["to"], create: true, type: folder["type"] ||= nil
        end
      end
    end

    # Install the cakebox-command repository so we can use it to provision
    #config.vm.provision "shell" do |s|
    #    s.inline = "bash /cakebox/command-installer.sh"
    #end


    # Run `cakebox config` for all defined "subcommands"
    unless settings["config"].nil?
        settings["config"].each do |subcommand,options|
            arguments = ''
            options.each do |key, value|
                arguments.concat(" --#{key} #{value}")
            end
            config.vm.provision "shell" do |s|
                s.inline = "bash /cakebox/command/bin/cake config #{subcommand} $@"
                s.args = arguments
            end
        end
    end

    # Create Nginx site configuration files for all yaml specified "sites"
    unless settings["sites"].nil?
      settings["sites"].each do |site|
        config.vm.provision "shell" do |s|
          s.inline = "bash /cakebox/command/bin/cake site add $@"
          s.args = [ site["url"], site["webroot"] ]
          s.args.push(site["options"]) if !site["options"].nil?
        end
      end
    end

    # Create MySQL databases for all yaml specified "databases"
    unless settings["databases"].nil?
      settings["databases"].each do |database|
        config.vm.provision "shell" do |s|
          s.inline = "bash /cakebox/command/bin/cake database add $@"
          s.args = [ database["name"] ]
          s.args.push(database["options"]) if !database["options"].nil?
        end
      end
    end

    # Create Cake apps for all yaml specified "apps"
    unless settings["applications"].nil?
      settings["applications"].each do |app|
        config.vm.provision "shell" do |s|
          s.inline = "bash /cakebox/command/bin/cake application add $@"
          s.args = [ app["url"] ]
          s.args.push(app["options"]) if !app["options"].nil?
        end
      end
    end

    # Create all the (PHP-FPM?) server variables
##    unless settings["variables"].nil?
##      settings["variables"].each do |var|
##          config.vm.provision "shell" do |s|
##            s.inline = "echo \"\nenv[$1] = '$2'\" >> /etc/php5/fpm/php-fpm.conf && service php5-fpm restart"
##            s.args = [var["key"], var["value"]]
##          end
##        end
##    end

    # Install additional software
#    unless settings["packages"].nil?
#      settings["packages"].each do |package|
#        config.vm.provision "shell" do |s|
#          s.inline = "bash /cakebox/cakebox-package.sh $@"
#          s.args = [ package["name"] ]
#        end
#      end
#    end

  end
end
