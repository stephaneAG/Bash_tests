#!/bin/bash

# simple bash script returning all arguments passed plus some infos one them

if (( $# != 0 )) # No arguments passed to this script, so we don't know wich script to call ( thus useless ... )
 then
        # echo "The arguments passed were: $@ ."
        if [ "$1" = "helloworld_script" ]
         then
                # echo "CALLBACK_FROM_SCRIPT: bullshit !"
		script_return_value=`./simple_script_returning_stuff_from_passed_arguments.sh whatweedo` # should return 'bullshit'
		echo "CALLBACK_FROM_SCRIPT: /// $script_return_value ///"

        elif [ "$1" = "hellowrite_script" ]
	 then
                 # echo "CALLBACK_FROM_SCRIPT: our precious !"
                script_return_value=`./simple_script_returning_stuff_from_passed_arguments.sh whatwelike` # should return 'our precious'
                echo "CALLBACK_FROM_SCRIPT: /// $script_return_value ///"
		# TO DO  execute a script with the right arguments and write the stuff returned to a specific file
        else
                echo "CALLBACK: unknown argument received"
        fi

 else
        echo "CALLBACK: no argument received"
fi

exit 1
