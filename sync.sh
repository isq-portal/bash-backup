#!/bin/bash
#
#===========================================================================#
# ISQ Server Sync Script
#
# Author: Gerd Schirmer
#
# this script is created for usage in a daily cronjob backup environment
# needs a .env file with server environment settings:
#
#
#
#
#===========================================================================#


# check BASH_BACKUP_WORKDIR variable (must be set in crontab before executing
if [ -z "${BASH_BACKUP_WORKDIR}" ]; then
	echo "ERROR 0: BASH_BACKUP_WORKDIR Variable is not set"
	return 1 2>/dev/null
	exit 1;
else echo "BASH_BACKUP_WORKDIR is set to: $BASH_BACKUP_WORKDIR";
fi


echo "Checking for .env file"

# cd into BACH_BACKUP_WORKDIR
cd "${BASH_BACKUP_WORKDIR}"

# check if .env file exists
if [[ ! -f '.env' ]]; then
	echo "Error 1: .env file not found"
	return 1 2>/dev/null
	exit 1
fi


echo "OK! .env file found, sourcing..."

# source .env file with server environment variables
set -a
source .env
set +a

echo "OK! Checking RSYNCUSERNAME variable"

# check if RSYNCUSERNAME String Variable is set and not empty
if [ -z "${RSYNCUSERNAME}" ]; then
	echo "ERROR 2: RSYNCUSERNAME Variable is not set"
	return 1 2>/dev/null
	exit 1;
else echo "RSYNCUSERNAME is set to: $RSYNCUSERNAME";
fi

echo "OK! Checking RSYNCHOSTNAME variable"

# check if RSYNCHOSTNAME String Variable is set and not empty
if [ -z "${RSYNCHOSTNAME}" ]; then
	echo "ERROR 2: RSYNCHOSTNAME Variable is not set"
	return 1 2>/dev/null
	exit 1;
else echo "RSYNCHOSTNAME is set to: $RSYNCHOSTNAME";
fi

echo "OK! Checking RSYNCSOURCEDIR variable"

# check if RSYNCSOURCEDIR String Variable is set and not empty
if [ -z "${RSYNCSOURCEDIR}" ]; then
	echo "ERROR 2: RSYNCSOURCEDIR Variable is not set"
	return 1 2>/dev/null
	exit 1;
else echo "RSYNCSOURCEDIR is set to: $RSYNCSOURCEDIR";
fi

echo "OK! Checking RSYNCTARGETDIR variable"

# check if RSYNCTARGETDIR String Variable is set and not empty
if [ -z "${RSYNCTARGETDIR}" ]; then
	echo "ERROR 2: RSYNCTARGETDIR Variable is not set"
	return 1 2>/dev/null
	exit 1;
else echo "RSYNCTARGETDIR is set to: $RSYNCTARGETDIR";
fi

### concatenate rsync command string
# rsync -avz -e ssh --delete ${RSYNCUSERNAME}@${RSYNCHOSTNAME}:${RSYNCSOURCEDIR} ${RSYNCTARGETDIR}
rsynccommand="rsync -avz -e ssh --delete "
rsynccommand+="${RSYNCUSERNAME}"
rsynccommand+="@${RSYNCHOSTNAME}"
rsynccommand+=":${RSYNCSOURCEDIR} "
rsynccommand+="${RSYNCTARGETDIR}"

eval "$rsynccommand"

echo "OK! Done."

ls -l "${RSYNCTARGETDIR}"
