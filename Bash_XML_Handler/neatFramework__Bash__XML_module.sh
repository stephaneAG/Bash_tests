#! /bin/bash

#* -- neatFramework__Bash__XML_module.sh @StephaneAG - 2014 -- *#
#*
#* The current file defines functions to be called externally

#* -- helpers start -- *#

#* shortcuts for easier access *#
cliArgs=$@
cliArgs_count=$#
cliArgs_item[O]=$1
cliArgs_item[1]=$2
cliArgs_item[2]=$3
cliArgs_item[3]=$4
cliArgs_item[5]=$5
cliArgs_item[6]=$6
cliArgs_item[7]=$7
cliArgs_item[8]=$8
cliArgs_item[9]=$9
cliArgs_item[10]=${10}

#' XML helper functions '#
splitNodePathToArray_fcn(){
  local NodeXPath_arg="$1"
  local XMLfilePath_arg="$2"

  NodeXPath_arg=`echo $NodeXPath_arg | cut -d/ -f2-` # remove leading slash ( / )
  local pathParts_arr
  IFS='/' read -a pathParts_arr <<< "$NodeXPath_arg" # strip the slashes ( / ) & store each part of the XPath as array elements
  # debug
  #for i in "${!pathParts_arr[@]}"
  #do
  #  echo "$i=>${pathParts_arr[i]}"
  #done
  # debug 2
  echo "array: \"${pathParts_arr[@]}\""
  local arrayClone=("${pathParts_arr[@]}")
  echo "array clone: \"${arrayClone[@]}\""
  #local revArray=`echo ${arrayClone[@]} | rev`
  #echo "revArray: \"$revArray\""
  #local e revarray
  #for e in "${arrayClone[@]}"
  #do
  #  revarray=( "$e" "${revarray[@]}" )
  #done
  reverseArray arrayClone
  echo "reversed array clone: \"${arrayClone[@]}\""

  #openingNodesArray arrayClone

  # construct the XML opening tags
  pathParts_arr=("${pathParts_arr[@]/#/<}")
  pathParts_arr=("${pathParts_arr[@]/%/>}")
  echo "opening nodes array: \"${pathParts_arr[@]}\""

  # construct the closing XML tags
  arrayClone=("${arrayClone[@]/#/</}")
  arrayClone=("${arrayClone[@]/%/>}")
  echo "closing nodes array: \"${arrayClone[@]}\""

  # get the XML file content
  local XMLdata=`cat $XMLfilePath_arg`
  echo "XML data:"
  echo "$XMLdata"

  # hack XML data ( debug )
  #local newLineHck=$'\n'
  #local newTabHck=$'\t'
  #local newSpaceHck=$'\s'
  #XMLdata=("${XMLdata//$newLineHck/__neatFramework_NewLine__}") # switch new lines with custom text
  #XMLdataHck1=("${XMLdata//$newTabHck/__neatFramework_NewTab__}") # switch new lines with custom text
  #echo "XML data hck1:"
  #echo $XMLdataHck1

  #XMLdataHck2=("${XMLdata//\/s/__neatFramework_NewSpace__}")
  #echo "XML data hck2:"
  #echo $XMLdataHck2
  #XMLdata=("${XMLdata//__neatFramework_NewTab__/${newTabHck}}")
  #echo "hacked-back XML data:"
  #echo $XMLdata


  # construct the regexp
  #local regexp="<AppConfig>(.*)<CheckProcOrWinRunning>(.*)</CheckProcOrWinRunning>(.*)</AppConfig>"

  #local dummyData="<CheckProcOrWinRunning> loooool </CheckProcOrWinRunning>"
  #local regexp="<CheckProcOrWinRunning>(.*+)</CheckProcOrWinRunning>"  usage: ${BASH_REMATCH[1]}
  #local dummyData="<AppConfig> some random stuff <CheckProcOrWinRunning> loooool </CheckProcOrWinRunning> some other random stuff </AppConfig>"
  #local regexp="(.*+)<CheckProcOrWinRunning>(.*+)</CheckProcOrWinRunning>"   usage: ${BASH_REMATCH[2]}
  local dummyData="<AppConfig> some random stuff <CheckProcOrWinRunning> loooool I love that </CheckProcOrWinRunning> some other random stuff </AppConfig>"
  local dummyData2="<AppConfig> \n oik <CheckProcOrWinRunning> loooool I love that </CheckProcOrWinRunning> randoooom </AppConfig>"
  local dummyData3="      <start>lool</start>"
  local dummyData4=" \n    <start>lalalililou</start>"
  local dummyData5="<AppConfig> \\ <CheckProcOrWinRunning>looooolLesTroooools</CheckProcOrWinRunning>  </AppConfig>"
  #echo -e "$dummyData4"
  #echo -e "$dummyData2"
  echo -e "$dummyData5"
  local regexp=".*+<AppConfig>.*+<CheckProcOrWinRunning>(.*+)</CheckProcOrWinRunning>.*+</AppConfig>.*+"
  local regexp2="[[:space:]]+<AppConfig>[[:space:]]+<CheckProcOrWinRunning>(.*+)</CheckProcOrWinRunning>[[:space:]]+</AppConfig>[[:space:]]+"
  local easierReg=".*+<CheckProcOrWinRunning>(.*+)</CheckProcOrWinRunning>.*+" # works ( but toooo easy to be clean for a day-to-day use)
  local regexp3="[[:space:]]+<start>(.*)</start>"
  local regexp4="<AppConfig>[[:space:]]+<CheckProcOrWinRunning>(.*)</CheckProcOrWinRunning>[[:space:]]+</AppConfig>"
  local rR=$'\n'
  echo "lol I am $rR walking on sunshine .."
  #local easierRegEx2="$rR.*+<AppConfig>$rR.*+<CheckProcOrWinRunning>(.*+)</CheckProcOrWinRunning>$rR.*+</AppConfig>.*+"
  #local easierRegEx2="\"$rR\".*+<AppConfig>\"$rR\".*+<CheckProcOrWinRunning>(.*+)</CheckProcOrWinRunning>\"$rR\".*+</AppConfig>.*+"
  #local easierRegEx2=".*+<AppConfig>\\\n.*+<CheckProcOrWinRunning>(.*+)</CheckProcOrWinRunning>\\\n.*+</AppConfig>.*+"
  #local finalRegEx="\t\r\n.*+<AppConfig>\t\r\n.*+<CheckProcOrWinRunning>(.*+)</CheckProcOrWinRunning>\t\r\n.*+</AppConfig>\t\r\n.*+"
  #local finalRegEx="\\t\\r\\n.*+<AppConfig>\\t\\r\\n.*+<CheckProcOrWinRunning>(.*+)</CheckProcOrWinRunning>\\t\\r\\n.*+</AppConfig>\\t\\r\\n.*+"
  #local finalRegEx="$'\t'$'\r'$'\n'.*+<AppConfig>$'\t'$'\r'$'\n'.*+<CheckProcOrWinRunning>(.*+)</CheckProcOrWinRunning>$'\t'$'\r'$'\n'.*+</AppConfig>$'\t'$'\r'$'\n'.*+"
  local regFound
  #[[ $dummyData =~ $regexp ]] && regFound="${BASH_REMATCH[1]}" # works ( .. )
  #[[ $dummyData2 =~ $regexp2 ]] && regFound="${BASH_REMATCH[1]}"
  #[[ $dummyData3 =~ $regexp3 ]] && regFound="${BASH_REMATCH[1]}" # works !
  #[[ $dummyData4 =~ $regexp3 ]] && regFound="${BASH_REMATCH[1]}" # also works !
  [[ $dummyData5 =~ $regexp4 ]] && regFound="${BASH_REMATCH[1]}"
  echo "Found! : \"$regFound\""

  #reverseArray
  #echo "array clone after reversal: \"${arrayClone[@]}\""

  #reverseArray "${pathParts_arr[@]}"
  #local emptyArray=('fruit' 'lols')
  #cloneArray arrayClone[@] emptyArray[@] emptyArray
  #echo "empty array after the cloning took effect: ${emptyArray[@]}"
  #echo "cloned array after the cloning took effect: ${arrayClone[@]}"


}

cloneArray(){
  local originalArray
  declare -a originalArray=("${!1}")
  #local cloneArray
  #declare -a cloneArray=("${!2}")
  declare -a arrayClone=("${!2}")
  #declare -a cloneArray="${2}"
  echo "original array received as parameter: ${originalArray[@]}"
  echo "empty array received as parameter: ${arrayClone[@]}"
  arrayClone=("${originalArray[@]}")
  debugArrStuff=("${!3}")
  echo $debugArrStuff
  emptyArray=('trafalgar') # only way to do it I know by now 
  echo "empty array received as parameter: ${arrayClone[@]}"
}

#reverseArray(){
#  local reversedArray
#  declare -a reversedArray=()
#  local arrayCloneLen="${#arrayClone[@]}"
#  echo "arrayCloneLen : \"$arrayCloneLen\""
#  for ((index=${#arrayClone[@]} -1; index>=0; index-- )); do
#    echo "${arrayClone[index]}"
#    echo "current index of array 1 ( reversed ): \"$index\""
#    local reversedIndex=$(($arrayCloneLen-$index))
#    echo "reversed index of array 2 ( planned ): \"$reversedIndex\""
#    #reversedArray[reversedIndex]=${arrayClone[index]}
#    reversedArray[index]=${arrayClone[reversedIndex]}
#  done
#}

reverseArray(){ # USAGE: reverse arrayname
  local arrayname=${1:?Array name required} array revarray e
  eval "array=( \"\${$arrayname[@]}\" )" # copy the array, $arrayname, to local array 
  for e in "${array[@]}"
  do
    revarray=( "$e" "${revarray[@]}" )
  done
  eval "$arrayname=( \"\${revarray[@]}\" )" # copy revarray back to $arrayname 
}

openingNodesArray(){
  local arrayname=${1:?Array name required} array opnodesarray e
  eval "array=( \"\${$arrayname[@]}\" )" # copy the array, $arrayname, to local array
  #for e in "${array[@]}"
  for e in "${#array[@]}"
  do
    opnodesarray[i]="^"array[e]
  done
  eval "$arrayname=( \"\${opnodesarray[@]}\" )" # copy revarray back to $arrayname
}

#* -- helpers end -- *#


#* -- Functions definitions start -- *#

#* a "Hello World"-like fcn implm *#
helloBox_fcn(){
  #zenity --warning --text="Hello World"
  zenity --info --text="Hello World"
}

#* display the 'no arguments received' error *#
displayError_noArgs_fcn(){
  echo "Error: No command line arguments were received !"
}

#* display the help *#
displayHelp_fcn(){
  echo -e "The program accept 2 methods: 'get' and 'set'" "\n" \
      "\r""Examples:" "\n\n" \
      "\r""getting the value of the item present at the <Path> XPath in the <filename> XML file" "\n" \
      "\r""./handle_XML_file.sh ./app_config__barebone.xml /AppConfig/CheckProcOrWinRunning get" "\n\n" \
      "\r""setting the value of the item present at the <Path> XPath in the <filename> XML file to 'true' " "\n" \
      "\r""./andle_XML_file.vbs ./app_config__barebone.xml /AppConfig/CheckProcOrWinRunning set true" "\n\n"
}

#* fileExist_fcn(XMLfilePath) - check that the file actually exist *#
#* returns nothing if file is found, else display an error & quit *#
fileExist_fcn(){
  local XMLfilePath_arg="$1"
  if [ ! -f $XMLfilePath_arg ]; then # if the file dones't exist
    echo "Error: the file passed as cli parameter doesn't exists !"
    exit 1
  #else
  #  cat $XMLfilePath_arg # will be nice for the "displayTree" fcn ( wich would actually display the xml as is, just stripped from its first line )
  fi
}

#* isXML_fcn(XMLfilePath) - check that the file actually has the '.xml' extension *#
#* returns nothing if it has the correct extension, else display an error & quit *#
isXML_fcn(){
  local XMLfilePath_arg="$1"
  if [[ ! $XMLfilePath_arg == *.xml ]]; then
    echo "Error: the file passed as cli parameter doesn't have the '.xml' extension !"
    exit 1
  #else
  #  echo "is XML"
  fi
}

#* IsNodePath_fcn(NodeXPath) - check that we have an actual path ( aka a string starting with a forward slash ( "/" ) ) *#
#* returns nothing if it starts with a forward slash, else display an error & quit *#
isNodePath_fcn(){
  local nodeXPath_arg="$1"
  if [[ ! $nodeXPath_arg == /* ]]; then
    echo "The XPath path passed as cli parameter seems not valid" "\n" \
     "\r"" ( it should start with a forward slash ( '/' ) )"
    exit 1
  #else
  #  echo "is XPath"
  fi
}

#* isNumber_fcn(theValue) - check whether the value passed is a number or a string *#
#* returns either "Number" or "String" depending to the data contained in "theValue" *#
isNumber_fcn(){
  local theValue="$1"
  if [[ $theValue =~ ^[0-9]+$ ]]; then
    echo "Number"
  else
    echo "String"
  fi
}

#* - compare the two values passed and determine if their type differs *#
#* returns either "differs" or "match" *#
compareTypes_fcn(){
  local firstValue="$1"
  local secondValue="$2"
  local firstValType=`isNumber_fcn $firstValue`
  local secondValType=`isNumber_fcn $secondValue`
  echo "first value: \"$firstValue\" has type: \"$firstValType\""
  echo "second value: \"$secondValue\" has type: \"$secondValType\""
  if [ "$firstValType" == "$secondValType" ]; then
    echo "matches"
  else
    echo "differs"
  fi
}

#* requestType_fcn(requestArg) - return the request type depending on the argument passed *#
#* will either return nothing or throw an error an exit *#
requestType_fcn(){
  local requestArg="$1"
  if [ ! "$requestArg" == "get" ] && [ ! "$requestArg" == "set" ] && [ ! "$requestArg" == "tree" ]; then
    echo "Error: the request type \"$requestArg\" passed as cli parameter is not supported !"
    exit 1
  #if [ "$requestArg" == "get" ]; then
  #  echo "get"
  #elif [ "$requestArg" == "set" ];then
  #  echo "set"
  #elif [ "$requestArg" == "tree" ]; then
  #  echo "tree"
  #else
  #  echo "unsupported"
  fi
}

#* handleRequestGET_fcn(XMLfilePath, nodeXPath) - handle "get" requests *#
#* returns the value requested, extracted from the specified XML file at the desired XPath *#
handleRequestGET_fcn(){
  echo "GET"
  local XMLfilePath_arg="$1"
  local nodeXPath_arg="$2"
}
#* handleRequestSET_fcn(XMLfilePath, nodeXPath, newValue) - handle "set" requests *#
#* updates the value requested, then returns it, extracted from the specified XML file at the desired XPath *#
handleRequestSET_fcn(){
  echo "SET"
  local XMLfilePath_arg="$1"
  local nodeXPath_arg="$2"
  local newValue_arg="$3"
}

#* display a structured tree of the XML file *#
displayTree_fcn(){
  echo "Tree"
}

#* -- Functions  definitions end -- *#
