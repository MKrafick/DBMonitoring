#!/bin/ksh
## DEADLOCK_HOOK.ksh  | Version 1 | Mike Krafick
##
## Purpose: Returns a deadlock count based on a prvious and current deadlock count.
##          Used as a hook into a monitoring system or quick hit view of deadlocks between two runs
## Granularity: Low. Total number only without detail
##
## Metrics shown:
## Number Deadlocks between two points in time.
##
## Execution notes:
## Execute with DB2 Instance ID, or monitoring ID with SYSMON access
## Script needs a place to write a file that us updated each run. Default is /tmp. Confirm executing ID has R/W access to this filesystem.
## The DB should be EXPLICITLY activated or this script could fail if there are zero connections and the DB deactivates itself as a result.
##     ex: db2 "activate database <dbname>"
##
## Usage: DEADLOCK_HOOK.ksh <dbname>

############ Variable Assignments and File Initialization ##########
SCRIPT_PATH=/tmp
DB_NAME=$1


if [ ! -f /$SCRIPT_PATH/LATEST_DEAD_COUNT_FILE.OUT ];
 then
   echo "0" > /$SCRIPT_PATH/LATEST_DEAD_COUNT_FILE.OUT ## Seed initial comparison file if it doesn't exist
fi



########## Main Script Body ##########

## Pull previous Deadlock Count and Current Deadlock Count
db2 connect to $DB_NAME > /dev/null

   PREV_DEAD_COUNT=$( cat /$SCRIPT_PATH/LATEST_DEAD_COUNT_FILE.OUT )
   CUR_DEAD_COUNT=$(db2 -x "SELECT sum(DEADLOCKS) FROM TABLE(MON_GET_WORKLOAD(NULL,-1)) AS T")

db2 terminate > /dev/null


## Main Logic:
## If current deadlock count is more that previously knownthen calculate difference, echo it, and update comparison file
## If current deadlock count is less than previously known then DB was bounced or monitors reset. Set new value as metric to compare to in future runs
## If current deadlock count is equal to previous run then report no change
if [[ $CUR_DEAD_COUNT -gt $PREV_DEAD_COUNT ]];then
  NEW_DEAD_COUNT=$(($CUR_DEAD_COUNT-$PREV_DEAD_COUNT))
  echo $NEW_DEAD_COUNT  ## Reports variance in new and old deadlocks to monitoring tool
  echo $CUR_DEAD_COUNT > /$SCRIPT_PATH/LATEST_DEAD_COUNT_FILE.OUT
elif [[ $CUR_DEAD_COUNT -lt $PREV_DEAD_COUNT ]];then
  echo $CUR_DEAD_COUNT  ## Reports latest (lower) deadlock count since monitors were reset
  echo $CUR_DEAD_COUNT > /$SCRIPT_PATH/LATEST_DEAD_COUNT_FILE.OUT
 else
  echo "0" ## Reports no change of value to monitoring tool
fi