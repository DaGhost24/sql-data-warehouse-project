Use DataWarehouse

/*
====================================================================================
The purpose of this script is to create all tables within the 'bronze' schema, dropping
existing tables if they already exist.

Run this script to re-define the DDL structure of 'bronze' table

=====================================================================================
*/

--This checks if the object exist (table) if it does then deletes it or drop it
IF OBJECT_ID ('silver.crm_cust_info', 'U') is not null
	drop Table silver.crm_cust_info;

create table silver.crm_cust_info (
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_lastname nvarchar(50),
	cst_maritail_status nvarchar(50),
	cst_gnder nvarchar(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
	drop table silver.crm_prd_info;

create table silver.crm_prd_info (
	prd_id int,
	prd_key nvarchar(50),
	cat_id	nvarchar(50),
	prd_nm	nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt Date,
	prd_end_dt Date,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
	drop table silver.crm_sales_details;

create table silver.crm_sales_details (
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt Date,
	sls_ship_dt Date,
	sls_due_dt Date,
	sls_sales int,
	sls_quanitity int,
	sls_price int,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erp_Cust_AZ12', 'U') IS NOT NULL
	drop table silver.erp_Cust_AZ12;

create table silver.erp_cust_az12 (
	cid nvarchar(50),
	bdate Date,
	gen nvarchar(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erp_LOC_A101', 'U') IS NOT NULL
	drop table silver.erp_LOC_A101;

create table silver.erp_loc_a101 (
	cid nvarchar(50),
	cntry nvarchar(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erp_PX_CAT_G1V2', 'U') IS NOT NULL
	drop table silver.erp_PX_CAT_G1V2;

create table silver.erp_px_cat_g1v2 (
	id nvarchar(50),
	cat nvarchar(50),
	subcat nvarchar(50),
	maintenance nvarchar(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
