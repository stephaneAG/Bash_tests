#!/usr/bin/env sh

# dummy test with heredoc syntax to pass arguments to a script
#
# usage:
# ./test_script_dumbo.sh << EOF
# my
# first
# arguments
# EOF
#
# instead of "./test_script_dumbo.sh my first arguments"
#
# Nb: we can also mix the two ;p
#
# ex: "./test_script_dumbo.sh my first arguments << EOF ..." :)


# "standard" arguments handling
echo "script: $0"
echo "arg1: $1"
echo "arg2: $2"
echo "arg3: $3"
echo "all args: $@"

# -- wip test - cattin' everything received at once
echo "== catting start =="
stdin=$(cat)
echo "$stdin"
echo "== catting end =="

# R: the above prevents the following to work, & vice versa
# ( precedence discards the latter )

# test for using ./script << EOF <args & stuff .. then EOF>
$counter #='0' #$((1-1))
counter=$((0))
while read CMD; do
  echo "heredoc argument n°$counter"
  counter=$(($counter+1))
  echo $CMD
done 
