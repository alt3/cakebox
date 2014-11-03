class Cakebox
  def Cakebox.configure(config, settings)
    # Configure The Box
    config.vm.box = "cakebox"
    config.vm.hostname = "cakebox"

    # Configure A Private Network IP
    config.vm.network :private_network, ip: settings["ip"] ||= "10.33.10.10"

    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
#      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
#      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
#      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    # Configure Port Forwarding To The Box
#    config.vm.network "forwarded_port", guest: 80, host: 8000
#    config.vm.network "forwarded_port", guest: 3306, host: 33060
#    config.vm.network "forwarded_port", guest: 5432, host: 54320

    # Configure The Public Key For SSH Access
#    config.vm.provision "shell" do |s|
#      s.inline = "echo $1 | tee -a /home/vagrant/.ssh/authorized_keys"
#      s.args = [File.read(File.expand_path(settings["authorize"]))]
#    end

    # Copy The SSH Private Keys To The Box
#    settings["keys"].each do |key|
#      config.vm.provision "shell" do |s|
#        s.privileged = false
#        s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
#        s.args = [File.read(File.expand_path(key)), key.split('/').last]
#      end
#    end

    # Copy The Bash Aliases
#    config.vm.provision "shell" do |s|
#      s.inline = "cp /vagrant/aliases /home/vagrant/.bash_aliases"
#    end

    # Do NOT mount Cakebox root directory , just the required scripts
    config.vm.synced_folder '.', '/vagrant', disabled: true
    config.vm.synced_folder '.scripts', '/cakebox'

    # Register defined Synced Folders and loosen permissions for Windows users
    # or Composer installed bins will not work.
    settings["folders"].each do |folder|
      if Vagrant::Util::Platform.windows?
          config.vm.synced_folder folder["map"], folder["to"], :mount_options => ["dmode=777","fmode=766"], create: true, type: folder["type"] ||= nil
      else
        config.vm.synced_folder folder["map"], folder["to"], create: true, type: folder["type"] ||= nil
      end
    end

    # Configure all defined Nginx sites
    settings["sites"].each do |site|
      config.vm.provision "shell" do |s|
            s.inline = "bash /cakebox/serve-site.sh $1 $2"
            s.args = [site["map"], site["to"]]
      end
    end

    # Create all defined databases
    settings["databases"].each do |database|
      config.vm.provision "shell" do |s|
            s.inline = "bash /cakebox/serve-database.sh $1"
            s.args = [database["name"]]
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
  end
end
