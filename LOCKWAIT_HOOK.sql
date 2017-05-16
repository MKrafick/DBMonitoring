-- Purpose: Pulls single value for number of lockwaits. 
--          Used as a hook into a monitoring system or quick hit view of current lock waitsfor a point in time.
--
-- LOCKWAIT_HOOK.sql | May 16, 2017 | Version 1 |  M. Krafick | No warranty implied, use at your own risk.
--
-- Granularity: Low. Total number only without detail
--
-- Metrics shown:
-- Total Number of Lockwaits
--
-- Execution notes: 
-- Use -x flag to return only a value but not a header for homegrown/3rd party DB2 monitoring
--
-- ID will need the following authority: 
-- GRANT EXECUTE ON FUNCTION SYSPROC.MON_GET_APPL_LOCKWAIT TO <USER/GROUP/ROLE> <AUTH NAME>



-- SQL:
   SELECT COUNT(*) FROM TABLE (MON_GET_APPL_LOCKWAIT(NULL, -2));