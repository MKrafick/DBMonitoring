#!/bin/ksh
## FS_TEST.cfg.ksh | May 30, 2018 | Version 1 | Script: M. Krafick |  No warranty implied, use at your own risk.
##
## Purpose:
## This is a configuration file supplying variable assignments for the FS_TEST.ksh script.
##
## Requirements:
## There are two total pieces for FS_TEST:
##  FS_TEST.ksh - Script doing the work
##  FS_TEST.cfg.ksh - Configuration file with variable assignments
##
## Notes:
## Swap out @TOKEN@ under Variable Assignments for each variable.
##
## Revisions:
##    May 30, 2018 - V1 - Initial Creation

## Variable Definition
## SERVER                Server Script is located
## MAIL_RECIP            E-mail alert should be sent to, multiple e-mail seperated by comma

SERVER=$(hostname)
MAIL_RECIP=@EMAIL1@, @EMAIL2@