/*
===============================================================================
 Script Name : dim_view_gold_customers.sql
 Purpose     : Create view to create table containing Customer Information
 Layer       : Gold
 Author      : Shashi Kunigiri
 Created On  : 2026-01-02

 WARNING:
 - Script is destructive, views are dropped before reconstruction
===============================================================================
*/

-- drop existing view
DROP VIEW IF EXISTS gold.dim_customer_information;

CREATE VIEW gold.dim_customer_information AS
    SELECT
        ROW_NUMBER() OVER(ORDER BY caz.bdate, ci.cst_create_date) AS customer_key,
        ci.cst_id AS customer_id,
        ci.cst_key AS customer_number,
        ci.cst_firstname AS firstname,
        ci.cst_lastname AS lastname,
        CASE
          WHEN ci.cst_gndr = 'N/A' THEN ci.cst_gndr
          ELSE COALESCE(caz.gen, 'N/A')
        END as gender,
        caz.bdate AS birthdate,
        lo.cntry AS country,
        ci.cst_marital_status AS marital_status,
        ci.cst_create_date AS createdate

    FROM silver.crm_cust_info AS ci
    LEFT JOIN silver.erp_loc_a101 AS lo
        ON ci.cst_key = lo.cid
    LEFT JOIN silver.erp_cust_az12 AS caz
        ON ci.cst_key = caz.cid;

-- sanity check
SELECT * FROM gold.dim_customer_information;