#!/bin/bash

# simple bash script returning all arguments passed plus some infos one them

echo "The script $0  were passed $#  arguments."

if (( $# != 0 ))
 then
	echo "The arguments passed were: $@ ."
 else
	echo "No arguments were passed."
fi

exit 1
