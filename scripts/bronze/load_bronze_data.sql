/*
===============================================================================
 Script Name : load_bronze_data.sql
 Purpose     : Loads data from CSV files to respective tables in bronze database
 Layer       : Bronze
 Author      : Newbie
 Created On  : 2025-12-29

 NOTE:
 - Uses LOAD DATA LOCAL INFILE for local development.
 - If LOCAL is disabled, use server-side LOAD DATA INFILE
   and place CSVs in the --secure-file-priv directory.

 WARNING:
 - Assumes Bronze tables already exist
 - Assumes CSV files are raw and unmodified
 - Re-running without truncation will duplicate data
===============================================================================
*/

-- =========================
-- Truncate CRM tables
-- =========================
TRUNCATE TABLE bronze.crm_cust_info;
TRUNCATE TABLE bronze.crm_prd_info;
TRUNCATE TABLE bronze.crm_sales_details;

-- =========================
-- Truncate ERP tables
-- =========================
TRUNCATE TABLE bronze.erp_cust_az12;
TRUNCATE TABLE bronze.erp_loc_a101;
TRUNCATE TABLE bronze.erp_px_cat_g1v2;


-- =========================
-- CRM DATA
-- =========================
LOAD DATA LOCAL INFILE 'datasets/source_crm/cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'datasets/source_crm/prd_info.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'datasets/source_crm/sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- =========================
-- ERP DATA
-- =========================
LOAD DATA LOCAL INFILE 'datasets/source_erp/CUST_AZ12.csv'
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'datasets/source_erp/LOC_A101.csv'
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'datasets/source_erp/px_cat_g1v2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

