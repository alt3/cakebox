<?php

    # Sanity checking variable availability after include
    echo "parent webroot variable still present and is: $webroot!\n";

    # Sanity checking function availability after include
    if (isValidVersion('3')){
        echo "3 still validates as a valid CakePHP major version\n";
    }
