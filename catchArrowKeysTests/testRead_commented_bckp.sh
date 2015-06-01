#!/bin/bash

# --------------------------------------------
# Source used aliases & fcns
source ~/.bash_stephaneag_functions
source ~/.bash_stephaneag_aliases

# --------------------------------------------
# trap ctrl-c and call ctrl_c() ( useful for cleanup )
trap ctrl_c INT

ctrl_c() {
  echo
  echo "** Trapped CTRL-C ! **"
  # do some cleanup
  terminateImageDisplay

  # fix to restore the prompt ( ' having invisible commands typing, because "read" disbles local echo ( .. ) )
  #reset - as efficient but has side effects :/
  stty "$console_bckp"
  
  exit 0
}

#--------------------------------------------
# Image display
initImageDisplay(){
  echo -en "\rinitiating terminal image display"
  # backup term conf to scriptsDb
  stag__gnomeTerm_confToScriptsDb imgToTermBckgrnd >/dev/null 2>&1
  # get the current terminal profile
  currTermProfile=`stag__scriptsDb_get ${scriptNamespace}.profile`
  # override term conf to use a background type of image
  gconftool-2 --set /apps/gnome-terminal/profiles/$currTermProfile/background_type --type string image
  # override term conf to adjust the transparency of the background
  gconftool-2 --set /apps/gnome-terminal/profiles/$currTermProfile/background_darkness --type float 0.5 # 0.85
  # override term conf to prevent background scrolling
  gconftool-2 --set /apps/gnome-terminal/profiles/$currTermProfile/background_type --type bool false
}
displayImage(){
  echo -en "\rdisplaying image in terminal image display"
  
  # get the current terminal profile
  currTermProfile=`stag__scriptsDb_get ${scriptNamespace}.profile`
  
  # get the filename without path
  imgName="${1##*/}"
  imgName="${imgName%%.*}"
  echo "IMG NAME: $imgName"
  
  # get extension from image path
  #imgExt="${1##*/}"
  imgExt="${1##*.}"
  echo "IMG EXT: $imgExt"
  
  # get random name
  randHash=$(date | md5sum)
  # get a portion ( 10 chars ) out of the above hash
  littlHash=${randHash:0:10}
  
  # get the generated img name
  randImgName="$imgName.$littlHash.$imgExt"
  #randImgName="$imgName.termImg.$imgExt"
  
  echo "GENERATED IMG NAME: $randImgName"
  #echo
  
  # remove any tmp file from the tmp_imgs directory ( also done during cleanup, nb: here we prevent erros to show up as we may not have any tmp files yet :) )
  rm $imgs_tmp_dir/* 2> /dev/null
  
  # move the image to our tmp directory under a tmp name
  #mv "$imgs_path_arg/$1" "$imgs_tmp_dir/lol.img" # not working as is
  cp "$1" "$imgs_tmp_dir/$randImgName"
  
  # get a background transparency mostly similar to the previous one but also provide a default
  transparency="0.5"
  scriptNamespace="imgToTermBckgrnd"
  currBckgrndDrknss=`stag__scriptsDb_get ${scriptNamespace}.backgroundDarkness`
  if [ "$currBckgrndDrknss" != "keynotfound" ]
  then
    # override default transparency using the original background transparency set
    transparency="${currBckgrndDrknss}"
    echo "transparency override used for the image container: ${transparency}"
    #echo
  fi
  
  
  # prepare the image TODO: accept "--screensize" param || deduce the terminal window's width & height
  # by npw, we just provide a zoom option & a default 50% resize for the image being displayed
  echo "CURRENT ZOOM: $curr_zoom"
  echo
  
  convert "$imgs_tmp_dir/$randImgName" -resize "$curr_zoom"% "$imgs_tmp_dir/$randImgName"
  convert "$imgs_tmp_dir/$randImgName" -gravity NorthEast -background "rgba(0, 0, 0, ${transparency})" -extent 1920x1080 "$imgs_tmp_dir/$randImgName"
  
  # finally, display the image
  gconftool-2 --set /apps/gnome-terminal/profiles/$currTermProfile/background_image --type string "$imgs_tmp_dir/$randImgName"
}
terminateImageDisplay(){
  echo "terminating terminal image display"
  # restore term conf from scriptsDb
  stag__gnomeTerm_confFromScriptsDb imgToTermBckgrnd >/dev/null 2>&1
  # remove any tmp file from the tmp_imgs directory
  rm $imgs_tmp_dir/*
}

#--------------------------------------------
# Images files handling

# get previous img or last one if no previous exist
handlePreviousImg(){
  #echo -en "\r" # fix
  imgIdx=0
  for img in "${imgs[@]}"
  do
    #echo -n "index: $imgIdx"
    if [[ "$img" == "$curr_img" ]]; then
      #echo -n " -> IMG MATCH: $img"
      curr_img_idx="$imgIdx"
      #echo -n " => IMG MATCH INDEX: $curr_img_idx"
      new_img_idx=$(($curr_img_idx-1))
      #echo -n " => PREV IMG INDEX : $new_img_idx"
      if (( "$new_img_idx" < 0 )); then
        #new_img_idx="${#imgs[@]}"
        new_img_idx=$((${#imgs[@]}-1))
        #echo " => NO PREV IMG > OVERRIDE INDEX : $new_img_idx"
      #else
        #echo "" # fix
      fi
      curr_img="${imgs[$new_img_idx]}"
      break
    #else
      #echo "" # fix
    fi
    let imgIdx++
  done  
}
# get next img or first one
handleNextImg(){
  #echo -en "\r" # fix
  imgIdx=0
  for img in "${imgs[@]}"
  do
    #echo -n "index: $imgIdx"
    if [[ "$img" == "$curr_img" ]]; then
      #echo -n " -> IMG MATCH: $img"
      curr_img_idx="$imgIdx"
      #echo -n " => IMG MATCH INDEX: $curr_img_idx"
      new_img_idx=$(($curr_img_idx+1))
      #echo -n " => NEXT IMG INDEX : $new_img_idx"
      if (( "$new_img_idx" > $((${#imgs[@]}-1)) )); then
        #new_img_idx="${#imgs[@]}"
        new_img_idx="0"
        #echo " => NO NEXT IMG > OVERRIDE INDEX : $new_img_idx"
      #else
        #echo "" # fix
      fi
      curr_img="${imgs[$new_img_idx]}"
      break
    #else
      #echo "" # fix
    fi
    let imgIdx++
  done  
}


#--------------------------------------------
# Simple arithmetical expressions & stuff ( maybe to be used later with AAF for a character control on a map ? ;P )
x=0
x_max=100 # screen width
y=0
y_max=50 # screen height
curr_x=50
curr_y=25

zoom=0
zoom_max=100
curr_zoom=50


#--------------------------------------------
# Functions using arithmetical expressions to update curr_x & curr_y, and also curr_zoom ;)
upKeyPress(){
  if (( "$curr_x" >= "$x_max" )); then
    curr_x="$x"
  else
    let curr_x++
  fi
}
downKeyPress(){
  if (( "$curr_x" <= "$x" )); then
    curr_x="$x_max"
  else
    let curr_x--
  fi
}
leftKeyPress(){
  if (( "$curr_y" <= "$y" )); then
    curr_y="$y_max"
  else
    let curr_y--
  fi
}
rightKeyPress(){
  if (( "$curr_y" >= "$y_max" )); then
    curr_y="$y"
  else
    let curr_y++
  fi
}

zoomIn(){
  if (( "$curr_zoom" < "$zoom_max" )); then
    let curr_zoom+=5
  fi
}

zoomOut(){
  if (( "$curr_zoom" > "$zoom" )); then
    let curr_zoom-=5
  fi
}

resetZoomToDef(){
  curr_zoom=50
  echo -en "\rZOOM RESET TO DEFAULT: $curr_zoom%"
  echo
}

#--------------------------------------------
# Keeping it DRY ;p
logInfos(){
  echo -en "\rIMG: [" $curr_img "] POSITION: [" $curr_x "," $curr_y "] ZOOM: [ " $curr_zoom "% ] READ: [ $1 ]"
}

handleCommand(){
  echo -en "\r" # fix 
  read -p "COMMAND: " aCmd; echo -en "\rIMG: [" $curr_img "] POSITION: [" $curr_x "," $curr_y "] COMMAND: [ " $aCmd " ] RESULT: [ " `$aCmd` " ]"
}


#--------------------------------------------
# Hacky handling of arrow keys ( using "A"(up), "B"(down), "D"(left), "C"(right))
hackyKeyboardHandle(){
  # fix to prevent previous lines from appearing ( contains more spaces than the most wide stuff echoed, nb: better ? -> cursor ( AAF ) )
  echo -en "\r                                                                                                                                                                   "
  case $key in
  A) upKeyPress; logInfos "UP_ARROW" ;;
  B) downKeyPress; logInfos "DOWN_ARROW" ;;
  D) leftKeyPress; logInfos "LEFT_ARROW" ;;
  C) rightKeyPress; logInfos "RIGHT_ARROW" ;;
  '<') handlePreviousImg; displayImage $curr_img; logInfos "PREVIOUS IMAGE" ;;
  '>') handleNextImg; displayImage $curr_img; logInfos "NEXT IMAGE" ;;
  '+') zoomIn; displayImage $curr_img; logInfos "ZOOM +" ;;
  '-') zoomOut; displayImage $curr_img; logInfos "ZOOM -" ;;
  z) resetZoomToDef; displayImage $curr_img; logInfos "DEFAULT ZOOM" ;;
  c) handleCommand ;;
  *) logInfos $key
  esac
}

#--------------------------------------------
#Init & args debug

# fix to restore the prompt ( see code in trap Ctrl-C )
console_bckp=$(stty -g)

initImageDisplay

working_dir="/home/stephaneag/Documents/Development/dev__shell/catchArrowKeysTests"
imgs_tmp_dir="$working_dir/tmp_imgs"

# idea: if no param(s) passed ( nor a path(s) to dir(s) nor img(s) ), use the Pictures dir ;)

# tmp debug
imgs_path_arg="$1"
echo "IMGS PATH PASSED AS ARG: $imgs_path_arg"

#imgs=(`ls *.{jpg,png} 2> /dev/null`) # hardcoded
imgs=(`ls $1*.{jpg,png} 2> /dev/null`) # not clean, nb: seems to take the current working directory if none was specified ;D
#imgsList=ls $imgs_path_arg/*.{jpg,png} 2> /dev/null # not working as is
#imgs=(`ls /home/stephaneag/Documents/Development/dev__shell/catchArrowKeysTests/*.{jpg,png} 2> /dev/null`)
echo "-- IMAGES LIST --"
for img in "${imgs[@]}"
do
  echo $img
done

curr_img="${imgs[0]}"
echo "CURRENT IMG: $curr_img"

# display the first image ( right now, we only support passing a path to a dir, & no checks are dpne [yet] to verify that we have an image in a particular dir to begin with )
displayImage $curr_img; logInfos "FIRST IMAGE"

#--------------------------------------------
# Infinite loop
while true
do
  read -s -n1 key # Read 1 characters.
  #echo -en "\rREAD: [" $key "]"
  hackyKeyboardHandle

  # test 1
  #read -p "Username: " uname
  #stty -echo
  #read -p "Password: " passw; echo
  #stty echo

  # test 1 - more elegant
  #read -s -p "Password: " passwd;

done
