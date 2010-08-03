#!/bin/bash
# 
# checks that puppet resource can change device eth0 to down.

set -e
set -u

. local_setup.sh

# Set eth0 state up (if its not already)
echo 'ip link set eth0 up'

# Puppet will set eth0 down
$BIN/puppet resource network_interface eth0 state="down"

# Test to see if eth0 is down
echo 'ip link show dev eth0 | grep DOWN'


