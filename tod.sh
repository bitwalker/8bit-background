#!/bin/bash

MONITOR=
# Parse args
while getopts "m:a" OPTION
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
    a)
      MONITOR=-1
      ;;
    ?)
      echo "Invalid arguments passed to script. Only -m or -a are allowed."
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
# Get the number of monitors
NUM_MONITORS=$(osascript -e "tell application \"System Events\" to get count of (a reference to every desktop)")
# Get the list of desktop resolutions
resolutions=(
  $(/usr/sbin/system_profiler SPDisplaysDataType | grep Resolution | awk '{print $2x$3$4}')
)

# This function will execute some AppleScript to set the background
function setbg {
  if [ $MONITOR -eq -1 ]; then
    for i in {0..$NUM_MONITORS}
    do
      RES=${resolutions[i]}
      CURRENT_DESKTOP=$((i+1))
      osascript -e "
        tell application \"System Events\"
          set allDesktops to a reference to every desktop
          set picture of (item $CURRENT_DESKTOP of allDesktops) to file (POSIX file \"$DIR/images/$RES/$1\") as alias
        end tell
      "
    done
  else
    if [ $MONITOR -le $NUM_MONITORS ]; then
      RES_INDEX=$(($MONITOR-1))
      RES=${resolutions[$RES_INDEX]}
      osascript -e "
        tell application \"System Events\"
          set allDesktops to a reference to every desktop
          set picture of (item $MONITOR of allDesktops) to file (POSIX file \"$DIR/images/$RES/$1\") as alias
        end tell
      "
    fi
  fi
}

# Paths to all of the background images
files=(
  01-Morning.png
  02-Late-Morning.png
  03-Afternoon.png
  04-Late-Afternoon.png
  05-Evening.png
  06-Late-Evening.png
  07-Night.png
  08-Late-Night.png
)

# Timings for the backgrounds, in order
timing=(
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
for i in {7..0}; do
  if [ $hour -ge ${timing[i]} ]; then
    # Set the background to the appropriate image
    setbg ${files[i]}
    exit
  fi
done

# If no match is found for the hour, set the background to late-night.
setbg ${files[7]}
