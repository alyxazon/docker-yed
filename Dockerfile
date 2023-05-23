# Ubuntu
FROM ubuntu:latest

# Download link and installer script
ARG YED_DL=https://www.yworks.com/resources/yed/demo/
ARG YED_SH=yEd-3.23.1_with-JRE15_64-bit_setup.sh

# Arguments
ARG YED_UID # see build function
ARG YED_GID # see build function

# Home settings for user yed
ARG BASHRC=/home/yed/.bashrc
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
RUN apt-get -y install openjdk-18-jre

# Create new user yed
RUN groupadd -g "${YED_GID}" yed && useradd --create-home --no-log-init -u "${YED_UID}" -g "${YED_GID}" yed
USER yed
WORKDIR $YED_HOME

# Get yEd
RUN wget $YED_DL$YED_SH -P $YED_HOME
RUN chmod 777 $YED_HOME/$YED_SH

# Modify .bashrc
RUN echo "" >> $BASHRC
RUN echo "alias yed-install='exec $YED_HOME/$YED_SH &'" >> $BASHRC
RUN echo "alias yed-run='yEd &'" >> $BASHRC
RUN echo "export PATH=$PATH:$YED_HOME/yEd" >> $BASHRC
RUN echo "function yed() { if ! [ -x yEd ]; then yed-install else yed-run fi }" >> $BASHRC
RUN echo "yed" >> $BASHRC
