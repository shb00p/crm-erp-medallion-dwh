/*
===============================================================================
 Script Name : view_gold_customer.sql
 Purpose     : Create view to create table containing Customer Information
 Layer       : Gold
 Author      : Newbie
 Created On  : 2026-01-02

 NOTES:
 - Script is destructive, views are dropped before reconstruction
===============================================================================
*/

DROP VIEW IF EXISTS gold.dim_product_information;

CREATE VIEW gold.dim_product_information AS
    SELECT
        ROW_NUMBER() OVER(ORDER BY pi.prd_start_dt, pi.prd_key) AS product_key,
        pi.prd_id AS product_id,
        pi.prd_key AS product_number,
        pi.prd_nm AS product_name,
        pi.cat_id AS category_id,
        px.cat AS category,
        px.sbcat AS subcategory,
        pi.prd_cost AS product_cost,
        pi.prd_line AS product_line,
        px.maintenance,
        pi.prd_start_dt AS start_date

    FROM silver.crm_prd_info AS pi
    LEFT JOIN silver.erp_px_cat_g1v2 AS px
        ON pi.cat_id = px.id
    WHERE pi.prd_end_dt IS NULL; -- filter out historical data

SELECT * FROM gold.dim_product_information;

