#!/usr/bin/env bash

# --------------------------------------------------------------------
# Perform an in-box upgrade of Ubuntu 14.04 to 16.04 whilst also
# upgrading all installed software to current versions.
# --------------------------------------------------------------------

## Exit immediately if already upgrade to 16.04
if lsb_release -r | grep -q '16.04'; then
  echo "Your cakebox has already been upgraded to 16.04... exiting."
  exit 0
fi

## Give user one more chance to break off the upgrade
printf %71s |tr " " "-"
printf '\n'
echo "This script will upgrade your cakebox from Ubuntu 14.04 to 16.04"
echo "and will upgrade all installed software to current versions."
echo ""
echo 'Before upgrading make ABSOLUTELY sure to create a vagrant snapshot'
echo 'of your current box by running `vagrant snapshot push` on your local'
echo 'machine. This way, if things go wrong you can restore the current'
echo 'state by running `vagrant snapshot pop`.'
echo ""
echo "The upgrade process will take time, get some tea."
printf %71s |tr " " "-"
printf '\n'

echo -n "Did you create the vagrant snapshot (y/n)?"
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo ""
else
    echo "Upgrade aborted."
    exit 0
fi

## Ask user for the preferred PHP version
echo "Which PHP version do you want to install:"
options=("PHP 7.1" "PHP 7.2")

select opt in "${options[@]}"
do
    case $opt in
        "PHP 7.1")
            PHP_VERSION=7.1
            break
            ;;
        "PHP 7.2")
            PHP_VERSION=7.2
            break
            ;;
        *) echo invalid option;;
    esac
done
echo "=> installing PHP ${PHP_VERSION}"

## Final chance to abort
echo -n "Do you want to start your box-upgrade now (y/n)?"
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo ""
else
    echo "Upgrade aborted."
    exit 0
fi

## Install package containing add-apt-repository command
sudo apt-get install software-properties-common --assume-yes

## Replace depracted PHP 5.5 source with ppa PHP 7.x source
sudo rm /etc/apt/sources.list.d/php5-5.6.list
sudo add-apt-repository ppa:ondrej/php --yes

## Remove deprecated ppa source for Percona
sudo rm /etc/apt/sources.list.d/percona.list

## Refresh the local repository list (should no longer give any errors)
sudo apt-get update --assume-yes

## Install new kernel sources to prevent do-release-upgrade breaking
sudo apt-get install linux-headers-4.4.0-66-generic --assume-yes
sudo apt-get install linux-image-4.4.0-66-generic --assume-yes
sudo apt-get install linux-image-extra-4.4.0-66-generic --assume-yes

## Remove this directory as it will prevent do-release-upgrade building the new kernel image
sudo rm /etc/udev/rules.d/70-persistent-net.rules/ -rf

## Run dist-upgrade to upgrade installed packages and build new kernel
## image as preparation for major version upgrade (--confold to prefer
## keeping existing confs to not break e.g. IP configuration)
sudo DEBIAN_FRONTEND='noninteractive' apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' dist-upgrade

## ============================================
## FYI software has already been upgraded here:
##
## lsb_release -a    => 16.04.2 LTS
## php -v        => php 7.x.x
## hhvm --version    => hhvm 3.18.1
## nginx -v        => nginx 1.11.9
## ============================================

## Remove no longer required packages and clean up apt
sudo apt-get autoremove --assume-yes
sudo apt-get clean --assume-yes
sudo apt-get autoclean --assume-yes

## Make sure required user-input on missing conf files doesn't break unattended of:
## - do-release-upgrade
## - motd
## - java
echo 'DPkg::options { "--force-confdef"; "--force-confmiss"; }' | sudo tee /etc/apt/apt.conf.d/local

## Upgrade to 16.04 LTS (not using DistUpgradeViewNonInteractive because of lacking console feedback)
sudo sh -c 'echo "y\ny\ny\ny\n" | DEBIAN_FRONTEND=noninteractive /usr/bin/do-release-upgrade'

## Cakebox specific cleanup:
sudo rm /etc/nginx/sites-available/default.dpkg-dist
sudo rm /etc/update-motd.d/10-help-text
sudo rm /etc/apt/apt.conf.d/50unattended-upgrades.ucf-dist

## Remove php5-fpm
sudo apt-get remove php5-fpm --assume-yes

## =========================================================
## Install php7.x-fpm and re-install now missing 7.x modules
## =========================================================
sudo add-apt-repository ppa:ondrej/php --yes
sudo apt-get update
sudo apt-get autoremove --assume-yes
sudo apt-get clean --assume-yes
sudo apt-get autoclean --assume-yes

sudo apt-get install php${PHP_VERSION}-fpm --assume-yes

sudo apt-get install php${PHP_VERSION}-apc --assume-yes
sudo apt-get install php${PHP_VERSION}-bcmath --assume-yes
sudo apt-get install php${PHP_VERSION}-bz2 --assume-yes
sudo apt-get install php${PHP_VERSION}-curl --assume-yes
sudo apt-get install php${PHP_VERSION}-dba --assume-yes
sudo apt-get install php${PHP_VERSION}-dom --assume-yes
sudo apt-get install php${PHP_VERSION}-gd --assume-yes
sudo apt-get install php${PHP_VERSION}-gearman --assume-yes
sudo apt-get install php${PHP_VERSION}-geoip --assume-yes
sudo apt-get install php${PHP_VERSION}-gmp --assume-yes
sudo apt-get install php${PHP_VERSION}-imagick --assume-yes
sudo apt-get install php${PHP_VERSION}-imap --assume-yes
sudo apt-get install php${PHP_VERSION}-intl --assume-yes
sudo apt-get install php${PHP_VERSION}-json --assume-yes
sudo apt-get install php${PHP_VERSION}-mbstring --assume-yes
sudo apt-get install php${PHP_VERSION}-mcrypt --assume-yes
sudo apt-get install php${PHP_VERSION}-memcache --assume-yes
sudo apt-get install php${PHP_VERSION}-memcached --assume-yes
sudo apt-get install php${PHP_VERSION}-mysql --assume-yes
sudo apt-get install php${PHP_VERSION}-mysqli --assume-yes
sudo apt-get install php${PHP_VERSION}-readline --assume-yes
sudo apt-get install php${PHP_VERSION}-redis --assume-yes
sudo apt-get install php${PHP_VERSION}-soap --assume-yes
sudo apt-get install php${PHP_VERSION}-sqlite3 --assume-yes
sudo apt-get install php${PHP_VERSION}-xdebug --assume-yes
sudo apt-get install php${PHP_VERSION}-xmlwriter --assume-yes
sudo apt-get install php${PHP_VERSION}-zip --assume-yes

## Replace php5-fpm in all existing nginx vhosts and cakebox vhost-command templates
sudo find /etc/nginx/sites-available/ -type f -exec sed -i 's/php5-fpm/php\/php${PHP_VERSION}-fpm/g' {} +
sudo find /cakebox/console/src/Template/bake/ -type f -exec sed -i 's/php5-fpm/php\/php${PHP_VERSION}-fpm/g' {} +

## Install nodejs 7 using launchpad ppa
cd /tmp
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install -y nodejs

## Install java 1.8 using launchpad ppa
sudo add-apt-repository ppa:webupd8team/java --yes
sudo apt-get update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install oracle-java8-installer --assume-yes

## Remove deprecated upstart scripts (since 16.04 uses systemd)
sudo unlink /etc/init.d/kibana
sudo unlink /etc/init.d/logstash_server
sudo unlink /etc/init.d/mongod

## Update mongodb using mongo apt repository
sudo apt-get remove mongodb-org --assume-yes
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update
sudo apt-get install mongodb-org --assume-yes

## Remove temporary workaround to prevent required user-input blocking
sudo rm /etc/apt/apt.conf.d/local

## All done, a reboot is required to take the new 4.4.0-66 kernel into
## effect and complete the the upgrade process (also guarantees  that
## any rogue "previous" processes are killed).
printf %71s |tr " " "-"
printf '\n'
printf 'All done, you MUST now restart your vm by running `vagrant reload`';
printf "on your local machine to complete the upgrade process.\n"
printf "\n"
printf "See /var/log/apt/term.log for detailed upgrade information."
printf "\n"
printf "Happy baking!\n"
printf %71s |tr " " "-"
printf '\n'
