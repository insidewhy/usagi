#!/usr/bin/env zsh

# when the show is started in seconds since epoch
showtime=$(date +%s)
showtime_fmt=$(date +%Y-%m-%d~%H:%M:%S -d@$showtime) # as string

player=(mpv)
if ps auxww | grep -v grep | grep -q 'pulseaudio --start' ; then
  player+=(-ao pulse)
fi

time_too_low=30
time_delta_accepted=40

# where to store master list
masterlist=~/.showtimes

showglob=*.(mkv|avi|mpg|mp4|mpeg|ogv|wmv|flv|m4v|iso)(.)

save_show_time() {
    tmp=$(mktemp)
    if [[ -f .showlist ]] ; then
      grep '^*' .showlist > $tmp
      echo -n "*$showtime_fmt " >> $tmp
      grep -v '^*' .showlist >> $tmp
      mv $tmp .showlist
    fi
    save_show_in_master_list
}

save_show_in_master_list() {
    [[ -f $masterlist ]] && echo "$showtime_fmt $show" >> $masterlist
}

fail() {
    echo $*
    exit 1
}

# play show in global variable $show with args in $args
play_show() {
    local length=$(mplayer -frames 0 -identify $show 2>/dev/null \
                   | grep ID_LENGTH | cut -d= -f2)

    extra_args_file=$(dirname $show)/.mpv-args
    [ -f $extra_args_file ] && extra_args=($(cat $extra_args_file))

    $player $args $extra_args $show || return 1

    [[ $+test = 1 || $+last = 1 ]] && return 1

    local end_time=$(date +%s)
    local time_watching=$(($end_time - $showtime))
    local time_left=$(($length - $time_watching))

    if [[ $time_watching -lt $time_too_low ]] ; then
        return 1
    elif [[ $time_left -gt $time_delta_accepted ]] ; then
        while true ; do
            echo -n "watching for $time_watching seconds, $time_left seconds left, do you want to log? [yN]"
            read ans
            if [[ $ans =~ "^y(es)?|Y(es)?$" ]] ; then
                echo logging
                return 0
            elif [[ $ans =~ ^[nN]o?$ ]] ; then
                echo not logging
                return 1
            fi
        done
    else
        return 0
    fi
}

autoload jgetopt
jgetopt $0 "(please enjoy your evening)" \
    create,c  "add new shows in directory to series list" \
    last,l  "watch previously watched show" \
    norm,n  "do the volume normalisation" \
    back,b  "set show counter back one" \
    record,r  "record show in log only" \
    print,p  "print next show" \
    test,t  "test next show" \
    times,T "just show watch show times" \
    highvol,H "increase volume of video" \
    -- $*

if [[ $+times = 1 ]] ; then
    less $masterlist
    exit 0
fi

if [[ $+create = 1 ]] ; then
    if [ -f .showlist ] ; then
        diff <(cat .showlist | cut -d' ' -f2-) <(ls ${~showglob}) \
            | grep '^>' | sed 's/^> //'  >> .showlist
    else
        ls ${~showglob} > .showlist
    fi
    exit 0
fi

if [[ $+norm = 1 ]] ; then
    args=(-af drc)
fi

if [[ $+highvol = 1 ]] ; then
    args=(-af volume=14)
fi

if [[ $+back = 1 ]] ; then
    # TODO: fix this
    # save_show_time
    echo > /dev/stderr -b currently not supported
    exit 1
fi

if [ -f .showlist ] ; then
    if [[ $+last = 1 ]] ; then
        show=$(grep '^\*' .showlist | tail -n 1 | sed 's/^*[^ ]* //')
    else
        show=$(grep -v '^\*' .showlist | head -n 1)
    fi
fi

if [[ ${#positionals} > 0 ]] ; then
    show=($positionals)
fi

if [[ -z $show ]] ; then
    show=(${~showglob})

    if [[ ${#show} == 1 ]] ; then
        if [[ $+print = 1 ]] ; then
            echo $show
            exit 0
        elif [[ $+record = 1 ]] || play_show ; then
            save_show_in_master_list
            exit 0
        else
            exit 1
        fi
    else
        echo "multiple shows to choose from: $show"
        exit 1
    fi
fi

if [[ $+print = 1 ]] ; then
    echo $show
    exit 0
elif [[ $+record = 1 ]] ; then
    save_show_time
    exit 0
fi

if play_show ; then
    save_show_time
fi
