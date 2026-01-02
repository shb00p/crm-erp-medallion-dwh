
# Data Dictionary for Gold Layer

### Overview
The gold layer represents the business-face of the data warehouse. It contains curated fact and dimension tables for analytics and reporting. Data is cleaned, standardized, and accurately modeled to extract business-ready metrics and entities.

#### 1. gold.dim_product_information
***
This view dimension contains details about products. It is made by joining ```silver.crm_prd_info``` and ```silver.erp_px_cat_g1v2``` tables on the basis of category IDs.

| Column Name     | Data Type    | Description |
|-----------------|--------------|-------------|
| product_key     | BIGINT       | Surrogate product key for analytical joins |
| product_id      | VARCHAR(50)  | Product identifier from the CRM system |
| product_number  | VARCHAR(50)  | Business product key used across systems |
| product_name    | VARCHAR(255) | Product name |
| category_id     | VARCHAR(50)  | Product category identifier from ERP |
| category        | VARCHAR(50)  | Product category |
| subcategory     | VARCHAR(50)  | Product subcategory |
| product_cost    | INT          | Cost of the product |
| product_line    | VARCHAR(100) | Product line or family |
| maintenance     | VARCHAR(50)  | Maintenance indicator for the product |
| start_date      | DATE         | Effective start date of the product record |

#### 2. gold.dim_customer_information
***
This view contains details about the customer. It is made by joining ```silver.crm_cust_info``` with ```silver.erp_loc_a101``` and ```erp_cust_az12``` on the basis of customer keys and cid.

| Column Name      | Data Type    | Description |
|------------------|--------------|-------------|
| customer_key     | BIGINT       | Surrogate customer key for analytical joins |
| customer_id      | INT          | Customer identifier from the CRM system |
| customer_number  | VARCHAR(50)  | Business customer key used across systems |
| firstname        | VARCHAR(50)  | Customer first name |
| lastname         | VARCHAR(50)  | Customer last name |
| gender           | VARCHAR(10)  | Standardized customer gender |
| birthdate        | DATE         | Customer date of birth |
| country          | VARCHAR(50)  | Customer country |
| marital_status   | VARCHAR(50)  | Customer marital status |
| createdate       | DATE         | CRM customer creation date |

#### 3. gold.fact_sales_information
***
This view contains details about sales of products and associated customers. It is the main table used for business analytics. It is made by joining ```silver.crm_sales_details``` with ```gold.dim_customer_information``` and ```gold.dim_product_information``` on the basis of product keys and customer IDs.

| Column Name     | Data Type    | Description |
|-----------------|--------------|-------------|
| order_number    | VARCHAR(50)  | Sales order identifier |
| product_key     | BIGINT       | Surrogate key referencing the product dimension |
| customer_key    | BIGINT       | Surrogate key referencing the customer dimension |
| order_date      | DATE         | Date the order was placed |
| shipping_date   | DATE         | Date the order was shipped |
| due_date        | DATE         | Expected delivery date |
| sales           | INT          | Total sales amount for the order line |
| quanitity       | INT          | Quantity sold |
| price           | INT          | Unit price of the product |





