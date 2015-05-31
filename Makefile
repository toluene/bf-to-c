CC=swipl
FLAGS=-nodebug -g true -O -q --toplevel=quiet --stand_alone=true

all: main.pl
	echo "+" | $(CC) $(FLAGS) -o mainbftoc -c main.pl >> /dev/null

install: mainbftoc
	cp mainbftoc /usr/bin/mainbftoc
	cp bftoc /usr/bin/bftoc
