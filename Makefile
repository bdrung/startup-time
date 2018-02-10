COMPILED_LANGS := C C++ D Go Haskell Pascal
INTERPRETED_LANGS := Bash CShell Lua Perl PHP Python Python3 Ruby Shell ZShell

Bash_EXT := bash
CShell_EXT := csh
Lua_EXT := lua
Perl_EXT := pl
PHP_EXT := php
Python_EXT := py
Python3_EXT := py3
Ruby_EXT := rb
Shell_EXT := sh
ZShell_EXT := zsh

C_COMPILER := gcc
C++_COMPILER := g++
Csharp_COMPILER := mcs
MONO := $(shell which mono)
D_COMPILER := gdc
Go_COMPILER := gccgo
Haskell_COMPILER := ghc
Java_COMPILER := javac
Pascal_COMPILER := fpc
Scala_COMPILER := scalac

Bash_VERSION = $(shell bash --version | head -n 1 | cut -d " " -f 4 | sed 's/-release$$//')
C_VERSION = $(shell $(C_COMPILER) --version | head -n 1 | cut -d " " -f 4)
C++_VERSION = $(shell $(C++_COMPILER) --version | head -n 1 | cut -d " " -f 4)
Csharp_VERSION = $(shell $(Csharp_COMPILER) --version | head -n 1 | cut -d " " -f 5)
CShell_VERSION = $(shell dpkg-query --showformat='$${Version}' --show csh | sed 's/-.*$$//')
D_VERSION = $(shell $(D_COMPILER) --version | head -n 1 | cut -d " " -f 4)
Go_VERSION = $(shell $(Go_COMPILER) --version | head -n 1 | cut -d " " -f 4)
Haskell_VERSION = $(shell $(Haskell_COMPILER) --version | head -n 1 | cut -d " " -f 8)
Lua_VERSION = $(shell lua -v 2>&1 | head -n 1 | cut -d " " -f 2)
Java_VERSION = $(shell $(Java_COMPILER) -version 2>&1 | head -n 1 | cut -d " " -f 2)
Pascal_VERSION = $(shell $(Pascal_COMPILER) -h | head -n 1 | cut -d " " -f 5)
Perl_VERSION = $(shell perl --version | grep '.' | head -n 1 | sed 's/.*(v\(.*\)).*/\1/')
PHP_VERSION = $(shell php --version | head -n 1 | cut -d " " -f 2)
Python_VERSION = $(shell python --version 2>&1 | head -n 1 | cut -d " " -f 2)
Python3_VERSION = $(shell python3 --version 2>&1 | head -n 1 | cut -d " " -f 2)
Ruby_VERSION = $(shell ruby --version | head -n 1 | cut -d " " -f 2)
Scala_VERSION = $(shell $(Scala_COMPILER) -version 2>&1 | head -n 1 | cut -d " " -f 4)
Shell_VERSION = $(shell printf "(%s %s)" $(shell readlink /bin/sh) $(shell dpkg-query --showformat='$${Version}' --show $(shell readlink /bin/sh) | sed 's/-.*$$//'))
ZShell_VERSION = $(shell zsh --version | head -n 1 | cut -d " " -f 2)

TIME := time -f "%e"
RUN := taskset -c 0 ./run 1000

define \n


endef

ifeq ($(shell id -u),0)
ROOT_CMD :=
else
ROOT_CMD := sudo
endif

CFLAGS ?= -std=gnu99 -Wall -Wextra -Werror -O3
CPPFLAGS ?= -Wall -Wextra -Werror -O3
DFLAGS ?= -Wall -O3
GO_FLAGS ?= -g -O3
HASKELL_FLAGS ?= -Wall -O3
PASCAL_FLAGS ?= -O3

PACKAGES := \
	bash \
	csh \
	default-jdk \
	fp-compiler \
	gcc \
	gccgo \
	gdc \
	ghc \
	lua5.2 \
	mono-mcs \
	perl-base \
	php5-cli \
	python \
	python3 \
	ruby \
	scala \
	zsh \
	$(NULL)

run_lang = \
	@printf "%-22s " "$(1):" $(\n)\
	@$(TIME) $(RUN) $(2) 2>&1 > /dev/null | tr -d '\n'$(\n)\
	@printf " ms\n"

all: $(COMPILED_LANGS) hello-world.exe HelloWorld.class HelloWorldScala.class run
	$(foreach lang,$(COMPILED_LANGS),$(call run_lang,$(lang) ($($(lang)_COMPILER) $($(lang)_VERSION)),./$(lang))$(\n))
	$(foreach lang,$(INTERPRETED_LANGS),$(call run_lang,$(lang) $($(lang)_VERSION),./hello-world.$($(lang)_EXT))$(\n))
	$(call run_lang,C# ($(Csharp_COMPILER) $(Csharp_VERSION)),$(MONO) ./hello-world.exe)
	$(call run_lang,Java ($(Java_COMPILER) $(Java_VERSION)),$(shell which java) HelloWorld)
	$(call run_lang,Scala ($(Scala_COMPILER) $(Scala_VERSION)),$(shell which scala) HelloWorldScala)

install:
	$(ROOT_CMD) apt-get install $(PACKAGES)

C: hello-world.c
	$(C_COMPILER) $(CFLAGS) -o $@ $^

run: run.c
	$(C_COMPILER) $(CFLAGS) -o $@ $^

C++: hello-world.cpp
	$(C++_COMPILER) $(CPPFLAGS) -o $@ $^

D: $(wildcard *.d)
	$(D_COMPILER) $(DFLAGS) -o $@ $^

Go: hello-world.go
	$(Go_COMPILER) $(GO_FLAGS) -o $@ $^

Haskell: $(wildcard *.hs)
	$(Haskell_COMPILER) $(HASKELL_FLAGS) -o $@ -main-is HelloWorld $^

Pascal: hello-world.p
	$(Pascal_COMPILER) $(PASCAL_FLAGS) -o$@ $^

HelloWorld.class: $(wildcard *.java)
	$(Java_COMPILER) $^

HelloWorldScala.class: $(wildcard *.scala)
	$(Scala_COMPILER) $^

hello-world.exe: $(wildcard *.cs)
	$(Csharp_COMPILER) $^

clean:
	rm -f *.class *.exe *.hi *.o run $(COMPILED_LANGS)

.PHONY: all clean
