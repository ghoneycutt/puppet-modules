#!/bin/bash
#
# Garrett Honeycutt - code@garretthoneycutt.com - copyright 2013
#
# Licensed under Apache Software License v2.0
#
# This script is meant to work with librarian-puppet-simple. It is a simple
# wrapper script that validates the Puppetfile, initiates
# librarian-puppet-simple, and restarts the puppet master.
#
# https://github.com/bodepd/librarian-puppet-simple
# librarian-puppet-simple can be installed from source or with
# `gem install librarian-puppet-simple`
#
LIBRARIAN_DIR=/var/local/ghoneycutt-modules
LIBRARIAN_DIR_TMP=modules-tmp
PUPPETFILE=${LIBRARIAN_DIR}/Puppetfile
LIBRARIAN_PUPPET=librarian-puppet
LIBRARIAN_PUPPET_FLAGS='--verbose'
VALIDATION_CMD="ruby -c ${PUPPETFILE}"
CLEAN_CMD="${LIBRARIAN_PUPPET} clean ${LIBRARIAN_PUPPET_FLAGS}"
CLEAN_CMD_DIR_TMP="${CLEAN_CMD} --path=${LIBRARIAN_DIR_TMP}"
INSTALL_CMD="${LIBRARIAN_PUPPET} install ${LIBRARIAN_PUPPET_FLAGS} --path=${LIBRARIAN_DIR_TMP}"
SVC_RESTART_CMD='service httpd graceful'

if [ -d $LIBRARIAN_DIR ]; then
  cd $LIBRARIAN_DIR
else
  echo "LIBRARIAN_DIR (${LIBRARIAN_DIR}) does not exist."
  exit 1
fi

if [ ! -r $PUPPETFILE ]; then
  echo "PUPPETFILE (${PUPPETFILE}) does not exist or is not readable."
  exit 2
fi

$VALIDATION_CMD
if [ $? != 0 ]; then
  echo "Validating Puppetfile with (${VALIDATION_CMD}) did not exit successfully."
  exit 6
fi

$CLEAN_CMD_DIR_TMP
if [ $? != 0 ]; then
  echo "Cleaning the temporary library with (${CLEAN_CMD_DIR_TMP}) did not exit successfully."
  exit 3
fi

$INSTALL_CMD
if [ $? != 0 ]; then
  echo "Installing the library with (${INSTALL_CMD}) did not exit successfully."
  exit 4
fi

$CLEAN_CMD
if [ $? != 0 ]; then
  echo "Cleaning the library with (${CLEAN_CMD}) did not exit successfully."
  exit 7
fi

mv $LIBRARIAN_DIR_TMP modules
if [ $? != 0 ]; then
  echo "Rename of temporary download directory (${LIBRARIAN_DIR_TMP}) to modules failed."
  exit 8
fi

$SVC_RESTART_CMD
if [ $? != 0 ]; then
  echo "Restarting httpd did not exit successfully."
  exit 5
fi

exit 0
