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

all: $(COMPILED_LANGS) HelloWorld.class hello-world.exe run
	$(foreach lang,$(COMPILED_LANGS),@printf "%-8s " $(lang): $(\n)@$(TIME) $(RUN) ./$(lang) > /dev/null$(\n))
	$(foreach lang,$(INTERPRETED_LANGS),@printf "%-8s " $(lang): $(\n)@$(TIME) $(RUN) ./hello-world.$($(lang)_EXT) > /dev/null$(\n))
	@printf "C#:      "
	@$(TIME) $(RUN) ./hello-world.exe > /dev/null
	@printf "Java:    "
	@$(TIME) $(RUN) $(shell which java) HelloWorld > /dev/null

install:
	sudo apt-get install gcc gdc fp-compiler gccgo ghc openjdk-6-jdk mono-gmcs bash csh php5-cli perl-base python python3 ruby zsh

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

hello-world.exe: $(wildcard *.cs)
	gmcs $^

clean:
	rm -f *.class *.exe *.hi *.o run $(COMPILED_LANGS)

.PHONY: all clean
