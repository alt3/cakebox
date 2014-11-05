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

    # Copy bash aliasaes to the box
    config.vm.provision "shell" do |s|
      s.inline = "cp /cakebox/aliases /home/vagrant/.bash_aliases"
    end

    # Mount (small) scripts folder instead of complete box root folder.
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder '.scripts', '/cakebox'

    # Create Vagrant Synced Folders for all yaml specified "folders" and use loosened permissions
    # for Windows users so they will be able to execute (e.g. Composer installed) binaries.
    settings["folders"].each do |folder|
      if Vagrant::Util::Platform.windows?
          config.vm.synced_folder folder["map"], folder["to"], :mount_options => ["dmode=777","fmode=766"], create: true, type: folder["type"] ||= nil
      else
        config.vm.synced_folder folder["map"], folder["to"], create: true, type: folder["type"] ||= nil
      end
    end

    # Create Nginx site configuration files for all yaml specified "sites"
    settings["sites"].each do |site|
      config.vm.provision "shell" do |s|
            s.inline = "bash /cakebox/serve-site.sh $1 $2"
            s.args = [site["map"], site["to"]]
      end
    end

    # Create MySQL databases for all yaml specified "databases"
    settings["databases"].each do |database|
      config.vm.provision "shell" do |s|
            s.inline = "bash /cakebox/serve-database.sh $1"
            s.args = [database["name"]]
      end
    end

    # Create Cake apps for all yaml specified "apps"
    settings["apps"].each do |app|
      config.vm.provision "shell" do |s|
            s.inline = "bash /cakebox/serve-app.sh $1"
            s.args = [app["name"]]
      end
    end

    # Configure All Of The Server Environment Variables
#    if settings.has_key?("variables")
#      settings["variables"].each do |var|
#        config.vm.provision "shell" do |s|
#            s.inline = "echo \"\nenv[$1] = '$2'\" >> /etc/php5/fpm/php-fpm.conf && service php5-fpm restart"
#            s.args = [var["key"], var["value"]]
#        end
#      end
#    end

    # Install additional software
    settings["packages"].each do |package|
      config.vm.provision "shell" do |s|
            s.inline = "bash /cakebox/serve-package.sh $1"
            s.args = [package["name"]]
      end
    end

  end
end
