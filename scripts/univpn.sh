#!/bin/bash

read -p 'username (format '0user'): ' username && eval 'sudo sshuttle -r $username@rzssh1.informatik.uni-hamburg.de 134.100.0.0/16 -x 134.100.9.63'
