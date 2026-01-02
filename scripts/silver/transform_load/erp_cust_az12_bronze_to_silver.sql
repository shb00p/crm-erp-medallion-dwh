/*
===============================================================================
 Script Name : erp_cust_az12_bronze_to_silver.sql
 Purpose     : Load cleansed data from bronze layer to silver layer tables
               (silver.erp_cust_az12)
 Layer       : Silver
 Author      : Shashi Kunigiri
 Created On  : 2026-01-01

 NOTES:
 - Script assumes silver tables have been defined
 - Silver tables are truncated before bulk load
===============================================================================
*/

-- remove existing silver data
TRUNCATE TABLE silver.erp_cust_az12;

SET @start_time = NOW(6);

-- clean bronze.erp_cust_az12 and insert into silver layer
INSERT INTO silver.erp_cust_az12 (
    cid,
    bdate,
    gen,
    source_system,
    source_file,
    load_ts
)

WITH cleaned AS (
    SELECT
        cid,
        CASE
            WHEN bdate IS NULL THEN NULL
            WHEN bdate < '1900-01-01' THEN NULL
            WHEN bdate > CURRENT_DATE THEN NULL
            ELSE bdate
        END AS bdate,

        CASE
            WHEN LEFT(UPPER(REPLACE(REPLACE(REPLACE(CAST(gen AS CHAR), '\r', ''), '\n', ''), '\t', '')),1) = 'M' THEN 'Male'
            WHEN LEFT(UPPER(REPLACE(REPLACE(REPLACE(CAST(gen AS CHAR), '\r', ''), '\n', ''), '\t', '')),1) = 'F' THEN 'Female'
            ELSE 'N/A'
        END AS gen
    FROM bronze.erp_cust_az12

    -- each cid must map to record in customer_information
    WHERE cid IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)
)

SELECT
    cid,
    bdate,
    gen,

    'ERP' AS source_system,
    'CUST_AZ12.csv' AS source_file,
    CURRENT_TIMESTAMP AS load_ts
FROM cleaned;

SET @end_time = NOW(6);

-- load time calculation
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time)/1000 AS load_time_millis;

-- sanity check
SELECT * FROM silver.erp_cust_az12;