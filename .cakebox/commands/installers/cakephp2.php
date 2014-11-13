<?php

    use Ulrichsg\Getopt\Getopt;
    use Ulrichsg\Getopt\Option;
    use Ulrichsg\Getopt\Argument;

# Define command line argumensts
$getopt2 = new Getopt(array(
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


    # Sanity checking variable availability after include
    echo "parent webroot variable still present and is: $webroot!\n";

    # Sanity checking function availability after include
    if (isValidVersion('3')){
        echo "3 still validates as a valid CakePHP major version\n";
    }
