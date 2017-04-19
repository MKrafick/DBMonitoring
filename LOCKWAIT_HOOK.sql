-- Purpose: Pulls single value for number of lockwaits. 
--          Used as a hook into a monitoring system or quick hit view of current lock waitsfor a point in time.
-- Granularity: Low. Total number only without detail
--
-- Metrics shown:
-- Total Number of Lockwaits
--
-- Execution notes: 
-- Use -x flag to return only a value but not a header for homegrown/3rd party DB2 monitoring



-- SQL:
   SELECT COUNT(*) FROM TABLE (MON_GET_APPL_LOCKWAIT(NULL, -2));