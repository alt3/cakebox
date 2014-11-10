#!/usr/bin/php -q
<?php
/**
* CakePHP agnostic cakebox command script.
*
*
* @return bool false on success, true when
*/

    # Load Composer installed Classes
    require 'vendor/autoload.php';

    # Validate cakebox subcommand
    #var_dump($argv);

    # Remove cakebox subcommand from $argv before including command script so
    # getopt-php can parse correctly

    #exit(0);


    # Sanity checking installer script inclusion
    echo "BEFORE COMMAND INCLUSION\n";
    $webroot = "myroot2";
    include "commands/app.php";
    echo "after2\n";



    # @todo Execute generic actions shared between all installations








    /**
    * Callback function used to validate command line argument -t, --template
    *
    * @param string $value containing value passed as argument
    * @return boolean true when the argument passes validation
    */
    function isValidTemplate($value) {
        if ($value == 'cakephp' || $value == 'friendsofcake'){
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
    function isValidVersion($version) {
        if ($version == '2' || $version == '3'){
            return true;
        }
            return false;
    }
