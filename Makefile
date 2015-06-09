CC=swipl
FLAGS=-nodebug -g true -O -q --toplevel=quiet --stand_alone=true

all: main.pl
	echo "+" | $(CC) $(FLAGS) -o mainbftoc -c main.pl >> /dev/null

install: mainbftoc
	install mainbftoc /usr/bin/mainbftoc
	install bftoc /usr/bin/bftoc
	install bfc /usr/bin/bfc

clean:
	rm mainbftoc
