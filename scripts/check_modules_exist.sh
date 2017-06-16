#!/bin/bash

BROKEN=0

modules=$(grep ^mod Puppetfile | awk -F \' '{print $2}')

for module in $modules
do
  if [ ! -d modules/${module} ]; then
    echo -e "missing - ${module}"
    BROKEN=1
  fi
done

if [ $BROKEN -eq 1 ]; then
  exit 1
else
  exit 0
fi
