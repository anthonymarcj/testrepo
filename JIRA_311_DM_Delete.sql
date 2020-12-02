----------------------------------------------------
-- Project Name:  BI Replacement
-- Customization: 
-- Date Created: 20200828
-- Author:   Randy Yu  
-- Description:   Delete records from DM table/s
----------------------------------------------------


-- Modify these as appropriate
DEF script=JIRA_311_DM_Delete.sql
DEF logdir=c:\temp\

SET SERVEROUTPUT ON
SET LIN 2000

-- Error handling
WHENEVER SQLERROR EXIT ROLLBACK
WHENEVER OSERROR EXIT 51

-- Output options
SET ECHO ON TIME ON TIMING ON SQLBLANKLINES ON TRIMOUT ON TRIMSPOOL ON

-- Get database name
COLUMN env NEW_VAL Y
SELECT NAME env FROM V$DATABASE;

SET SQLPROMPT &y.>

-- Get date/time stamp
COLUMN ts NEW_VAL X
SELECT TO_CHAR (SYSDATE, 'yyyymmdd-hh24miss') ts FROM DUAL;

-- Set spool directory
SPOOL &logdir.&script._&x.-&y..log;

-- Show DB name
SELECT NAME FROM V$DATABASE;

---------------------------

---------------------------
-- Pre-Table count/select prior to update or delete
SELECT COUNT(1) FROM DM.D_CLSS_ENRL
WHERE CLSS_ENRL_ID <> -1;

SELECT COUNT(1) FROM DM.D_CLSS_GRD
WHERE CLSS_GRD_ID <> -1;

SELECT COUNT(1) FROM DM.F_STDNT_CLSS_ENRL;

SELECT COUNT(1) FROM DM.F_STDNT_ENRL;

---------------------------
-- Truncate scripts

TRUNCATE TABLE DM.F_STDNT_CLSS_ENRL;
COMMIT;

TRUNCATE TABLE DM.F_STDNT_ENRL;
COMMIT;

DELETE FROM DM.D_CLSS_GRD
WHERE CLSS_GRD_ID <> -1;
COMMIT;

DELETE FROM DM.D_CLSS_ENRL
WHERE CLSS_ENRL_ID <> -1;
COMMIT;




---------------------------
-- Gather stats scripts

exec DBMS_STATS.gather_table_stats('DM','D_CLSS_ENRL');
exec DBMS_STATS.gather_table_stats('DM','D_CLSS_GRD');
exec DBMS_STATS.gather_table_stats('DM','F_STDNT_ENRL');
exec DBMS_STATS.gather_table_stats('DM','F_STDNT_CLSS_ENRL');
---------------------------
-- End of script

spool off
