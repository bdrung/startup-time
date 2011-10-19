COMPILED_LANGS := C D Haskell
INTERPRETED_LANGS := Bash CShell Perl PHP Python Python3 Ruby Shell ZShell
Bash_EXT := bash
CShell_EXT := csh
Perl_EXT := pl
PHP_EXT := php
Python_EXT := py
Python3_EXT := py3
Ruby_EXT := rb
Shell_EXT := sh
ZShell_EXT := zsh

TIME := time -f "%e"
RUN := ./run.sh 100

define \n


endef

all: $(COMPILED_LANGS) HelloWorld.class hello-world.exe run
	$(foreach lang,$(COMPILED_LANGS),@printf "%-8s " $(lang): $(\n)@$(TIME) $(RUN) ./$(lang) > /dev/null$(\n))
	$(foreach lang,$(INTERPRETED_LANGS),@printf "%-8s " $(lang): $(\n)@$(TIME) $(RUN) ./hello-world.$($(lang)_EXT) > /dev/null$(\n))
	@printf "C#:      "
	@$(TIME) $(RUN) ./hello-world.exe > /dev/null
	@printf "Java:    "
	@$(TIME) $(RUN) java HelloWorld > /dev/null

install:
	sudo apt-get install gcc gdc ghc openjdk-6-jdk mono-gmcs bash csh php5-cli perl-base python python3 ruby zsh

C: hello-world.c
	gcc -Wall -Wextra -O3 -o $@ $^

run: run.c
	gcc -Wall -Wextra -O3 -o $@ $^

D: $(wildcard *.d)
	gdc -Wall -Wextra -O3 -o $@ $^

Haskell: $(wildcard *.hs)
	ghc -Wall -O3 -o $@ -main-is HelloWorld $^

HelloWorld.class: $(wildcard *.java)
	javac $^

hello-world.exe: $(wildcard *.cs)
	gmcs $^

clean:
	rm -f *.class *.exe *.hi *.o run $(COMPILED_LANGS)

.PHONY: all clean
