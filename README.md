# 🧱 MySQL Data Warehouse (Medallion Architecture)

A lightweight end-to-end **MySQL data warehousing project** implementing the **Medallion Architecture (Bronze → Silver → Gold)** for CRM and ERP source systems.

This project demonstrates **data ingestion, cleansing, transformation, and business modeling** using industry-standard SQL practices.

---

## 📌 Overview

This warehouse is designed with three logical layers:

![medallion_architecture_image](docs\diagrams\warehouse_architecture.png "Medallion Architecture")

### 🥉 Bronze Layer – Raw Ingestion
- Stores raw CSV data from CRM and ERP systems
- Minimal transformation
- Schema mirrors source files
- Data is loaded using `LOAD DATA LOCAL INFILE`

### 🥈 Silver Layer – Cleansed & Standardized
- Data quality checks
- Deduplication
- Type normalization
- Standardized domain values
- Metadata enrichment (source, load timestamp)

### 🥇 Gold Layer – Business Models
- Dimension and fact tables
- Business-ready datasets
- Optimized for analytics and reporting
- Implemented using SQL views

---
## 💼 Business Integration Model
The key business objects are highlighted in this model

![business_integration_model](docs\diagrams\business_integration_model.png "Business Model")

## 🗂️ Project Structure
```
├── datasets
│   ├── source_crm
│   └── source_erp
│
├── sql
│   ├── bronze
│   ├── silver
│   └── gold
│
├── docs
│   ├── drawIO_files
│   ├── architecture
│   └── gold_data_catalog.md
│
├── README.md
└── .gitignore
```

## 🧪 Data Quality Features

- Null & invalid row filtering

- Deduplication using window functions

- String normalization

- Date validation & correction

- Controlled domain mappings

- Metadata tracking (source_system, source_file, load_ts)

## 🛠️ Tech Stack

- Database: MySQL 8+

- Client: DataGrip / MySQL CLI

- Format: CSV

- Architecture: Medallion (Bronze / Silver / Gold)

- Visualisation Tools: draw.io

## ⚠️ Important Notes

- **LOAD DATA LOCAL INFILE** is the procedure used to load raw CSV files into bronze tables (data ingestion)

- Run the ```enable_local_infile.sql``` before usage

- Also ensure enable_local_infile is set to TRUE on client IDE as well

## 🚀 Usage

Follow the steps **in order** by running the scripts

Please reference **docs** before executing the following steps to gain insight about the project

### 1️⃣ Initialize Databases
```
init_database.sql
```
### 2️⃣ Initialize Schemas & Tables
```
bronze/initialise_bronze_tables.sql
silver/initialise_silver_tables.sql
```

### 3️⃣ Load Bronze Layer (Raw CSVs) 
```
bronze/load_bronze_data.sql
```

### 4️⃣ Populate Silver Layer (Cleansing & Standardization)
```
silver/transform_load/crm_cust_info_bronze_to_silver.sql
silver/transform_load/crm_prd_info_bronze_to_silver.sql
silver/transform_load/crm_sales_details_bronze_to_silver.sql
silver/transform_load/erp_cust_az12_bronze_to_silver.sql
silver/transform_load/erp_loc_a101_bronze_to_silver.sql
silver/transform_load/erp_px_cat_g1v2_bronze_to_silver.sql
```

### 5️⃣ Create Gold Layer Views (Analytics Ready)
```
gold/dim_view_gold_customers.sql
gold/dim_view_gold_products.sql
gold/fact_view_gold_sales.sql
```
![warehouse_dataflow_diagram](docs\diagrams\warehouse_dataflow_diagram.png "Dataflow Diagram")

![star_schema_model](docs\diagrams\star_schema_model.png "Star Schema")

## 📈 Room for Improvement
- Add data quality checks for gold layer

- Create a single orchestrator script for bronze, silver and gold layers for ease of use

- Add a naming convetions markdown file to docs folder

## 📄 License

This project is released under the MIT License.
You are free to use, modify, and distribute it.

## 🙏 Acknowledgments

This project was inspired by the 30 hour SQL course by Data With Baraa (Baraa Khatib Salkini) on YouTube

[GitHub](https://github.com/DataWithBaraa)

[YouTube Tutorial](https://www.youtube.com/watch?v=SSKVgrwhzus)

The implementation, schema design, SQL logic, transformations, and diagrams were independently developed and catered for MySQL by me.

## 👤 Author

Built by Shashi Kunigiri

For learning, experimentation, and portfolio demonstration.

---

⭐ If this project helped you understand data warehousing concepts, give it a star!
