/*
===============================================================================
 Script Name : erp_loc_a101_bronze_to_silver.sql
 Purpose     : Load cleansed data from bronze layer to silver layer tables
               (silver.erp_loc_a101)
 Layer       : Silver
 Author      : Newbie
 Created On  : 2026-01-02

 NOTES:
 - Script assumes silver tables have been defined
 - Silver tables are truncated before bulk load
===============================================================================
*/

-- remove existing silver data
TRUNCATE TABLE silver.erp_loc_a101;

-- clean bronze.erp_loc_a101 and insert into silver layer
INSERT INTO silver.erp_loc_a101 (
    cid,
    cntry,
    source_system,
    source_file,
    load_ts
)

WITH cleaned AS (
    SELECT
        REPLACE(cid,'-','') AS cid,
        CASE
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
            WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
            ELSE TRIM(cntry)
        END AS cntry
    FROM bronze.erp_loc_a101
)

SELECT
    c.cid,
    c.cntry,
    'ERP' AS source_system,
    'LOC_A101.csv' AS source_file,
    CURRENT_TIMESTAMP AS load_ts
FROM cleaned c
JOIN silver.crm_cust_info crm
  ON c.cid = crm.cst_key;

-- sanity check
SELECT * FROM silver.erp_loc_a101;