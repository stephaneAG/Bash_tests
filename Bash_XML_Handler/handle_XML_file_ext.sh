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
    XMLfilePath="${cliArgs_item[O]}"
    fileExist_fcn $XMLfilePath
    isXML_fcn $XMLfilePath
    echo "processed existing .xml: $XMLfilePath"

    nodeXPath="${cliArgs_item[1]}"
    isNodePath_fcn $nodeXPath
    splitNodePathToArray_fcn $nodeXPath $XMLfilePath
    echo "processed existing XML XPath: $nodeXPath"
    #echo "Xpath as array outisde of the fcn: ${emptyArray[@]}"

    requestType="${cliArgs_item[2]}"
    requestType_fcn $requestType
    echo "processed request type: $requestType"

    # debug
    #compareTypes_fcn 2 "stef"

  else
    displayHelp_fcn
  fi
else
  displayError_noArgs_fcn
  displayHelp_fcn
fi

#* -- script end -- *#
