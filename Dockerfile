# The ubuntu:latest tag points to the latest LTS, since that is the version recommended for general use
FROM ubuntu:latest

# Download link and installer script
ARG YED_DL=https://www.yworks.com/resources/yed/demo/
ARG YED_SH=yEd-3.24_with-JRE22_64-bit_setup.sh

# Arguments
ARG YED_UID
ARG YED_GID
ARG YED_CONTAINER_ENGINE
ARG YED_BASHRC
ARG YED_USER

# Home settings for user yed
ARG YED_HOME=/home/yed

# Update OS
RUN apt-get -y update
RUN apt-get -y upgrade

# Fix warnings
RUN apt-get -y install apt-utils # Fix debconf: delaying package configuration, since apt-utils is not installed
RUN apt-get -y install libcanberra-gtk-module libcanberra-gtk3-module # Fix "Gtk-Message: Failed to load module"
RUN apt-get -y install dbus-x11 # Fix "dconf-WARNING **: failed to commit changes to dconf: ..."

# Get dependencies
RUN apt-get -y install wget

# Create new user yed
RUN if [ "$YED_CONTAINER_ENGINE" = "docker" ]; then \
        if [ ! $(getent group ${YED_GID}) ]; then \
            groupadd -g "${YED_GID}" yed && useradd --create-home --no-log-init -u "${YED_UID}" -g "${YED_GID}" yed; \
        else \
            useradd --create-home --no-log-init yed; \
        fi \
    else \
        mkdir ${YED_HOME}; \
    fi

# Get yEd
USER ${YED_USER}
WORKDIR $YED_HOME
RUN wget $YED_DL$YED_SH -P $YED_HOME
RUN chmod 777 $YED_HOME/$YED_SH

# Modify .bashrc
RUN echo "" >> $YED_BASHRC
RUN echo "alias yed-install='exec $YED_HOME/$YED_SH &'" >> $YED_BASHRC
RUN echo "alias yed-run='yEd &'" >> $YED_BASHRC
RUN echo "export PATH=$PATH:$YED_HOME/yEd" >> $YED_BASHRC
RUN echo "function yed() { if ! [ -x yEd ]; then yed-install else yed-run fi }" >> $YED_BASHRC
RUN echo "yed" >> $YED_BASHRC
