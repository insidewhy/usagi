# Usagi zsh scripting

Usagi provides a set of useful applications written in zsh and library functions for zsh.

## Library functions

### jgetopt

Simple command-line argument support

```sh
autoload jgetopt
jgetopt $0 "test program"           \
  v,verbose   "increase verbosity"  \
  a,argument: "string argument"     \
  -- $*

echo "verbosity: ${+verbose}"
echo "argument: '$argument'"
echo "remaining: '$*'"
```

Some test runs of the above program:
```sh
$ ./test.zsh -h
test.zsh test program
usage: ./test.zsh [arguments]
  --verbose, -v         increase verbosity
  --argument, -a <arg>  string argument
  --help, -h            show this help message
```

```sh
$ ./test.zsh -v -a hello p1 p2
verbosity: 1
argument: 'hello'
remaining: 'p1 p2'
```

```sh
$ ./test.zsh
verbosity: 0
argument: ''
remaining:  ''
```

### seqtmp

For creating sequentially numbered files.

```sh
$ ls hello*
zsh: no matches found: hello*
$ autoload seqtmp
$ seqtmp hello
$ ls hello*
hello
$ seqtmp hello
$ seqtmp hello
$ ls hello*
hello hello.0 hello.1
```

## Applications

### Show.zsh

This program facilitates watching shows and recording whether they have been watched in $HOME/.showtimes and, if available, $PWD/.showlist (to facilitate recording which episode is next). If the script terminates before the length of the movie file then the script asks the user if the file should be logged or not.

```sh
$ ./bin/Show.zsh -h
Show.zsh (please enjoy your evening)
usage: ./bin/Show.zsh [arguments]
  --create, -c  add new shows in directory to series list
  --last, -l    watch previously watched show
  --norm, -n    do the volume normalisation
  --back, -b    set show counter back one
  --record, -r  record show in log only
  --print, -p   print next show
  --test, -t    test next show
  --times, -T   just show watch show times
  --help, -h    show this help message
```

To create an index in a directory containing a list of shows.

```sh
$ cd /media/anime/planetes
$ Show -c
$ head -n3 .showlist
Planetes-01.avi
Planetes-02.avi
Planetes-03.avi
```

To watch the next episode:

```sh
$ date
Sun 12 May 12:00:00 BST 2013
$ Show.zsh
mplayer Planetes-01.avi
... etc ...
$ head -n3 .showlist
*2012-05-12~12:00:00 Planetes-01.avi
Planetes-02.avi
Planetes-03.avi
```

To see which episode is next:
```sh
$ Show.zsh -p
Planetes-02.avi
```
