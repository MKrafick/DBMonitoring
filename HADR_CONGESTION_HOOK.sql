-- Purpose: Returns a Pass (0) or Fail (1) for HADR congestion
--          Used as a hook into a monitoring system or quick hit view to see if HADR in a congested state
-- Granularity: Low. Single value returned.
--
-- Metrics shown:
-- Pass (0) or Fail (1) for a HADR Congested State
--
-- Execution notes: 
-- Use -x flag to return only a value but not a header for homegrown/3rd party DB2 monitoring
-- Execute against primary server of a HADR pair.




-- SQL:
		SELECT					
		  CASE					
		  WHEN HADR_STATE='CONGESTED'  THEN '1'					
		    ELSE '0'					
		  END					
		FROM TABLE(MON_GET_HADR(NULL))					
		GROUP BY HADR_STATE ORDER BY HADR_STATE ASC					
		FETCH FIRST 1 ROW ONLY;					