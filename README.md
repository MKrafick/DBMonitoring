# DBMonitoring
Monitoring hooks for homegrown monitoring scripts and 3rd party monitoring tools.

### Disclaimer:
An advanced scripter or SQL writer I am not. Use these at your own risk.

### Purpose:
The following SQL (or script) were written to act as a hook into a 3rd party monitoring tool. These should capture some of the basics needed to monitor database health in conjunction with server level metrics. It is assumed you have the ability to watch server level metrics from your tool (CPU, Memory, Disk Utilization, etc).

### Notes:
These were specifically designed to take advantage of the newer MON_GET functions when possible. MON_GET is very lightweight compared to the more common and depricated database snapshot tables. Matter of fact, if you look at many DB2 plug ins for 3rd party tools you will see they probably hit deprecated tables.

Deadlocks MUST be a before and after comparison. Selecting a deadlock count over and over will give you false positives. (Again, check out your DB2 plugin). To compare counts you will need to create a small table. See notes in DEADLOCK_HOOK.ksh.

### Available SQL and Scripts:

*ACTIVE_APP_CONNECTION_HOOK.sql*

Returns a single value for DB2 active log utilization


*ACTIVE_LOG_UTILIZATION_HOOK.sql*

Returns a single value for DB2 active log utilization


*BAD_TABLESPACE_HOOK.sql*

Returns a Pass (0) or Fail (1) for a TABLESPACE STATE that could lock out work from an application.


*DEADLOCK_HOOK.ksh*

Returns a deadlock count based on a prvious and current deadlock count.


*HADR_CONGESTION_HOOK.sql*

Returns a Pass (0) or Fail (1) for HADR congestion


*HADR_DISCONNECT_HOOK.sql*

Returns a Pass (0) or Fail (1) for HADR disconnect


*LOCKWAIT_HOOK.sql*

Pulls single value for number of lockwaits. 
