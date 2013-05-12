#!/usr/bin/env zsh

# defaults
interval=600

autoload jgetopt
jgetopt $0 " (please enjoy your evening)" \
  interval,i:  "change interval (default: $interval)" \
  -- $*

arg=$positionals[1]

if [[ -z $arg ]] ; then
  echo "must supply directory or image file"
  exit 1
fi

if [[ -f $arg ]] ; then
  feh --bg-scale $arg
elif [[ -d $arg ]] ; then
  while true ; do
    files=($arg/*.(jpg|png))
    feh &>/dev/null --bg-scale $files[$RANDOM%$#files+1]
    sleep $interval
  done
else
  echo "bad argument $arg"
  exit 1
fi

exit 0
