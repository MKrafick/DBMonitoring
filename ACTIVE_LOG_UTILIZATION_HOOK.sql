-- Purpose: Returns a single value for DB2 active log utilization
--          Used as a hook into a monitoring system or quick hit view to see if active logs are near capacity
--
-- ACTIVE_LOG_UTILIZATION_HOOK.sql | May 16, 2017 | Version 1 |  M. Krafick | No warranty implied, use at your own risk.
--
-- Granularity: Low. Single value returned.
--
-- Metrics shown:
-- Single value (percentage) for DB2 active log utilization
--
-- Execution notes: 
-- Use -x flag to return only a value but not a header for homegrown/3rd party DB2 monitoring
--
-- ID will need the following authority: 
-- GRANT SELECT ON SYSIBMADM.MON_TRANSACTION_LOG_UTILIZATION TO <USER/GROUP/ROLE> <AUTH NAME>



-- SQL:
  	SELECT LOG_UTILIZATION_PERCENT					
	  FROM SYSIBMADM.MON_TRANSACTION_LOG_UTILIZATION;					