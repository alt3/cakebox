<?php
use Ulrichsg\Getopt\Getopt;
use Ulrichsg\Getopt\Option;
use Ulrichsg\Getopt\Argument;
/**
* Cakebox script for generating CakePHP applications
*
*
* @return bool false on success, true when
*/

    # Define command line argumensts
    $getopt = new Getopt(array(
        (new Option('t', 'template', Getopt::OPTIONAL_ARGUMENT))
            ->setDescription('template used to generate the application (defaults to cakephp, supports friendsofcake)')
            ->setDefaultValue('cakephp')
            ->setValidation("isValidTemplate"),
        (new Option('v', 'version', Getopt::OPTIONAL_ARGUMENT))
            ->setDescription('CakePHP major version (defaults to 3, supports 2)')
            ->setDefaultValue('3')
            ->setValidation("isValidVersion"),
        (new Option('h', 'help', Getopt::NO_ARGUMENT))
            ->setDescription('display this help and exit')
        ));

    # Define custom banner for auto-generated --help message
    $getopt->setBanner(
        "Installs a fully working CakePHP application in ~/Apps using Nginx and MySQL.\n" .
        "Usage: cakebox-app [<options>] <url>\n"
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

    # @todo Execute generic actions shared between all installations

    # Sanity checking installer script inclusion
    echo "before\n";
    $webroot = "myroot";
    include "app-installers/cakephp2.php";
    echo "after\n";

    # @todo Round up
