/*
===============================================================================
 Script Name : crm_prd_info_bronze_to_silver.sql
 Purpose     : Load cleansed data from bronze layer to silver layer tables
               (silver.crm_prd_info)
 Layer       : Silver
 Author      : Shashi Kunigiri
 Created On  : 2026-01-01

 NOTES:
 - Script assumes silver tables have been defined
 - Silver tables are truncated before bulk load
===============================================================================
*/

-- remove existing silver data
TRUNCATE TABLE silver.crm_prd_info;

SET @start_time = NOW(6);

-- clean bronze.crm_prd_info and insert into silver layer
INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt,
    source_system,
    source_file,
    load_ts
)

WITH cleaned AS (
    SELECT
        prd_id,
        TRIM(prd_key) AS prd_key,
        TRIM(prd_nm) AS prd_nm,
        prd_cost,
        TRIM(UPPER(prd_line)) AS prd_line,
        prd_start_dt,
        LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) AS prd_end_dt
    FROM bronze.crm_prd_info
    WHERE prd_id IS NOT NULL
          AND prd_key IS NOT NULL
          AND TRIM(prd_id) <> ''
          AND TRIM(prd_key) <> ''
          AND prd_start_dt
),

deduplicated AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY prd_id
               ORDER BY prd_end_dt DESC, prd_start_dt DESC
           ) AS rn
    FROM cleaned
)

SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key,1,5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
    NULLIF(prd_nm, '') AS prd_nm,
    COALESCE(prd_cost, 0) AS prd_cost,

    CASE
        WHEN prd_line = 'M' THEN 'Mountain'
        WHEN prd_line = 'R' THEN 'Road'
        WHEN prd_line = 'S' THEN 'Other Sales'
        WHEN prd_line = 'T' THEN 'Touring'
        ELSE 'N/A'
    END AS prd_line,

    prd_start_dt,
    prd_end_dt,
    'CRM' AS source_system,
    'prd_info.csv' AS source_file,
    CURRENT_TIMESTAMP AS load_ts
FROM deduplicated
WHERE rn = 1;

SET @end_time = NOW(6);

-- load time calculation
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time)/1000 AS load_time_millis;

-- sanity check
SELECT * FROM silver.crm_prd_info;