# Optional arguments
WORKSPACE ?= $(shell pwd)/workspace

# Internal settings
NAME := docker-yed
CTL := $(NAME).sh

# Targets
all: docker

test: docker-test podman-test

list: docker-list podman-list

docker: docker-build docker-run

docker-build:
	@echo "Building container (using Docker) ..."
	@./$(CTL) -b -w $(WORKSPACE)

docker-run:
	@echo "Running container (using Docker) ..."
	@./$(CTL) -r -w $(WORKSPACE)

docker-list:
	@echo "Docker images:"
	@docker images | grep $(NAME)

docker-clean:
	docker image rm $(NAME)

docker-test:
	@echo "Executing dry run ($(CTL)) (using Docker) ..."
	bash -n $(CTL) -b -w $(WORKSPACE)
	bash -n $(CTL) -r -w $(WORKSPACE)
	@echo "Building container ..."
	./$(CTL) -b -w $(WORKSPACE)

podman: podman-build podman-run

podman-build:
	@echo "Building container (using Podman) ..."
	@./$(CTL) -b -p -w $(WORKSPACE)

podman-run:
	@echo "Running container (using Podman) ..."
	@./$(CTL) -r -p -w $(WORKSPACE)

podman-list:
	@echo "Podman images:"
	@podman images | grep $(NAME)

podman-clean:
	podman rmi $(NAME)

podman-test:
	@echo "Executing dry run ($(CTL)) (using Podman) ..."
	bash -n $(CTL) -b -p -w $(WORKSPACE)
	bash -n $(CTL) -r -p -w $(WORKSPACE)
	@echo "Building container ..."
	./$(CTL) -b -p -w $(WORKSPACE)
