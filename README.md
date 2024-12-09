# ISQ Bash Backups

ISQ Bash Backup is a shell script collection for Linux-Server Backup and Directory Syncing

## Description

There are two shell scripts:
- backup.sh

and

- sync.sh

Both scripts need an active .env-File (with needed configuration variables) to work properly, both can use the same .env-file

## Installation

cd to your backup working directory (e.g. "/usr/scripts" ) and clone the repo

```
cd /usr/scripts
git clone https://github.com/isq-portal/bash-backup.git
```

You should see a folder named "bash-backup" now. cd into it.

## Usage

After initial Installation, copy the file EXAMPLE.env to .env in same directory

```bash
cp Example.env .env
```

Edit the .env-File and adjust your configuration for your needs

```bash
nano .env
```

Note:
Both scripts need an environment-Variable of "BASH_BACKUP_WORKDIR" to be set before calling the script, 
to determine, where to get the .env file from to source it, e.g.:
```bash
$ BASH_BACKUP_WORKDIR=/usr/scripts/bash-backup ./backup.sh
```


### Configuration

There are several configuration variables:

- BACKUPNAME - string - name and filename of the backup
- BACKUP_MAX_AGE - integer - max age in days for the backup, older files will get deleted
- MYSQL - string/array - of database names to be dumped and backuped - selection of 'echo "SHOW DATABASES;" | mysql'
- BACKUPPATH - string - location/path to put the backup files
- BACKUPDIRECTORIES - string/array of directories to backup, without leading "/" to avoid tar-errors
- CONFIGFILES - string/array of files to backup, e.g. config-files in /etc


- RSYNCUSERNAME - rsync username, to connect with remote server containing backup files, should have a ssh-key to connect
- RSYNCHOSTNAME - hostname/ip-adress to connect via ssh/rsync, must have rsync daemon installed/running
- RSYNCSOURCEDIR - rsync source directory on remote server containing backup files (where to get the sync from)
- RSYNCTARGETDIR - rsync target directory on local server (where to put the sync files)

## Cronjobs

- activate cronjob via "crontab -e", e.g. every day 5 minutes after midnight
- the used script (backup.sh or sync.sh) needs the BASH_BACKUP_WORKDIR variable in environment before script call

example for backup.sh - every day 5 minutes after midnight
```bash
5 0 * * * BASH_BACKUP_WORKDIR=/usr/scripts/bash-backup /usr/scripts/bash-backup/backup.sh >/dev/null 2>&1
```

example for sync.sh - every day 20 minutes after midnight (backup.sh @ remote server should be finished)
```bash
30 0 * * * BASH_BACKUP_WORKDIR=/server/intern-adm/opt/bash-backup /server/intern-adm/opt/bash-backup/sync.sh >/dev/null 2>&1
```

## LICENSE
[MIT](https://choosealicense.com/licenses/mit/)