-- Purpose: Returns a single value for DB2 active log utilization
--          Used as a hook into a monitoring system or quick hit view to see if active logs are near capacity
-- Granularity: Low. Single value returned.
--
-- Metrics shown:
-- Single value (percentage) for DB2 active log utilization
--
-- Execution notes: 
-- Use -x flag to return only a value but not a header for homegrown/3rd party DB2 monitoring




-- SQL:
  	SELECT LOG_UTILIZATION_PERCENT					
	  FROM SYSIBMADM.MON_TRANSACTION_LOG_UTILIZATION;					