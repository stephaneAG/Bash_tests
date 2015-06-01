#!/bin/bash

# simple bash script returning all arguments passed plus some infos one them

# echo "The script $0  were passed $#  arguments."

if (( $# != 0 ))
 then
	# echo "The arguments passed were: $@ ."
	if [ "$1" = "whatweedo" ]
	 then
		echo "CALLBACK: bullshit !"

	elif [ "$1" = "whatwelike" ]

	 then
		echo "CALLBACK: our precious !"
	else
		echo "CALLBACK: unknown argument received"
	fi

 else
	echo "CALLBACK: no argument received"
fi

exit 1
