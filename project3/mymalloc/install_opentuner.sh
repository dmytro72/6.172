#!/usr/bin/env bash

################################################################################
# Documentation
#
# Installs the OpenTuner Framework. This script is idempotent.
#
# To run this script on AWS machines:
# ./install_opentuner.sh
#
# The install process takes ~10 minutes (there are a lot of python packages
# that need to be compiled)


################################################################################
# install pip if necessary
! dpkg -s python-pip >/dev/null && sudo apt-get install python-pip

# Do nothing if opentuner is already installed.
if [ "$(pip show opentuner)" == "" ]; then
  # Install necessary apt packages (removing these breaks installation).
  sudo apt-get -y install pkg-config g++ python-dev libsqlite3-dev libpng-dev libfreetype6-dev

  pip install opentuner --user

  # These packages are listed as dependencies, but are either already
  # installed on AWS or have been observed to not be necessary.
  #sudo apt-get -y install sqlite3 gnuplot
  echo "OpenTuner installed successfully!"
else
  echo "OpenTuner already installed!"
fi
