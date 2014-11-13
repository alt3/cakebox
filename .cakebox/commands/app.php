<?php
use Ulrichsg\Getopt\Getopt;
use Ulrichsg\Getopt\Option;
use Ulrichsg\Getopt\Argument;
/**
* Main app installer script
*/

    # Define command line argumensts
    $getopt = new Getopt(array(
        (new Option('i', 'installer', Getopt::OPTIONAL_ARGUMENT))
            ->setDescription('installer script used to generate the application (defaults to cakephp, supports friendsofcake)')
            ->setDefaultValue('cakephp')
            ->setValidation("isValidInstaller"),
        (new Option('v', 'version', Getopt::OPTIONAL_ARGUMENT))
            ->setDescription('CakePHP major version (defaults to 3, supports 2)')
            ->setDefaultValue('3')
            ->setValidation("isValidCakeVersion"),
        (new Option('h', 'help', Getopt::NO_ARGUMENT))
            ->setDescription('display this help and exit')
        ));

    # Define custom banner for auto-generated --help message
    $getopt->setBanner(
        "Installs a fully working CakePHP application in ~/Apps using Nginx and MySQL.\n" .
        "Usage: cakebox app create [<options>] <url>\n"
    );

    # Parse and validate options and operands
    try {
        $getopt->parse();
        if (!count($getopt->getOperands())) {
            throw new UnexpectedValueException ("Missing required command line argument <url>");
        }
        if ($getopt->getOperand(0) == 'default'){
            throw new UnexpectedValueException ("Cannot use 'default' as <url> as this would overwrite the default Cakebox site");
        }
    } catch (UnexpectedValueException $e) {
        echo $getopt->getHelpText();
        echo "\nError: ".$e->getMessage()."\n";
        exit(1);
    }

    # Convenience constants shared between all installers
    define ("URL", $getopt->getOperand(0));
    define ("APPS_DIR", '/home/vagrant/Apps');
    define ("APP_DIR", APPS_DIR . "/" . URL);
    define ("SALT", "Replace-Insecure-Cakebox-Salt-And-Cipher");
    define ("CIPHER", "11111111111111111111111112345");
    define ("DATABASE", str_replace('.', '_', URL));
    define ("DATABASE_USER", "user");
    define ("DATABASE_PASSWORD", "password");
    define ("TEST_DATABASE_USER", "user");
    define ("TEST_DATABASE_PASSWORD", "password");

    # Run generic actions required by all apps
    # e.g. nginx sit

    # Run app specific installer
    $installer = $getopt->getOption('i');
    switch ($installer) {
        case "cakephp":
            if ($getopt->getOption('v') == 3) {
                echo "include cakephp3\n";
                return;
            }
            include "app-installers/cakephp2.php";
            break;
        case "friendsofcake":
            if ($getopt->getOption('v') == 3) {
                echo "include friendsofcake3\n";
                return;
            }
            echo "include friendsofcake2\n";
            break;
        case "laravel":
            echo "include laravel\n";
            break;
        default:
            echo $getopt->getHelpText();
            echo "\nError: encountered undefined installer '$installer\n'";
            exit(1);
    }

    #include "app-installers" . $getopt->getOption('i') . "/" ".php";

    # Sanity checking installer script inclusion
#    include "app-installers/cakephp2.php";
    echo "after\n";

    # @todo Round up



    /**
    * Callback function used to validate command line argument -t, --template
    *
    * @param string $value containing value passed as argument
    * @return boolean true when the argument passes validation
    */
    function isValidInstaller($value) {
        if ($value == 'cakephp' || $value == 'friendsofcake' || $value == 'laravel' ){
            return true;
        }
        return false;
    }

    /**
    * Callback function used to validate command line argument -v, --version
    *
    * @param string $value containing value passed as argument
    * @return boolean true when the argument passes validation
    */
    function isValidCakeVersion($version) {
        if ($version == '2' || $version == '3'){
            return true;
        }
            return false;
    }
