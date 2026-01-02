/*
===============================================================================
 Script Name : load_bronze_data.sql
 Purpose     : Load raw CSV files into bronze layer tables
 Layer       : Bronze
 Author      : Shashi Kunigiri
 Created On  : 2025-12-29

 NOTES:
 - Must be executed from a client with LOCAL INFILE enabled
 - Uses client-side LOAD DATA LOCAL INFILE
 - Tables are truncated before load
===============================================================================
*/

-- ------------------------------------------------
-- Temporary table to store load execution times
-- ------------------------------------------------
DROP TEMPORARY TABLE IF EXISTS bronze.load_bronze_times;

CREATE TEMPORARY TABLE bronze.load_bronze_times (
    table_name   VARCHAR(100),
    duration_us  BIGINT
);

-- =========================
-- CRM CUSTOMER INFO
-- =========================
TRUNCATE TABLE bronze.crm_cust_info;

SET @start_time = NOW(6);

LOAD DATA LOCAL INFILE 'datasets/source_crm/cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_time = NOW(6);

INSERT INTO bronze.load_bronze_times
VALUES (
    'crm_cust_info',
    TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time)
);

-- =========================
-- CRM PRODUCT INFO
-- =========================
TRUNCATE TABLE bronze.crm_prd_info;

SET @start_time = NOW(6);

LOAD DATA LOCAL INFILE 'datasets/source_crm/prd_info.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_time = NOW(6);

INSERT INTO bronze.load_bronze_times
VALUES (
    'crm_prd_info',
    TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time)
);

-- =========================
-- CRM SALES DETAILS
-- =========================
TRUNCATE TABLE bronze.crm_sales_details;

SET @start_time = NOW(6);

LOAD DATA LOCAL INFILE 'datasets/source_crm/sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_time = NOW(6);

INSERT INTO bronze.load_bronze_times
VALUES (
    'crm_sales_details',
    TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time)
);

-- =========================
-- ERP CUSTOMER
-- =========================
TRUNCATE TABLE bronze.erp_cust_az12;

SET @start_time = NOW(6);

LOAD DATA LOCAL INFILE 'datasets/source_erp/CUST_AZ12.csv'
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_time = NOW(6);

INSERT INTO bronze.load_bronze_times
VALUES (
    'erp_cust_az12',
    TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time)
);

-- =========================
-- ERP LOCATION
-- =========================
TRUNCATE TABLE bronze.erp_loc_a101;

SET @start_time = NOW(6);

LOAD DATA LOCAL INFILE 'datasets/source_erp/LOC_A101.csv'
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_time = NOW(6);

INSERT INTO bronze.load_bronze_times
VALUES (
    'erp_loc_a101',
    TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time)
);

-- =========================
-- ERP PRICE CATEGORY
-- =========================
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

SET @start_time = NOW(6);

LOAD DATA LOCAL INFILE 'datasets/source_erp/px_cat_g1v2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SET @end_time = NOW(6);

INSERT INTO bronze.load_bronze_times
VALUES (
    'erp_px_cat_g1v2',
    TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time)
);

-- ------------------------------------------------
-- Final consolidated report
-- ------------------------------------------------
SELECT
    table_name,
    duration_us,
    ROUND(duration_us / 1000, 2) AS duration_ms
FROM load_bronze_times
ORDER BY duration_us DESC;
