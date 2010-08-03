#!/bin/bash
# 
# checks that puppet resource can change device eth0 to up.
# this will fail til Bug #2211 is fixed
set -e
set -u

. local_setup.sh

# Set eth0 state down (if its not already)
echo 'ip link set eth0 down'

# Puppet will set eth0 up
$BIN/puppet resource network_interface eth0 state="up"

# Test to see if eth0 is up
echo 'ip link show dev eth0 | grep UP'

