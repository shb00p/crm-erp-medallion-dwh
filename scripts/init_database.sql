/*
===============================================================================
 Script Name : init_database.sql
 Purpose     : Initialises MySQL Data Warehouse using Medallion Architecture.
               Creates databases for bronze, silver and gold layers.
 Author      : Shashi Kunigiri
 Created On  : 2025-12-29

 WARNING:
 - This script is destructive if databases already exist
   It drops all warehouse databases before recreating them
 - Risk of permanent data loss
===============================================================================
*/

-- drop existing databases
DROP DATABASE IF EXISTS bronze;
DROP DATABASE IF EXISTS silver;
DROP DATABASE IF EXISTS gold;

-- Create Medallion layer databases
CREATE DATABASE bronze;
CREATE DATABASE silver;
CREATE DATABASE gold;