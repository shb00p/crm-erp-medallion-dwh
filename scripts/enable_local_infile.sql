/*
===============================================================================
 Script Name : enable_local_infile.sql
 Purpose     : Checks and enables the MySQL local_infile setting required for
               loading CSV files using LOAD DATA LOCAL INFILE.
               (required for execution of load_bronze_data.sql)
 Author      : Shashi Kunigiri
 Created On  : 2025-12-29

 WARNING:
 - This script modifies a GLOBAL MySQL server setting.
 - Requires sufficient privileges (SUPER or SYSTEM_VARIABLES_ADMIN).
 - Intended for local development environments only.
===============================================================================
*/

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';