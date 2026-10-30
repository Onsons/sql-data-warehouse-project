```sql
/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================

Script Purpose:
    This script creates the tables in the 'bronze' schema in PostgreSQL.
    It drops existing tables if they already exist and recreates them
    to define the structure of the Bronze layer.

    The Bronze layer stores raw data imported from CRM and ERP source
    systems without applying any transformations.

Data Loading Note:
    During data ingestion, a file permission issue was encountered
    when using PostgreSQL's COPY command.

    Since COPY reads files from the PostgreSQL server's file system,
    the server process could not access the local CSV files.

    To resolve this issue, data was loaded using the \copy command
    through the psql terminal.

    Unlike COPY, \copy reads files from the client machine using
    the local user's permissions.

    Example:
    \copy bronze.crm_cust_info FROM '/path/to/cust_info.csv'
    WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',');

Warning:
    Running this script will drop and recreate all Bronze tables.
    Any existing data in these tables will be permanently deleted.

===============================================================================
*/
```
-- Create Schemas
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- Create DDL CRM
DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
	cst_id INT, 
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_marital_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATE
);
DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
	prd_id INT, 
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost INT,
	prd_line VARCHAR(50),
	prd_start_dt TIMESTAMP,
	prd_end_dt TIMESTAMP
);

DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num VARCHAR(50), 
	sls_prd_key VARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT	
);

-- Create DDL ERP
DROP TABLE  IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
	cid VARCHAR(50), 
	bdate DATE,
	gen VARCHAR(50)
);
DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
	cid VARCHAR(50), 
	cntry VARCHAR(50)
);

DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
	id VARCHAR(50), 
	cat VARCHAR(50),
	subcat VARCHAR(50),
	maintenace VARCHAR(50)
);

/*
Note:
    The COPY command below could not be executed due to file
    permission restrictions on the PostgreSQL server.

    As an alternative, the CSV files were successfully loaded
    using the client-side \copy command through the psql terminal.

    This approach avoids granting additional file system
    permissions to the PostgreSQL server process.
*/
COPY bronze.crm_cust_info
FROM '/Users/onstliba/Documents/sql-data-warehouse-project/01_datasets/source_crm/cust_info.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ','
);

