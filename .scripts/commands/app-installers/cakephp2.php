<?php

    # Provide Vagrant provisioning feedback
    echo "Creating CakePHP 2.x application " . URL . "\n";

    # Git clone the cakephp repository
    if ($cakebox->dirAvailable(APP_DIR)){
        $cakebox->executeShell("git clone git://github.com/cakephp/cakephp.git " . APP_DIR, "vagrant");
    }else{
        echo " * Skipping Git installation: " . APP_DIR . " not empty\n";
    }
