#!/bin/ksh
## CHK_BKUP_HOOK.ksh | Aug 9, 2017 | Version 1 | M. Krafick | No warranty implied, use at your own risk.
##
## Purpose: Confirms X amount of backups are on disk and that at least one is less than X days old.
##          Returns pas or fail.
##
## Metrics shown:
## Pass (0) or Fail (1) for a backup file or age violation
##
## Execution notes:
## Make sure to swap out "@NumberOfBackupsToRetain@" and "@MaximumAgeOfBackup@" with the proper numerical value
## for backup retention and age.
##
## This also assumes your backup string begins with the DB name and ends in 001. Script may need to be adjusted
## for multiple part backups.
##
## The script only checks the specified directory, it will not check sub-directories. You should be able to
## adjust the "maxdepth" parameter to compensate. However, this is untested.
##
## Usage: ./CHK_BKUP_HOOK.ksh <dbname> </path/to/backups> <NumberDaysShouldRetain> <BackupMaxDaysOld>
##

## Variable List and Assignment
DBNAME=$1
BACKUP_DIR=$2
NUM_RETAIN=$3
DAYS_OLD=$4


## Confirm we have a newer backup and that we have multiple backup files held locally.
FILECOUNT=$(find $BACKUP_DIR  -maxdepth 1 -name "$DBNAME*001" | wc -l)
DAYCOUNT=$(find $BACKUP_DIR -maxdepth 1 -name "$DBNAME*001" -mtime -$DAYS_OLD | wc -l)

if [[ $FILECOUNT -lt $NUM_RETAIN || $DAYCOUNT -lt 1 ]];
then
  echo "1"
else
  echo "0"
fi