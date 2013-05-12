#!/usr/bin/env zsh

# defaults
interval=600
dir=.

autoload jgetopt
jgetopt $0 " (please enjoy your evening)" \
  interval,i  "change interval (default: $interval)" \
  -- $*

if [[ -n $1 ]] ; then
  if [[ -f $1 ]] ; then
    feh --bg-scale $1
    exit 0
  elif [[ -d $1 ]] ; then
    dir=$1
  else
    echo "bad argument $*"
    exit 1
  fi
fi

while true ; do
  files=($dir/*.(jpg|png))
  feh &>/dev/null --bg-scale $files[$RANDOM%$#files+1]
  sleep $interval
done
