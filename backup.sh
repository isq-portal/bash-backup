#!/bin/bash
#
#===========================================================================#
# ISQ Server Backup Script
#
# Author: Gerd Schirmer
#
# this script is created for usage in a daily cronjob backup environment
# needs a .env file with server environment settings:
#
# - MYSQL - Array of MySQL-Databases to dump & backup
#	e.g. MYSQL=("Database1" "Database2")
#
# - BACKUPPATH - String of relative backup path on server
#	e-g. BACKUPPATH="/srv/backups/"
#
#===========================================================================#

currentDate=$(date +"%Y%m%d_%H%M%S")
# excludeDatabases=( Database performance_schema information_schema )

echo "Checking for .env file"

# check if .env file exists
if [[ ! -f '/usr/scripts/.env' ]]; then
	echo "Error 1: .env file not found"
	return 1 2>/dev/null
	exit 1
fi

echo "OK! .env file found, sourcing..."

# source .env file with server environment variables
set -a
source /usr/scripts/.env
set +a

echo "OK! Checking BACKUPPATH variable"

# check if BACKUPPATH String Variable is set and not empty
if [ -z "${BACKUPPATH}" ]; then
	echo "ERROR 2: BACKUPPATH Variable is not set"
	return 1 2>/dev/null
	exit 1;
#	else echo "BACKUPPATH is set to: $BACKUPPATH";
fi

# check for BACKUPNAME String Variable
if [ -z "${BACKUPNAME}" ]; then
	echo "BACKUPNAME Variable is not set, default naming to backup_*"
	BACKUPNAME="backup"
fi

echo "BACKUPNAME is set to ${BACKUPNAME}..."

# change working directory to BACKUPPATH
cd "${BACKUPPATH}"

echo "OK! Checking BACKUPDIRECTORIES variable"

# check if BACKUPDIRECTORIES array is set and not empty
if [ -z "$BACKUPDIRECTORIES" ]; then
	echo "ERROR 3: BACKUPDIRECTORIES Variable is not set"
	exit 1;
fi

echo "OK! Checking mysqldump command available"

# check for command mysqldump available
if ! [ -x "$(command -v mysqldump)" ]; then
	errorecho "ERROR: command mysqldump not found!"
	errorecho "ERROR: No backup of database possible."
else

echo "OK! Archiving BACKUPDIRECTORIES"

# loop over backupdirectories and tar it to BACKUPPATH
for dirstr in ${BACKUPDIRECTORIES[@]}; do
	BASEDIRNAME=$(basename $dirstr)
#	echo "archiving dir: $dirstr base: $BASEDIRNAME"
	FILENAME="$BASEDIRNAME"
	FILENAME+="_$currentDate"
	tar cf "${BACKUPPATH}/$FILENAME.tar" -h -C / $dirstr
done

echo "OK! Dumping MYSQL Databases"
# loop over defined databases and dump it to backuppath
	for str in ${MYSQL[@]}; do
#		echo "Dumping Database $str"
		FileName="_dump_$currentDate"
		FileName+=".sql"
		mysqldump -u root $str > "$str$FileName" 
	done
fi


echo "OK! Compressing files to ${BACKUPNAME}_$currentDate.gz"

# compress *.tar files in backup path, remove after compressing
find . -name "*.tar" -o -name "*.sql" | tar czf "${BACKUPNAME}_$currentDate.gz" -T - --remove-files

echo "OK! Done."

ls
