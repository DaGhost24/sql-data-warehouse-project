/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/
-- =================================================
-- This creates the dimension table: gold.dim_customers
-- =================================================
IF OBJECT_ID('gold.dim_customers', 'v') IS NOT NULL
	DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, --this a Surrogate Key to link dimensions and fact tables efficiently
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_Name,
	ci.cst_lastname AS last_Name,
	ci.cst_maritail_status AS maritail_status,
	--ci.cst_gnder,
	--Here we are performing data intergration
	CASE WHEN ci.cst_gnder != 'Unknown' THEN ci.cst_gnder  -- uses what is in the crm_cust_info table
		 ELSE COALESCE(ca.gen, 'Unknown') -- this checks if ca.gen has a value then use that value, if ca.gen is null then write Unknown
	END AS gender,
	ci.cst_create_date AS created_date,
	ca.bdate AS birthdate,
	--ca.gen,
	cl.cntry AS country
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 cl
	ON ci.cst_key = cl.cid

-- ======================================================
-- This creates the dimension table: gold.dim_products
-- ======================================================
IF OBJECT_ID('gold.dim_products', 'v') IS NOT NULL
	DROP VIEW gold.dim_products;
GO;

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS product_cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
	--pn.prd_end_dt
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
where prd_end_dt IS NULL -- This filters out all history data and showns only the current

-- =============================================
-- This creates a fact table: gold.fact_sales
-- =============================================
IF OBJECT_ID('gold.fact_sales', 'v') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key,
	dc.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shpping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales,
	sd.sls_quanitity AS quantity,
	sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_customers dc
ON sd.sls_cust_id = dc.customer_id
LEFT JOIN gold.dim_products pr
ON SD.sls_prd_key = pr.product_number
