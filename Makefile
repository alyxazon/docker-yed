CTL=docker-yed.sh

all: build run

build:
	./$(CTL) -b

run:
	./$(CTL) -r

test:
	@echo "Executing dry run ($(CTL)) ..."
	bash -n $(CTL) -b
	bash -n $(CTL) -r
	./$(CTL) -b
