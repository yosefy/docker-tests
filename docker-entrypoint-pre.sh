#!/bin/bash

# Perfom all the needed preprocessing here...
confd -onetime -backend env

# Invoke the original entrypoint passing the command and arguments
exec  $@ 
