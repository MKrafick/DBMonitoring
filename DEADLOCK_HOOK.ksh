#!/bin/ksh
## DEADLOCK_HOOK.ksh | May 19, 2017 | Version 2 |  M. Krafick | No warranty implied, use at your own risk.
##
## Purpose: Returns a deadlock count based on a prvious and current deadlock count.
##          Used as a hook into a monitoring system or quick hit view of deadlocks between two runs
##
## Granularity: Low. Total number only without detail
##
## Metrics shown:
## Number Deadlocks between two points in time.
##
## Execution notes:
##   This KSH is dependant on a new table being created and initially seeded with data, please run DEADLOCK_HOOK_PREREQ.sql before using this script.
##   Execute with DB2 Instance ID, monitoring ID with SYSMON access and EXECUTE on a specific function listed below.
##   Script needs a place to write a file that us updated each run. Default is /tmp. Confirm executing ID has R/W access to this filesystem.
##   The DB should be EXPLICITLY activated or this script could fail if there are zero connections and the DB deactivates itself as a result.
##     ex: db2 "activate database <dbname>"
##
##   Executing ID will need the following authority (which should have been granted in DEADLOCK_HOOK_PREREQ.sql):
##   GRANT EXECUTE ON FUNCTION SYSPROC.MON_GET_WORKLOAD TO <USER/GROUP/ROLE> <AUTH NAME>
##
## Usage: DEADLOCK_HOOK.ksh <dbname>

############ Variable Assignments and File Initialization ##########
DB_NAME=$1


########## Main Script Body ##########

## Pull previous Deadlock Count and Current Deadlock Count
db2 connect to $DB_NAME > /dev/null

   PREV_DEAD_COUNT=$( db2 -x "SELECT CURRENT_COUNT FROM DBAMON.DBA_DEADLOCK_COUNTER WHERE DEADLOCK_TIME IN (SELECT MAX(DEADLOCK_TIME) FROM DBAMON.DBA_DEADLOCK_COUNTER)" )
   CUR_DEAD_COUNT=$(db2 -x "SELECT sum(DEADLOCKS) FROM TABLE(MON_GET_WORKLOAD(NULL,-1)) AS T")



## Main Logic:
## If current deadlock count is more that previously knownthen calculate difference, echo it, and update comparison file
## If current deadlock count is less than previously known then DB was bounced or monitors reset. Set new value as metric to compare to in future runs
## If current deadlock count is equal to previous run then report no change
if [[ $CUR_DEAD_COUNT -gt $PREV_DEAD_COUNT ]];then
  NEW_DEAD_COUNT=$(($CUR_DEAD_COUNT-$PREV_DEAD_COUNT))
  echo $NEW_DEAD_COUNT  ## Reports variance in new and old deadlocks to monitoring tool
  db2 "INSERT INTO DBAMON.DBA_DEADLOCK_COUNTER (CURRENT_COUNT) VALUES ($CUR_DEAD_COUNT)" > /dev/null
elif [[ $CUR_DEAD_COUNT -lt $PREV_DEAD_COUNT ]];then
  echo $CUR_DEAD_COUNT  ## Reports latest (lower) deadlock count since monitors were reset
  db2 "INSERT INTO DBAMON.DBA_DEADLOCK_COUNTER (CURRENT_COUNT) VALUES ($CUR_DEAD_COUNT)" > /dev/null
 else
  echo "0" ## Reports no change of value to monitoring tool
fi


db2 terminate > /dev/null