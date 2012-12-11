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

TIME := time -f "%e"
RUN := taskset -c 0 ./run 1000

define \n


endef

CFLAGS ?= -std=gnu99 -Wall -Wextra -Werror -O3
CPPFLAGS ?= -Wall -Wextra -Werror -O3
DFLAGS ?= -Wall -O3
GO_FLAGS ?= -O3
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
	lua5.1 \
	mono-gmcs \
	perl-base \
	php5-cli \
	python \
	python3 \
	ruby \
	scala \
	zsh \
	$(NULL)

run_lang = \
	@printf "%-8s " "$(1):" $(\n)\
	@$(TIME) $(RUN) $(2) 2>&1 > /dev/null | tr -d '\n'$(\n)\
	@printf " ms\n"

all: $(COMPILED_LANGS) hello-world.exe HelloWorld.class HelloWorldScala.class run
	$(foreach lang,$(COMPILED_LANGS),$(call run_lang,$(lang),./$(lang))$(\n))
	$(foreach lang,$(INTERPRETED_LANGS),$(call run_lang,$(lang),./hello-world.$($(lang)_EXT))$(\n))
	$(call run_lang,C#,./hello-world.exe)
	$(call run_lang,Java,$(shell which java) HelloWorld)
	$(call run_lang,Scala,$(shell which scala) HelloWorldScala)

install:
	sudo apt-get install $(PACKAGES)

C: hello-world.c
	gcc $(CFLAGS) -o $@ $^

run: run.c
	gcc $(CFLAGS) -o $@ $^

C++: hello-world.cpp
	g++ $(CPPFLAGS) -o $@ $^

D: $(wildcard *.d)
	gdc $(DFLAGS) -o $@ $^

Go: hello-world.go
	gccgo $(GO_FLAGS) -o $@ $^

Haskell: $(wildcard *.hs)
	ghc $(HASKELL_FLAGS) -o $@ -main-is HelloWorld $^

Pascal: hello-world.p
	fpc $(PASCAL_FLAGS) -o$@ $^

HelloWorld.class: $(wildcard *.java)
	javac $^

HelloWorldScala.class: $(wildcard *.scala)
	scalac $^

hello-world.exe: $(wildcard *.cs)
	gmcs $^

clean:
	rm -f *.class *.exe *.hi *.o run $(COMPILED_LANGS)

.PHONY: all clean
