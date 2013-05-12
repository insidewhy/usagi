# Usagi zsh scripting

Usagi provides a set of useful applications written in zsh and library functions for zsh.

## Library functions

### jgetopt

Simple command-line argument support

```shell
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
```shell
$ ./test.zsh -h
test.zsh test program
usage: ./test.zsh [arguments]
  --verbose, -v         increase verbosity
  --argument, -a <arg>  string argument
  --help, -h            show this help message
```

```shell
$ ./test.zsh -v -a hello p1 p2
verbosity: 1
argument: 'hello'
remaining: 'p1 p2'
```

```shell
$ ./test.zsh
verbosity: 0
argument: ''
remaining:  ''
```

### seqtmp

For creating sequentially numbered files.

```shell
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

```shell
% ./bin/Show.zsh -h
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

```shell
% cd /media/anime/planetes
% Show -c
% head -n3 .showlist
Planetes-01.avi
Planetes-02.avi
Planetes-03.avi
```

To watch the next episode:

```shell
$ Show.zsh
mplayer Planetes-01.avi
... etc ...
% date
Sun 12 May 12:00:00 BST 2013
% head -n3 .showlist
*2012-05-12~12:00:00 Planetes-01.avi
Planetes-02.avi
Planetes-03.avi
```

To see which episode is next:
```shell
$ Show.zsh -p
Planetes-01.avi
```
