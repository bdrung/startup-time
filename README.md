Startup time of different programming languages
===============================================

The startup time of a programming language is important for short running programs that are called
interactively by the user or are called (many times) by other programs. For example, the version
control system Git is written in C and the invoked commands (like `git status` and `git log`)
execute fast. The version control systems Bazaar and Mercurial are written in Python. They take
much longer to execute than Git and they feel slow compared to Git. The startup time of Python
contributes an important portion of the execution time.

Several years ago, I wrote a small script named `distro-info` which provides information about the
Debian/Ubuntu releases. This script is called in a bash completion for pbuilder-dist (from the
ubuntu-dev-tools package). An Ubuntu user experience a
[bash startup of 4 seconds](https://launchpad.net/bugs/796317) with cold cache due to the multiple
invocations of `distro-info`. This made me search a suitable programming language with a fast
startup time and I wrote this man page to measure the startup time of many programming languages.

This project consists of many hello world programs in different languages and an ugly Makefile that
compiles the programs and runs the benchmark. Each program is run 1000 times in a row (using a tiny
`run.c` program to minimize the overhead for the invocation):

```sh
time -f "%e" taskset -c 0 ./run 1000 $program
```

Usage
=====

Before running the benchmark, install all relevant compilers. On Debian/Ubuntu you can run
`make install` to install the compilers. Then start the benchmark by calling `make`:

```
$ make
Run on: Intel(R) Core(TM) i5-2400S CPU @ 2.50GHz | Ubuntu 17.10 | 2018-02-10
C (gcc 7.2.0):            0.26 ms
C++ (g++ 7.2.0):          0.79 ms
Cython (cython 0.25.2):   9.91 ms
Cython3 (cython3 0.25.2): 26.04 ms
D (gdc 7.2.0):            0.57 ms
Go (go go1.8.3):          0.41 ms
Go_GCC (gccgo 7.2.0):     98.26 ms
Haskell (ghc 8.0.2):      0.72 ms
Pascal (fpc 3.0.2):       0.08 ms
Rust (rustc 1.21.0):      0.51 ms
Bash 4.4.12(1):           0.71 ms
CShell 20110502:          3.26 ms
Lua 5.2.4:                0.63 ms
Perl 5.26.0:              0.94 ms
PHP 7.1.11:               8.71 ms
Python-S 2.7.14:          2.91 ms
Python 2.7.14:            9.43 ms
Python3-S 3.6.3:          9.31 ms
Python3 3.6.3:            25.84 ms
PyPy 5.8.0:               27.53 ms
Ruby 2.3.3p222:           32.43 ms
Shell (dash 0.5.8):       0.33 ms
ZShell 5.2:               1.57 ms
C# (mcs 4.6.2.0):         13.37 ms
Java (javac 1.8.0_151):   54.55 ms
Scala (scalac 2.11.8):    310.81 ms
```

```
$ make
Run on: Raspberry Pi 3 (arm64) | Debian GNU/Linux buster/sid | 2018-02-10
C (gcc 7.2.0):            2.19 ms
C++ (g++ 7.2.0):          8.24 ms
Cython (cython 0.26.1):   98.71 ms
Cython3 (cython3 0.26.1): 196.36 ms
Go (go go1.9.3):          4.10 ms
Go_GCC (gccgo 7.2.0):     898.30 ms
Haskell (ghc 8.0.2):      9.44 ms
Pascal (fpc 3.0.4):       0.66 ms
Rust (rustc 1.22.1):      4.42 ms
Bash 4.4.12(1):           7.31 ms
CShell 20110502:          10.98 ms
Lua 5.2.4:                6.23 ms
Perl 5.26.1:              8.78 ms
PHP 7.2.2:                98.03 ms
Python-S 2.7.14+:         32.77 ms
Python 2.7.14+:           91.85 ms
Python3-S 3.6.4:          110.02 ms
Python3 3.6.4:            197.79 ms
PyPy 5.8.0:               183.50 ms
Ruby 2.3.6p384:           421.53 ms
Shell (dash 0.5.8):       2.81 ms
ZShell 5.4.2:             11.04 ms
C# (mcs 4.6.2.0):         137.53 ms
Java (javac 1.8.0_151):   566.66 ms
Scala (scalac 2.11.8):    2989.72 ms
```

If you don't want to test all programming languages, edit `COMPILED_LANGS` and `INTERPRETED_LANGS`
in `Makefile` (and maybe edit the `all` target to not depend on the .exe and .class files).
Note: The Makefile should be replaced by something else that is simpler to read and can produce
nicer looking output.

Results
=======

| Language          | version               | Intel Core i5 2400S | Raspberry Pi 3 |
| ------------------|---------------------- | ------------------: | -------------: |
| Pascal (fpc)      | 3.0.2 / 3.0.4         |             0.08 ms |        0.66 ms |
| C (gcc)           | 7.2.0                 |             0.26 ms |        2.19 ms |
| Shell (dash)      | 0.5.8                 |             0.33 ms |        2.81 ms |
| Go (go)           | 1.8.3 / 1.9.3         |             0.41 ms |        4.10 ms |
| Rust (rustc)      | 1.21.0 / 1.22.1       |             0.51 ms |        4.42 ms |
| D (gdc)           | 7.2.0                 |             0.57 ms |                |
| Lua               | 5.2.4                 |             0.63 ms |        6.23 ms |
| Bash              | 4.4.12(1)             |             0.71 ms |        7.31 ms |
| C++ (g++)         | 7.2.0                 |             0.79 ms |        8.24 ms |
| Perl              | 5.26.0 / 5.26.1       |             0.94 ms |        8.78 ms |
| Haskell (ghc)     | 8.0.2                 |             0.72 ms |        9.44 ms |
| ZShell            | 5.2 / 5.4.2           |             1.57 ms |       11.04 ms |
| CShell            | 20110502              |             3.26 ms |       10.98 ms |
| Python (with -S)  | 2.7.14                |             2.91 ms |       32.77 ms |
| Python            | 2.7.14                |             9.43 ms |       91.85 ms |
| PHP               |  7.1.11 / 7.2.2       |             8.71 ms |       98.03 ms |
| Cython            | 0.25.2 / 0.26.1       |             9.91 ms |       98.71 ms |
| Python3 (with -S) | 3.6.3 / 3.6.4         |             9.31 ms |      110.02 ms |
| C# (mcs)          | 4.6.2.0               |            13.37 ms |      137.53 ms |
| PyPy              | 5.8.0                 |            27.53 ms |      183.50 ms |
| Cython3           | 0.25.2 / 0.26.1       |            26.04 ms |      196.36 ms |
| Python3           | 3.6.3 / 3.6.4         |            25.84 ms |      197.79 ms |
| Ruby              | 2.3.3p222 / 2.3.6p384 |            32.43 ms |      421.53 ms |
| Java (javac)      | 1.8.0_151             |            54.55 ms |      566.66 ms |
| Go (gccgo)        | 7.2.0                 |            98.26 ms |      898.30 ms |
| Scala (scalac)    | 2.11.8                |           310.81 ms |     2989.72 ms |

Evaluation
==========

I categorize the programming languages in four categories: fast, okay, slow, takes ages.

Fast
----

Fast startup times are below 1 ms on my desktop (Intel Core i5 2400S) and below 10 ms on slow
hardware (Raspberry Pi 3):

* Bash
* C
* C++
* D (gdc)
* Go (go)
* Haskell
* Lua
* Pascal
* Perl
* Rust
* Shell (dash)

Okay
----

Okayish startup times are between 1 and 5 ms on my desktop (Intel Core i5 2400S) and between
10 and 50 ms on slow hardware (Raspberry Pi 3):

* CShell
* Python 2 (with -S)
* ZShell

Slow
----

Slow startup times are between 5 and 50 ms on my desktop (Intel Core i5 2400S) and between
50 and 500 ms on slow hardware (Raspberry Pi 3):

* C# (mcs)
* Cython (Python 2)
* Cython3 (Python 3)
* PHP
* Python 2
* Python 3
* Python 3 (with -S)
* PyPy (Python 2)
* Ruby

Takes ages
----------

Some programming languages take ages to start up. The startup times are above 50 ms on my desktop
(Intel Core i5 2400S) and over 500 ms on slow hardware (Raspberry Pi 3):

* Java
* Go (gccgo)
* Scala
