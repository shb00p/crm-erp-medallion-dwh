/*
===============================================================================
 Script Name : initialise_tables.sql
 Purpose     : Defines Bronze-layer table structures for CRM and ERP CSV sources
 Layer       : Bronze
 Author      : Shashi Kunigiri
 Created On  : 2025-12-29

 WARNING:
 - This script is destructive if tables already exist
   It drops all warehouse bronze layer tables before recreating them
 - Risk of permanent bronze data loss
===============================================================================
*/

-- =========================
-- Drop CRM tables
-- =========================
DROP TABLE IF EXISTS bronze.crm_cust_info;
DROP TABLE IF EXISTS bronze.crm_prd_info;
DROP TABLE IF EXISTS bronze.crm_sales_details;

-- =========================
-- Drop ERP tables
-- =========================
DROP TABLE IF EXISTS bronze.erp_cust_az12;
DROP TABLE IF EXISTS bronze.erp_loc_a101;
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;


-- =========================
-- Create CRM tables
-- =========================
CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);

CREATE TABLE bronze.crm_prd_info (
    prd_id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(255),
    prd_cost INT,
    prd_line VARCHAR(100),
    prd_start_dt DATE,
    prd_end_dt DATE
);

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num   VARCHAR(50),
    sls_prd_key   VARCHAR(50),
    sls_cust_id   VARCHAR(50),
    sls_order_dt  VARCHAR(50),
    sls_ship_dt   VARCHAR(50),
    sls_due_dt    VARCHAR(50),
    sls_sales     INT,
    sls_quantity  INT,
    sls_price     INT
);

-- =========================
-- Create ERP tables
-- =========================
CREATE TABLE bronze.erp_cust_az12 (
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);

CREATE TABLE bronze.erp_loc_a101 (
    cid VARCHAR(50),
    cntry VARCHAR(50)
);

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    sbcat VARCHAR(50),
    maintenance VARCHAR(50)
);