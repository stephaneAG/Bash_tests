#! /bin/bash

## bash local & global variables test file ##
## StephaneAG - 2014

# R:
#   A variable declared "local" is visible only within the block of code in wich it appears
#   Thus, it has a local "scope"
#   In a function, a "local" variable has a meaning only within that function's block
#
#   In contrary to C, a Bash variable declared inside a function is local ONLY IF DECLARED AS SUCH
#
#   Before a function is called, ALL variables declared within it are invisible outside the body of it,
#   and NOT JUST THOSE DECLARED "LOCAL"
#
#   When declaring & setting a local variable in a single command, the order of the operations is important:
#   - first, set the variable
#   - ONLY AFTERWARDS restrict it to the local scope ( this is reflect in the "return value" )

## prog start ##

#-- global & local variables in a function --#
echo "#-- global & local variables in a function --#"
echo

myFunction(){
  echo "  --myFunction--"

  local local_var=23 # a local variable
  echo "\"local_var\" in myFunction = $local_var" # use the "local" builtin
  global_var=999 # NOT declared as "local" ( -> defaults to "global" )
  echo "\"global_var\" in myFunction = $global_var" 

  echo "  --/myFunction--"
}

# try to access a global variable declared within a function's body before calling it
echo "--before fcn call--"
echo "\"global_var\" outside of myFunction = $global_var" # Nope, the var is NOT visible globally before function call

echo

echo "--fcn call--"
myFunction # call the function

echo

# now, check if the local variable "local_var" exist outside of the function after calling it
echo "--after fcn call--"
echo "\"local_var\" outside of myFunction = $local_var" # Nope, the vaar is NOT visible gloablly
echo "\"global_var\" outside of myFunction = $global_var" # 999, the var is visible globally after function call


echo
echo "--------------------------------"
echo


#-- setting a variable while restricting it to a local scope --#
echo "#-- setting a variable while restricting it to a local scope --#"
echo

myFunction2(){
  echo "  --myFunction2--"
  t0=$(exit 1)
  echo $? # should be 1, as expected

  echo

  echo "--declaration as locallly scoped & assignement in single command--"
  local t1=$(exit 1)
  echo $? # should be 1, but 0, UNexpected

  echo

  echo "--declaration as locally scoped THEN assignement--"
  local t2
  t2=$(exit 1)
  echo $? # should be 1, as expected

  echo

  echo "--assignement THEN declaration as locally scoped--"
  t3=$(exit 1)
  glob_t3_ret_code="$?" # save the return code into another variable ( here, global )
  local loc_t3_ret_code="$glob_t3_ret_code" # assign the return code to another variable
  #local $loc_t3_ret_code # define that variable 'locally scoped' afterward
  echo "\"glob_t3_ret_code\" in myFunction2 = $glob_t3_ret_code"
  local t3
  #echo $? # would correspond to the 'local scoping' of 't3', no its return code
  # trying to see if available globally afterward
 
  echo "  --/myFunction2--" 
}

echo "--outside, before fcn call--"
t=$(exit 1)
echo $? # should be 1, as expected

myFunction2

#echo "--outside, after fcn call--"
echo "\"glob_t3_ret_code\" outside of myFunction2 = $glob_t3_ret_code"  # check if the t3 return code var is available globally after fcn call
echo "\"loc_t3_ret_code\" outside of myFunction2 = $loc_t3_ret_code"  # check if the t3 return code var assigned & then declared locally scoped, is available globally after fcn call

exit 0 # exit the script with the "successful" return code

## prog end ##
