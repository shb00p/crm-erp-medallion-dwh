/*
===============================================================================
 Script Name : crm_cust_info_bronze_to_silver.sql
 Purpose     : Load cleansed data from bronze layer to silver layer tables
               (silver.crm_cust_info)
 Layer       : Silver
 Author      : Shashi Kunigiri
 Created On  : 2026-01-01

 NOTES:
 - Script assumes silver tables have been defined
 - Silver tables are truncated before bulk load
===============================================================================
*/

-- remove existing silver data
TRUNCATE TABLE silver.crm_cust_info;

SET @start_time = NOW(6);

-- clean bronze.crm_cust_info and insert into silver layer
INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date,
    source_system,
    source_file,
    load_ts
)

WITH cleaned AS (
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname)  AS cst_lastname,
        TRIM(UPPER(cst_marital_status)) AS cst_marital_status,
        TRIM(UPPER(cst_gndr)) AS cst_gndr,
        CASE
            WHEN cst_create_date < '1000-01-01' THEN NULL
            ELSE cst_create_date
        END AS cst_create_date
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL AND cst_id != 0
      AND cst_key IS NOT NULL
),

deduplicated AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY cst_id
               ORDER BY cst_create_date DESC
           ) AS rn
    FROM cleaned
)

SELECT
    cst_id,
    cst_key,
    NULLIF(cst_firstname, '') AS cst_firstname,
    NULLIF(cst_lastname, '')  AS cst_lastname,

    CASE
        WHEN cst_marital_status = 'M' THEN 'Married'
        WHEN cst_marital_status = 'S' THEN 'Single'
        ELSE 'N/A'
    END AS cst_marital_status,

    CASE
        WHEN cst_gndr = 'M' THEN 'Male'
        WHEN cst_gndr = 'F' THEN 'Female'
        ELSE 'N/A'
    END AS cst_gndr,

    cst_create_date,
    'CRM' AS source_system,
    'cust_info.csv' AS source_file,
    CURRENT_TIMESTAMP AS load_ts
FROM deduplicated
WHERE rn = 1;

SET @end_time = NOW(6);

-- load time calculation
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time)/1000 AS load_time_millis;

-- sanity check
SELECT * FROM silver.crm_cust_info;