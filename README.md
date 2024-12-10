# docker-yed

Install and run yEd in a container. This container (Dockerfile) can run with Docker or Podman.

![Banner](res/banner.svg)

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/alexazon/docker-yed/docker-build.yml?label=build%20(docker))
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/alexazon/docker-yed/podman-build.yml?label=build%20(podman))
![GitHub](https://img.shields.io/github/license/alexazon/docker-yed)
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/alexazon/docker-yed)

# Table of Contents

- [Quick Start](#quick-start)
  * [Build and Start](#build-and-start)
  * [Workspace](#workspace)
  * [Bash Alias](#bash-alias)
    + [Default Workspace](#default-workspace)
    + [Custom Workspace](#custom-workspace)
  * [Installer Options](#installer-options)
- [FAQ and Common Problems](#faq-and-common-problems)
  * [What Is yEd?](#what-is-yed)
  * [Installation Loop](#installation-loop)
  * [Docker](#docker)
    + [Got Permission Denied](#got-permission-denied)
    + [Docker is Not Running](#docker-is-not-running)
    + [Other X11 and Wayland Problems](#other-x11-and-wayland-problems)
  * [Podman](podman)
    + [Authorization Required](#authorization-required)
    + [Access Files](#access-files)
  * [Container Management](#container-management)
    + [List All docker-yed Containers](#list-all-docker-yed-containers)
    + [Remove Container](#remove-container)
    + [Stop Container](#stop-container)

# Quick Start

## Build and Start

By default, the container will use Docker. Just run `make`, this will build and start the container (using Docker). If you want to use Podman, just run `make podman`.

After building the yEd installer should pop up. Accept the agreement and use the default values and paths. Use `yed` inside the container to install and/or start yEd, if yEd didn't start automatically.

Press `CTRL+D` or use `exit` to shut down the container.

## Workspace

- Inside the container: You can save your work in `/home/yed/workspace`
- Outside the container: You can access your work in `${GIT-PATH}/docker-yed/workspace`

You can specify your own custom workspace directory by passing WORKSPACE=$DIRECTORY as an argument.

Example: `make WORKSPACE=/opt`

## Bash Alias

Add one of these examples to your .bashrc (or elsewhere) to start the container and yEd easily.

### Default Workspace

#### Docker

```bash
alias yed='make -C ${GIT-PATH}/docker-yed'
```

#### Podman

```bash
alias yed='make podman -C ${GIT-PATH}/docker-yed'
```

### Custom Workspace

#### Docker

```bash
alias yed='make -C ${GIT-PATH}/docker-yed WORKSPACE=${OWN_WORKSPACE_PATH}'
```

#### Podman

```bash
alias yed='make podman -C ${GIT-PATH}/docker-yed WORKSPACE=${OWN_WORKSPACE_PATH}'
```

## Installer Options

To install yEd simply run `yed-install` inside the container, if the installer didn't pop up or you closed it.

Recommendation: Just leave the default values as they are:

- Agreement: `I accept the agreement` (this is not default)
- Destination directory: `/home/yed/yEd`
- Create symlinks: `/usr/local/bin`
- Create a desktop icon: `Yes` (don't care)
- Run yEd Graph Editor: `Yes` (don't care)

You can now run yEd directly from the installer or just run `yed-run` inside the container shell.

```bash
yed-install    # install yed
yed-run        # run yed
```

# FAQ and Common Problems

## What is yEd?

It's a cross-platform application (Linux, Windows, and Mac OS) that can be used to draw diagrams.

You can export diagrams as GIF, JPEG, PNG, EMF, BMP, PDF, EPS, and SVG.

- [Official yEd website](https://www.yworks.com/products/yed)
- [Gallery of user-created diagrams](https://www.yworks.com/products/yed/gallery)

## Installation Loop

You need to install yEd every time you run the container because the installer script doesn't provide a command line interface.

## Docker

### Got Permission Denied

Error:

```
Got permission denied while trying to connect to the Docker daemon socket at ...:
Post ...: dial ...: connect: permission denied
```

Solution (add your user to docker group):

```bash
sudo groupadd docker
sudo usermod -aG docker ${USER}
su -s ${USER}
```

### Docker is not running

Error:

```
ERROR: Cannot connect to the Docker daemon at unix:///var/run/docker.sock.
Is the docker daemon running?
```

Solution (start docker service):

```bash
sudo systemctl start docker
sudo systemctl enable docker    # optional, docker will now start automatically
```

### Other X11 and Wayland Problems

Please check this link: https://github.com/mviereck/x11docker

## Podman

### Authorization Required

Error:

```
Starting Installer ...
Authorization required, but no authorization protocol specified

Could not display the GUI. This application needs access to an X Server.
```

Solution:

```bash
xhost +local:root
xhost -local:root # optional, remove x server access after container usage
```

### Access Files

Error:

```
File can't be saved (inside yEd)
```

Solution:

```bash
chmod o+w workspace -R
```

## Container Management

### List All docker-yed Containers

#### Docker

```bash
docker images | grep docker-yed    # list containers, we only care about docker-yed container(s)
```

#### Podman

```bash
podman images | grep docker-yed    # list containers, we only care about docker-yed container(s)
```

### Remove Container

#### Docker

```bash
docker image rm docker-yed    # by name
docker image rm ${ID}         # by ID, alternative option
```

#### Podman

```bash
podman image rm docker-yed    # by name
podman image rm ${ID}         # by ID, alternative option
```

### Stop Container

#### Docker

```bash
docker container stop ${ID}
```

#### Podman

```bash
podman container stop ${ID}
```
