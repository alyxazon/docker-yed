# Optional arguments
WORKSPACE ?= $(shell pwd)/workspace

# Internal settings
CTL := docker-yed.sh

# Targets
all: build run

build:
	@echo "Building container ..."
	@./$(CTL) -b -w $(WORKSPACE)

run:
	@echo "Running container ..."
	@./$(CTL) -r -w $(WORKSPACE)

test:
	@echo "Executing dry run ($(CTL)) ..."
	bash -n $(CTL) -b -w $(WORKSPACE)
	bash -n $(CTL) -r -w $(WORKSPACE)
	@echo "Building container ..."
	./$(CTL) -b -w $(WORKSPACE)
