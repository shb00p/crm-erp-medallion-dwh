/*
===============================================================================
 Script Name : fact_view_gold_sales.sql
 Purpose     : Create view to create table containing Sales Information
 Layer       : Gold
 Author      : Shashi Kunigiri
 Created On  : 2026-01-02

 WARNING:
 - Script is destructive, views are dropped before reconstruction
===============================================================================
*/

-- drop existing view
DROP VIEW IF EXISTS gold.fact_sales_information;

CREATE VIEW gold.fact_sales_information AS
    SELECT
        sd.sls_ord_num AS order_number,
        pi.product_key, -- replaces pi.sls_prd_key,
        ci.customer_key, -- replaces ci.customer_id
        sd.sls_order_dt AS order_date,
        sd.sls_ship_dt AS shipping_date,
        sd.sls_due_dt AS due_date,
        sd.sls_sales AS sales,
        sd.sls_quantity AS quantity,
        sd.sls_price AS price

    FROM silver.crm_sales_details AS sd
    LEFT JOIN gold.dim_product_information AS pi
        ON sd.sls_prd_key = pi.product_number
    LEFT JOIN gold.dim_customer_information AS ci
        ON sd.sls_cust_id = ci.customer_id;

-- sanity check
SELECT * FROM gold.fact_sales_information;