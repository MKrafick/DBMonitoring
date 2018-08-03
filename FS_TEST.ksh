#!/bin/ksh
## FS_TEST.ksh | Aug 3, 2018 | Version 2 | Script: M. Krafick |  No warranty implied, use at your own risk.
##
## Purpose:
## Test DB filesystem ownership and group settings. If not predefined value for instance, e-mail alert.
##
## Version:
## V1 - May 18, 2018 - Initial Creation
## V2 - Aug  2, 2018 - Mail and logic repair
##
## Requirements:
## There are two total pieces for FS_TEST:
##  FS_TEST.ksh - Script doing the work
##  FS_TEST.cfg.ksh - Configuration file with variable assignments
##
## Notes:
## Swap out instance id and groups as necessary, configured for a two instance database.
## Swap out @TOKEN@ with string to search for in filsystem nomenclature.



## Variable Definition
## SERVER                Server Script is located
## MAIL_RECIP            E-mail alert should be sent to, multiple e-mail seperated by comma


## Variable Assignments - Variables not assigned at command line are defined in FS_TEST.cfg.ksh configuration file

CONFIG_FILE="FS_TEST.cfg.ksh"
. ./${CONFIG_FILE}

## Clean up any MSG files that may still be hanging around from abnormal run
if [ -f FILESYSTEM_ISSUE.msg ];
   then
   rm -f FILESYSTEM_ISSUE.msg
fi

## Pull Filesystem List for DB2 only
ls -ld @*FILESYSTEM_IN_BETWEEN_ASTERISKS*@ | awk '{print $1, $3, $4, $9}' | while read PERMISSION OWNER GROUP FILESYSTEM

## Compare ownership and groups
do
 if ! [[ "$OWNER" == "db2inst1" || "$OWNER" == "db2inst2" ]]
     then
       echo "Filesystem ($FILESYSTEM) owner ($OWNER) or group ($GROUP) is incorrect." >> FILESYSTEM_ISSUE.msg
 fi

 if ! [[ "$GROUP" == "db2iadm1" || "$GROUP" == "db2iadm2" ]]
     then
       echo "Filesystem ($FILESYSTEM) owner ($OWNER) or group ($GROUP) is incorrect." >> FILESYSTEM_ISSUE.msg
 fi
done

## Email if something is found
if [ -f FILESYSTEM_ISSUE.msg ];
   then
   mailx -s "Filesystem Ownership/Permission issue on $SERVER" $MAIL_RECIP < FILESYSTEM_ISSUE.msg
   rm FILESYSTEM_ISSUE.msg
fi