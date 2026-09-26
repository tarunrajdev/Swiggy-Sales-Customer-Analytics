/*
===============================================================================
DDL Script: Create Aggregated Tables
===============================================================================
Script Purpose:
    Creates normalized Aggregated tables for Swiggy database with:
    - Users + Restaurants + Orders = orders_master
    - Menu + Order_Items = order_items_master
    - Proper data types and constraints
    - Comprehensive indexing for performance
===============================================================================
*/

-- ===============================================================================
-- DROP TABLES IF THEY EXISTS
-- ===============================================================================
DROP TABLE IF EXISTS orders_master CASCADE;
DROP TABLE IF EXISTS order_items_master CASCADE;


-- ===============================================================================
-- ORDERS_MASTER TABLE
-- ===============================================================================
CREATE TABLE orders_master AS
WITH repeat_users AS (
    SELECT
        user_id,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY user_id
)
SELECT 
    -- Order Information
    o.order_id,
    o.order_date,
    o.delivery_time,
    o.order_status,
    o.payment_method,
    o.total_amount,
    
    -- User Information
    o.user_id,
    u.user_name,
    u.age,
    u.gender,
    u.marital_status,
    u.occupation,
    
    -- Age Group
    CASE 
        WHEN u.age < 18 THEN 'Under 18'
        WHEN u.age BETWEEN 18 AND 25 THEN '18-25'
        WHEN u.age BETWEEN 26 AND 35 THEN '26-35'
        WHEN u.age BETWEEN 36 AND 45 THEN '36-45'
        WHEN u.age BETWEEN 46 AND 55 THEN '46-55'
        WHEN u.age >= 56 THEN '56+'
        ELSE 'Unknown' -- Handles NULL values if they exist
    END as age_group,
    
    -- Repeat Customer
    CASE
        WHEN ru.total_orders > 1 THEN TRUE
        ELSE FALSE
    END AS is_repeat_customer,
    
    -- Restaurant Information
    o.restaurant_id,
    r.restaurant_name,
    r.city,
    r.cuisine,
    r.rating as restaurant_rating,
    
    -- Rating Category
    CASE 
        WHEN r.rating > 0 AND r.rating <= 2 THEN 'Poor'
        WHEN r.rating > 2 AND r.rating <= 3 THEN 'Average'
        WHEN r.rating > 3 AND r.rating <= 4 THEN 'Good'
        WHEN r.rating > 4 AND r.rating <= 4.5 THEN 'Very Good'
        WHEN r.rating > 4.5 AND r.rating <= 5 THEN 'Excellent'
        ELSE 'No Rating' -- Handles 0 or NULL values
    END AS rating_bucket,

    -- Restaurant Type
    CASE 
        WHEN r.is_cloud_kitchen = 1 THEN 'Cloud Kitchen'
        ELSE 'Traditional'
    END as restaurant_type,
    
    -- Derived Fields
    EXTRACT(YEAR FROM o.order_date) as order_year,
    EXTRACT(MONTH FROM o.order_date) as order_month,
    EXTRACT(QUARTER FROM o.order_date) as order_quarter,
    EXTRACT(DOW FROM o.order_date) as day_of_week,  -- 0=Sunday, 6=Saturday
    CASE 
        WHEN EXTRACT(DOW FROM o.order_date) IN (0, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END as day_type,
    
    CASE 
        WHEN EXTRACT(HOUR FROM o.delivery_time) BETWEEN 8 AND 11 THEN 'Breakfast'
        WHEN EXTRACT(HOUR FROM o.delivery_time) BETWEEN 12 AND 14 THEN 'Lunch'
        WHEN EXTRACT(HOUR FROM o.delivery_time) BETWEEN 15 AND 17 THEN 'Snack'
        WHEN EXTRACT(HOUR FROM o.delivery_time) BETWEEN 18 AND 22 THEN 'Dinner'
        ELSE 'Late Night'
    END as time_slot
    
FROM orders o
INNER JOIN users u ON o.user_id = u.user_id
LEFT JOIN repeat_users ru ON o.user_id = ru.user_id
INNER JOIN restaurants r ON o.restaurant_id = r.restaurant_id;


-- ===============================================================================
-- ORDERS_MASTER INDEXES
-- ===============================================================================
CREATE INDEX IF NOT EXISTS idx_om_user_id ON orders_master(user_id);
CREATE INDEX IF NOT EXISTS idx_om_restaurant_id ON orders_master(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_om_order_status ON orders_master(order_status);
CREATE INDEX IF NOT EXISTS idx_om_order_date ON orders_master(order_date);
CREATE INDEX IF NOT EXISTS idx_om_year_month ON orders_master(order_year, order_month);
CREATE INDEX IF NOT EXISTS idx_om_city ON orders_master(city);
CREATE INDEX IF NOT EXISTS idx_om_cuisine ON orders_master(cuisine);
CREATE INDEX IF NOT EXISTS idx_om_is_repeat_customer ON orders_master(is_repeat_customer);
CREATE INDEX IF NOT EXISTS idx_om_rating_bucket ON orders_master(rating_bucket);
CREATE INDEX IF NOT EXISTS idx_om_restaurant_type ON orders_master(restaurant_type);
CREATE INDEX IF NOT EXISTS idx_om_age_group ON orders_master(age_group);
CREATE INDEX IF NOT EXISTS idx_om_day_type ON orders_master(day_type);
CREATE INDEX IF NOT EXISTS idx_om_time_slot ON orders_master(time_slot);
CREATE INDEX IF NOT EXISTS idx_om_payment_method ON orders_master(payment_method);

-- Customer Segmentation Queries
CREATE INDEX IF NOT EXISTS idx_om_repeat_status_date 
ON orders_master(is_repeat_customer, order_status, order_date);

-- Restaurant Performance Analysis
CREATE INDEX IF NOT EXISTS idx_om_type_rating_city 
ON orders_master(restaurant_type, rating_bucket, city);

-- Demographic Analysis
CREATE INDEX IF NOT EXISTS idx_om_status_age_date 
ON orders_master(order_status, age_group, order_date);

-- Time-based Operational Queries
CREATE INDEX IF NOT EXISTS idx_om_status_date_timeslot 
ON orders_master(order_status, order_date, time_slot);


-- ===============================================================================
-- ORDER_ITEMS_MASTER TABLE
-- ===============================================================================
CREATE TABLE order_items_master AS
SELECT 
    -- Order Item Information
    oi.order_item_id,
    oi.order_id,
    oi.quantity,
    m.price as menu_price,
    (oi.quantity * m.price) as line_total,
    
    -- Menu Information
    oi.menu_id,
    m.restaurant_id,
    m.item_name,
    m.category,
    
    -- Derived Fields
    CASE 
        WHEN m.is_veg = 1 THEN 'Veg'
        ELSE 'Non-Veg'
    END as item_type,
    
    -- Price Category    
    CASE 
        WHEN m.price < 100 THEN 'Budget (<100)'
        WHEN m.price < 200 THEN 'Economic (100-199)'  
        WHEN m.price < 300 THEN 'Mid-Range (200-299)' 
        WHEN m.price < 400 THEN 'Premium (300-399)'   
        ELSE 'Luxury (400+)' 
    END as price_category
    
FROM order_items oi
INNER JOIN menu m ON oi.menu_id = m.menu_id;


-- ===============================================================================
-- ORDER_ITEMS_MASTER INDEXES
-- ===============================================================================
CREATE INDEX IF NOT EXISTS idx_oim_order_id ON order_items_master(order_id);
CREATE INDEX IF NOT EXISTS idx_oim_menu_id ON order_items_master(menu_id);
CREATE INDEX IF NOT EXISTS idx_oim_restaurant_id ON order_items_master(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_oim_category ON order_items_master(category);
CREATE INDEX IF NOT EXISTS idx_oim_item_type ON order_items_master(item_type);
CREATE INDEX IF NOT EXISTS idx_oim_price_category ON order_items_master(price_category);


-- ===============================================================================
-- COMMENTS (Documentation)
-- ===============================================================================
COMMENT ON TABLE orders_master IS 'Users + Restaurants + Orders Aggregated data';
COMMENT ON TABLE order_items_master IS 'Menu + Order_Items Aggregated data';
