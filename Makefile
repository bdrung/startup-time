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
RUN := ./run 100

define \n


endef

PACKAGES := \
	bash \
	csh \
	fp-compiler \
	gcc \
	gccgo \
	gdc \
	ghc \
	lua5.1 \
	mono-gmcs \
	openjdk-6-jdk \
	perl-base \
	php5-cli \
	python \
	python3 \
	ruby \
	scala \
	zsh \
	$(NULL)

all: $(COMPILED_LANGS) hello-world.exe HelloWorld.class HelloWorldScala.class run
	$(foreach lang,$(COMPILED_LANGS),@printf "%-8s " $(lang): $(\n)@$(TIME) $(RUN) ./$(lang) > /dev/null$(\n))
	$(foreach lang,$(INTERPRETED_LANGS),@printf "%-8s " $(lang): $(\n)@$(TIME) $(RUN) ./hello-world.$($(lang)_EXT) > /dev/null$(\n))
	@printf "C#:      "
	@$(TIME) $(RUN) ./hello-world.exe > /dev/null
	@printf "Java:    "
	@$(TIME) $(RUN) $(shell which java) HelloWorld > /dev/null
	@printf "Scala:   "
	@$(TIME) $(RUN) $(shell which scala) HelloWorldScala > /dev/null

install:
	sudo apt-get install $(PACKAGES)

C: hello-world.c
	gcc -std=c99 -Wall -Wextra -Werror -O3 -o $@ $^

run: run.c
	gcc -std=gnu99 -Wall -Wextra -Werror -O3 -o $@ $^

C++: hello-world.cpp
	g++ -Wall -Wextra -Werror -O3 -o $@ $^

D: $(wildcard *.d)
	gdc -Wall -O3 -o $@ $^

Go: hello-world.go
	gccgo -O3 -o $@ $^

Haskell: $(wildcard *.hs)
	ghc -Wall -O3 -o $@ -main-is HelloWorld $^

Pascal: hello-world.p
	fpc -O3 -o$@ $^

HelloWorld.class: $(wildcard *.java)
	javac $^

HelloWorldScala.class: $(wildcard *.scala)
	scalac $^

hello-world.exe: $(wildcard *.cs)
	gmcs $^

clean:
	rm -f *.class *.exe *.hi *.o run $(COMPILED_LANGS)

.PHONY: all clean
