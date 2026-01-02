/*
===============================================================================
 Script Name : erp_px_cat_g1v2_bronze_to_silver.sql
 Purpose     : Load cleansed data from bronze layer to silver layer tables
               (silver.erp_px_cat_g1v2)
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

SET @start_time = NOW(6);

-- clean bronze.erp_px_cat_g1v2 and insert into silver layer
INSERT INTO silver.erp_px_cat_g1v2 (
    id,
    cat,
    sbcat,
    maintenance,
    source_system,
    source_file,
    load_ts
)

WITH cleaned AS (
    SELECT
        id,
        cat,
        sbcat,
        TRIM(REPLACE(REPLACE(REPLACE(maintenance,'\r', ''), '\n', ''), '\t', '')) AS maintenance
    FROM bronze.erp_px_cat_g1v2
)

SELECT
    id,
    cat,
    sbcat,
    maintenance,

    'ERP' AS source_system,
    'PX_CAT_G1V2.csv' AS source_file,
    CURRENT_TIMESTAMP AS load_ts
FROM cleaned;

SET @end_time = NOW(6);

-- load time calculation
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time)/1000 AS load_time_millis;

-- sanity check
SELECT DISTINCT * FROM silver.erp_px_cat_g1v2;