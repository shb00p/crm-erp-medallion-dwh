/*
===============================================================================
 Script Name : crm_sales_details_bronze_to_silver.sql
 Purpose     : Load cleansed data from bronze layer to silver layer tables
               (silver.crm_sales_details)
 Layer       : Silver
 Author      : Newbie
 Created On  : 2026-01-01

 NOTES:
 - Script assumes silver tables have been defined
 - Silver tables are truncated before bulk load
===============================================================================
*/

-- remove existing silver data
TRUNCATE TABLE silver.crm_sales_details;

SET @start_time = NOW(6);

-- clean bronze.crm_sales_details and insert into silver layer
INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price,
    source_system,
    source_file,
    load_ts
)

WITH cleaned AS (
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,

        CASE
            WHEN sls_order_dt IS NULL THEN NULL
            WHEN sls_order_dt BETWEEN 10000101 AND 99991231
                 AND LENGTH(sls_order_dt) = 8
            THEN STR_TO_DATE(sls_order_dt, '%Y%m%d')
            ELSE NULL
        END AS sls_order_dt,

        CASE
            WHEN sls_ship_dt IS NULL THEN NULL
            WHEN sls_ship_dt BETWEEN 10000101 AND 99991231
                 AND LENGTH(sls_ship_dt) = 8
            THEN STR_TO_DATE(sls_ship_dt, '%Y%m%d')
            ELSE NULL
        END AS sls_ship_dt,

        CASE
            WHEN sls_due_dt IS NULL THEN NULL
            WHEN sls_due_dt BETWEEN 10000101 AND 99991231
                 AND LENGTH(sls_due_dt) = 8
            THEN STR_TO_DATE(sls_due_dt, '%Y%m%d')
            ELSE NULL
        END AS sls_due_dt,

        CASE
            WHEN sls_sales != sls_quantity*ABS(sls_price) OR sls_sales IS NULL
                THEN sls_sales = sls_quantity*ABS(sls_price)
            ELSE sls_sales
        END AS sls_sales,

        COALESCE(sls_quantity, 0) AS sls_quantity,

        CASE
            WHEN sls_price IS NULL OR sls_price <= 0
                THEN sls_price = sls_sales/IFNULL(sls_quantity, 0)
            ELSE sls_price
        END AS sls_price

    FROM bronze.crm_sales_details
    WHERE sls_prd_key IS NOT NULL
        AND sls_cust_id IS NOT NULL
        AND TRIM(sls_prd_key) <> ''
        AND TRIM(sls_cust_id) <> ''
        AND sls_order_dt < sls_ship_dt
)

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price,

    'CRM' AS source_system,
    'sales_details.csv' AS source_file,
    CURRENT_TIMESTAMP AS load_ts
FROM cleaned;

SET @end_time = NOW(6);

-- load time calculation
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time)/1000 AS load_time_millis;

-- sanity check
SELECT * FROM silver.crm_sales_details;