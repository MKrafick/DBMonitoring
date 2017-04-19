-- Purpose: Returns a Pass (0) or Fail (1) for a TABLESPACE STATE that could lock out work from an application or user.
--          Used as a hook into a monitoring system or quick hit view to see if tablespaces are normal
-- Granularity: Low. Pass or Fail only
--
-- Metrics shown:
-- Pass (0) or Fail (1) for a TABLESPACE STATE
--
-- Execution notes: 
-- Use -x flag to return only a value but not a header for homegrown/3rd party DB2 monitoring




-- SQL:
  	SELECT								
		  CASE								
		  WHEN TBSP_STATE IN ('NORMAL', 'BACKUP_IN_PROGRESS', 'LOAD_IN_PROGRESS', 'REORG_IN_PROGRESS' ) THEN '0'								
		    ELSE '1'								
		  END								
		FROM TABLE(MON_GET_TABLESPACE('',NULL)) AS T								
		GROUP BY TBSP_STATE ORDER BY TBSP_STATE DESC								
		FETCH FIRST 1 ROW ONLY;								