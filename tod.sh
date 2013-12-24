#!/bin/bash

MONITOR=
while getopts "m:" OPTION
do
  case $OPTION in
    m)
      # Validate argument value
      re='^[1-4]$'
      if ! [[ $OPTARG =~ $re ]]; then
        echo "Invalid value for -m. Must be an integer between 1 and 4"
        exit
      fi
      # If valid, continue
      MONITOR=$OPTARG
      ;;
    ?)
      echo "Invalid arguments passed to script. Only -m is allowed."
      exit
      ;;
  esac
done

# If no value for $MONITOR was passed, set to the primary monitor (1)
if [[ -z $MONITOR ]]; then
  MONITOR=1
fi

# Get the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# This function will execute some AppleScript to set the background
function setbg {
  #osascript -e "
    #tell application \"Finder\"
      #set desktop picture to (POSIX file \"$DIR/$1\") as alias
    #end tell
  #"
  osascript -e "
    tell application \"System Events\"
      set allDesktops to a reference to every desktop
      set numDesktops to count of allDesktops
      if $MONITOR <= numDesktops then
        set picture of (item $MONITOR of allDesktops) to file (POSIX file \"$DIR/$1\") as alias
      end if
    end tell
  "
}

# Paths to all of the background images
files=(
  images/1-early-morning.jpg
  images/2-morning.jpg
  images/3-late-morning.jpg
  images/4-afternoon.jpg
  images/5-late-afternoon.jpg
  images/6-evening.jpg
  images/7-late-evening.jpg
  images/8-night.jpg
  images/9-late-night.jpg
)

# Timings for the backgrounds, in order
timing=(
  4
  7
  10
  12
  16
  18
  19
  21
  23
)

# The current hour as an integer
hour=`date +%H`

# Loop over every timing, if the current hour is greater than or equal
# to the timing value, set the background to the corresponding image
for i in {8..0..-1}
do
  if [ $hour -ge ${timing[i]} ]; then
    # Set the background to the appropriate image
    setbg ${files[i]}
    exit
  fi
done

# If no match is found for the hour, set the background to late-night.
setbg ${files[8]}
