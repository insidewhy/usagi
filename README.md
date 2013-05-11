# Usagi zsh scripting

## jgetopt

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
