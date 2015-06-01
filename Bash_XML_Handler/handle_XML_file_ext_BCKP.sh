#* -- handle_XML_file_ext.vbs @StephaneAG - 2014 -- *#
#*
#* Bash implementation of the "handle_XML_file.vbs",
#* still making use of function declared externally
#*

#* -- helpers start -- *#
#* -- helpers end -- *#

#* -- includes start -- *#

#* make use of our functions defined in an external .sh file *#
source "./neatFramework__Bash__XML_module.sh"

#* -- includes end -- *#

#* -- script start -- *#

#* call our test fcn defined in the included module file *#
helloBox_fcn

#* handle the cli arguments passed *#
#if (( $# != 0 )); then
#if [ $cliArgs_count -eq 1 ]; then # -ne = not equals
if (( $cliArgs_count != 0 )); then
  #if [ $cliArgs_count -eq 1 ]; then # -eq = equals
  if (( $cliArgs_count == 1 )) && [ "${cliArgs_item[O]}" = "help" ]; then
    echo "One argument received & is \"help\""
  elif (( $cliArgs_count == 3 )) || (( $cliArgs_count == 4 )); then
    #* do the checks (..) *#
    XMLfilePath_arg="${cliArgs_item[O]}"
    fileExist_fcn $XMLfilePath_arg
    isXML_fcn $XMLfilePath_arg
    echo "processed existing .xml: $XMLfilePath_arg"

    nodeXPath="${cliArgs_item[1]}"
    splitNodePathToArray_fcn $nodeXPath
    echo "processed existing XML XPath: $nodeXPath"

  else
    displayHelp_fcn
  fi
else
  displayError_noArgs_fcn
  displayHelp_fcn
fi

#* -- script end -- *#
