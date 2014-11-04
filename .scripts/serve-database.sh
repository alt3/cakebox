if [ -z "$1" ]
  then
  	echo "Error: missing required parameters."
    echo "Usage: "
    echo " serve-database name"
    exit 1
fi

# CakePHP does not handle database names with dots properly
if [[ $1 == *.* ]]
  then
    echo "Error: database names can not contain dots"
    exit 1
fi

# Placeholders for optional username and password command arguments
DB_USER=user
DB_PASS=password

# Create databases
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`$1\`"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`$1_test\`"

# Set database permissions
mysql -uroot -e "GRANT ALL ON \`$1\`.* to  '$DB_USER'@'localhost' identified by '$DB_PASS'"
mysql -uroot -e "GRANT ALL ON \`$1_test\`.* to '$DB_USER'@'localhost' identified by '$DB_PASS'"
