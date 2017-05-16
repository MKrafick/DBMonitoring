-- Purpose: Pulls single value for number of non-idle (active) application connections. 
--          Used as a hook into a monitoring system or quick hit view of current number of applications in use for a point in time.
--
-- ACTIVE_APP_APPLICATION_HOOK.sql | May 16, 2017 | Version 1 |  M. Krafick | No warranty implied, use at your own risk.
--
-- Granularity: Low. Total number only without detail
--
-- Metrics shown:
-- Total Number of application connections NOT IN waiting status
-- This can be more robust with more detailed use of WORKLOAD_OCCURRENCE_STATE but is meant to give a high level count.
--
-- Execution notes: 
-- Use -x flag to return only a value but not a header for homegrown/3rd party DB2 monitoring
--
-- ID will need the following authority: 
-- GRANT EXECUTE ON FUNCTION SYSPROC.MON_GET_CONNECTION TO <USER/GROUP/ROLE> <AUTH NAME>


-- SQL:
	 SELECT COUNT(*) FROM TABLE(MON_GET_CONNECTION(NULL,-1)) AS T WHERE WORKLOAD_OCCURRENCE_STATE NOT IN ('UOWWAIT')