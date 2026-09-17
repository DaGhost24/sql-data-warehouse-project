/*
=====================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=====================================================================================

The purpose of this stored procedure is to load data into the 'bronze' schema from external
CSV files.

It performs the following actions:
	-Truncates the bronze table before loading data.
	-Uses the `Bulk Insert` command to load data from CSV files to bronze tables.

use this code to run:
Exec bronze.load_bronze;
=========================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @Start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime; -- This is a declaration
	BEGIN TRY --This checks if there no errors that occur
		
		SET @batch_start_time = GETDATE()
		PRINT '===========================================================';
		PRINT 'Loading bronze layer';
		PRINT '===========================================================';


		PRINT '-----------------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-----------------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT '>> Truncating table: bronze.crm_cust_info'
		Truncate table bronze.crm_cust_info --this basically clears the table before inserting the bulk data
		PRINT '>> Inserting data into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		from 'C:\Users\Client\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		with (
			FirstRow = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS nvarchar) + ' seconds';
		PRINT '---------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating table: bronze.crm_prd_info'
		truncate table bronze.crm_prd_info

		PRINT '>> Inserting data into: bronze.crm_prd_info'
		Bulk insert bronze.crm_prd_info
		from 'C:\Users\Client\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		with (
			Firstrow = 2,
			FIELDTERMINATOR = ',',
			Tablock
		);
		SET @end_time = GETDATE();
		PRINT '>>> Loading Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS nvarchar) + ' seconds';
		PRINT '------------------------------------'

		SET @start_time = GETDATE()
		PRINT '>> Truncating table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details

		PRINT '>> Inserting data into: bronze.crm_sales_details';
		Bulk insert bronze.crm_sales_details
		from 'C:\Users\Client\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		with (
			firstrow = 2,
			FIELDTERMINATOR = ',',
			Tablock
		);
		SET @end_time = GETDATE()
		PRINT '>>> Loading Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS nvarchar) + ' seconds';
		PRINT '------------------------------------'

		PRINT '---------------------------------------------------------------';
		PRINT 'Loading ERP Table';
		PRINT '---------------------------------------------------------------';

		SET @start_time = GETDATE()
		PRINT '>> Truncating the table: bronze.erp_cust_az12 ';
		Truncate table bronze.erp_cust_az12

		PRINT '>> Inserting data into: bronze.erp_cust_az12';
		Bulk INSERT bronze.erp_cust_az12
		from 'C:\Users\Client\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
		with (
			firstrow = 2,
			FIELDTERMINATOR = ',',
			Tablock
		);
		SET @end_time = GETDATE()
		PRINT '>>> Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS nvarchar) + ' seconds';
		PRINT '-------------------------------------'

		SET @start_time = GETDATE()
		PRINT '>> Truncating the table: bronze.erp_loc_a101 ';
		Truncate table bronze.erp_loc_a101
		PRINT '>> Inserting data into: bronze.erp_loc_a101';
		Bulk Insert bronze.erp_loc_a101
		from 'C:\Users\Client\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
		with (
			firstrow = 2,
			FIELDTERMINATOR = ',',
			Tablock
		);
		SET @end_time = GETDATE()
		PRINT '>>> Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS nvarchar) + ' seconds';
		PRINT '-------------------------------------'

		SET @start_time = GETDATE()
		PRINT '>> Truncating the table: bronze.erp_px_cat_g1v2';
		Truncate table bronze.erp_px_cat_g1v2
		PRINT '>> Inserting data into: bronze.erp_px_cat_g1v2';
		Bulk Insert bronze.erp_px_cat_g1v2
		from 'C:\Users\Client\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			firstrow = 2,
			FIELDTERMINATOR = ',',
			Tablock
		);
		SET @end_time = GETDATE();
		PRINT '>>> Loading Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS nvarchar) + ' seconds';
		PRINT '-------------------------------------'

		SET @batch_end_time = GETDATE();
		PRINT '======================================'
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '   - Total Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS nvarchar) + ' seconds';
		PRINT '======================================'


	END TRY --This ends the try
	BEGIN CATCH --This catches the errors if they occur during the try
		PRINT '=================================================================';
		PRINT 'An error occured during loading bronze layer'
		PRINT 'Error Message' + Error_message();
		PRINT 'Error Message' + CAST(Error_number() AS nvarchar)
		PRINT ''
		PRINT '=================================================================';
	END CATCH

END
