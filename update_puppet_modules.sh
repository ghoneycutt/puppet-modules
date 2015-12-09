#!/bin/bash
#
# Garrett Honeycutt - code@garretthoneycutt.com - copyright 2013-2015
#
# Licensed under Apache Software License v2.0
#
# This script is meant to work with librarian-puppet-simple. It is a simple
# wrapper script that validates the Puppetfile, initiates
# librarian-puppet-simple, and restarts the puppet master.
#
# You may optionally pass the argument 'https' which will invoke sed to replace
# 'git:' with 'https:' before running the validation and install and after will
# run revert the Puppetfile using `git checkout -- Puppetfile` so that you are
# back in a state where `git pull` will work. You may also pass the argument
# 'git' which does the same thing, but ensures that the git protocol is used.
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
REVERT_SCRIPT="git checkout -- Puppetfile"

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

if [ $# -eq 1 ]; then
  if [ $1 == 'https' ]; then
    sed -i $PUPPETFILE -e 's/git:/https:/'
    if [ $? != 0 ]; then
      echo "Search and replace command exited non-zero."
      exit 9
    fi
  fi
fi

if [ $# -eq 1 ]; then
  if [ $1 == 'https' ]; then
    sed -i $PUPPETFILE -e 's/https:/git:/'
    if [ $? != 0 ]; then
      echo "Search and replace command exited non-zero."
      exit 9
    fi
  fi
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

if [ $# -eq 1 ]; then
  if [ $1 == 'https' ]; then
    $REVERT_SCRIPT
    if [ $? != 0 ]; then
      echo "Reverting the script with (${REVERT_SCRIPT}) exited non-zero."
      exit 10
    fi
  fi
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
