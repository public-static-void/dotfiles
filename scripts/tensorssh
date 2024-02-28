#!/bin/bash

read -p 'username (format '0user'): ' username && read -p 'hostname (format 'pc123'): ' hostname && read -p 'local port (format '1234'): ' port && eval 'ssh -fN -J $username@rzssh1.informatik.uni-hamburg.de -L $port:localhost:6006 $username@$hostname.informatik.uni-hamburg.de'
