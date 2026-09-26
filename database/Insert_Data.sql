/*
===============================================================================
Stored Procedure: Load Data (Files -> Tables)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'swiggy' database tables from external CSV files. 
    It performs the following actions:
    - Truncates the tables before loading data.
    - Uses the `COPY FROM` command to load data from csv Files to tables.

Database:
    PostgreSQL

Parameters:
    None. 
	This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL load_data();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE load_data()
LANGUAGE PLPGSQL
AS $$
DECLARE 
    start_time TIMESTAMP; 
    end_time TIMESTAMP; 
    batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;
    duration_seconds NUMERIC;
BEGIN
    batch_start_time := clock_timestamp(); -- Record start time

	RAISE NOTICE '================================================';
	RAISE NOTICE 'TRUNCATING TABLES';
	RAISE NOTICE '================================================';

    start_time := clock_timestamp(); -- Record start time
	RAISE NOTICE '>> Truncating Tables';
	TRUNCATE TABLE order_items CASCADE;
    TRUNCATE TABLE orders CASCADE;
    TRUNCATE TABLE menu CASCADE;
    TRUNCATE TABLE restaurants CASCADE;
    TRUNCATE TABLE users CASCADE;

    end_time := clock_timestamp(); -- Record end time
	duration_seconds := EXTRACT(EPOCH FROM (end_time - start_time));
	RAISE NOTICE '>> Truncating Tables Duration: % seconds', duration_seconds;
    RAISE NOTICE '>> -------------';

    RAISE NOTICE '================================================';
	RAISE NOTICE 'LOADING TABLES';
	RAISE NOTICE '================================================';

	-- ========================================
    -- LOAD USERS TABLE
    -- ========================================
    start_time := clock_timestamp(); -- Record start time
    RAISE NOTICE '>> Inserting Data Into: users';
	COPY users (user_id,user_name,age,gender,marital_status,occupation)
	FROM 'D:\users.csv'
	DELIMITER ','
	CSV
	HEADER;
	end_time := clock_timestamp(); -- Record end time
	duration_seconds := EXTRACT(EPOCH FROM (end_time - start_time));
	RAISE NOTICE '>> Load Duration: % seconds', duration_seconds;
    RAISE NOTICE '>> -------------';


	-- ========================================
    -- LOAD RESTAURANTS TABLE
    -- ========================================
    start_time := clock_timestamp(); -- Record start time
    RAISE NOTICE '>> Inserting Data Into: restaurants';
	COPY restaurants (restaurant_id,restaurant_name,city,cuisine,rating,is_cloud_kitchen)
	FROM 'D:\restaurants.csv'
	DELIMITER ','
	CSV
	HEADER;
	end_time := clock_timestamp(); -- Record end time
	duration_seconds := EXTRACT(EPOCH FROM (end_time - start_time));
	RAISE NOTICE '>> Load Duration: % seconds', duration_seconds;
    RAISE NOTICE '>> -------------';


    -- ========================================
    -- LOAD MENU TABLE
    -- ========================================
    start_time := clock_timestamp(); -- Record start time
    RAISE NOTICE '>> Inserting Data Into: menu';
	COPY menu (menu_id,restaurant_id,item_name,category,price,is_veg)
	FROM 'D:\menu.csv'
	DELIMITER ','
	CSV
	HEADER;
	end_time := clock_timestamp(); -- Record end time
	duration_seconds := EXTRACT(EPOCH FROM (end_time - start_time));
	RAISE NOTICE '>> Load Duration: % seconds', duration_seconds;
    RAISE NOTICE '>> -------------';


    -- ========================================
    -- LOAD ORDERS TABLE
    -- ========================================
    start_time := clock_timestamp(); -- Record start time
    RAISE NOTICE '>> Inserting Data Into: orders';
	COPY orders (order_id,user_id,restaurant_id,order_date,delivery_time,
                    order_status,payment_method,total_amount)
	FROM 'D:\orders.csv'
	DELIMITER ','
	CSV
	HEADER;
	end_time := clock_timestamp(); -- Record end time
	duration_seconds := EXTRACT(EPOCH FROM (end_time - start_time));
	RAISE NOTICE '>> Load Duration: % seconds', duration_seconds;
    RAISE NOTICE '>> -------------';


    -- ========================================
    -- LOAD ORDER_ITEMS TABLE
    -- ========================================
    start_time := clock_timestamp(); -- Record start time
    RAISE NOTICE '>> Inserting Data Into: order_items';
	COPY order_items (order_item_id,order_id,menu_id,quantity,price)
	FROM 'D:\order_items.csv'
	DELIMITER ','
	CSV
	HEADER;
	end_time := clock_timestamp(); -- Record end time
	duration_seconds := EXTRACT(EPOCH FROM (end_time - start_time));
	RAISE NOTICE '>> Load Duration: % seconds', duration_seconds;
    RAISE NOTICE '>> -------------';


	-- ========================================
    -- FINAL SUMMARY
    -- ========================================
    batch_end_time := clock_timestamp(); -- Record end time
	duration_seconds := EXTRACT(EPOCH FROM (batch_end_time - batch_start_time));
	RAISE NOTICE '==========================================';
	RAISE NOTICE '>> Loading Data Process is Completed';
    RAISE NOTICE '>> Total Load Duration: % seconds ', duration_seconds;
	RAISE NOTICE '==========================================';

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '==========================================';
		RAISE NOTICE '❌ ERROR OCCURED DURING LOADING DATA INTO TABLES';
		RAISE NOTICE 'Error Message %', SQLERRM;
		RAISE NOTICE 'Error SQL State Code: %' , SQLSTATE;
		RAISE NOTICE '==========================================';
END
$$;