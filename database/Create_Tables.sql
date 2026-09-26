/*
===============================================================================
DDL Script: Create Tables
===============================================================================
Script Purpose:
    Creates normalized tables for Swiggy database with:
    - Proper data types and constraints
    - Comprehensive indexing for performance
===============================================================================
*/

-- Drop Tables if they exist (in correct order - child tables first)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menu;
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS users;

-- ===============================================================================
-- USERS TABLE
-- ===============================================================================
CREATE TABLE IF NOT EXISTS users (
    user_id             VARCHAR(10) PRIMARY KEY,
    user_name           VARCHAR(100) NOT NULL,
    age                 INTEGER NOT NULL,
    gender              VARCHAR(10) NOT NULL,
    marital_status      VARCHAR(20) NOT NULL,
    occupation          VARCHAR(50) NOT NULL
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_users_age ON users(age);
CREATE INDEX IF NOT EXISTS idx_users_gender ON users(gender);
CREATE INDEX IF NOT EXISTS idx_users_occupation ON users(occupation);
CREATE INDEX IF NOT EXISTS idx_users_marital_status ON users(city);


-- ===============================================================================
-- RESTAURANTS TABLE
-- ===============================================================================
CREATE TABLE IF NOT EXISTS restaurants (
    restaurant_id       VARCHAR(10) PRIMARY KEY,
    restaurant_name     VARCHAR(100) NOT NULL,
    city                VARCHAR(50) NOT NULL,
    cuisine             VARCHAR(50) NOT NULL,
    rating              DECIMAL(2,1) NOT NULL,
    is_cloud_kitchen    INT NOT NULL
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_restaurants_city ON restaurants(city);
CREATE INDEX IF NOT EXISTS idx_restaurants_cuisine ON restaurants(cuisine);
CREATE INDEX IF NOT EXISTS idx_restaurants_rating ON restaurants(rating);
CREATE INDEX IF NOT EXISTS idx_restaurants_cloud_kitchen ON restaurants(is_cloud_kitchen);


-- ===============================================================================
-- MENU TABLE
-- ===============================================================================
CREATE TABLE IF NOT EXISTS menu (
    menu_id             VARCHAR(10) PRIMARY KEY,
    restaurant_id       VARCHAR(10) NOT NULL,
    item_name           VARCHAR(100) NOT NULL,
    category            VARCHAR(50) NOT NULL,
    price               DECIMAL(10,2) NOT NULL CHECK (price > 0),
    is_veg              SMALLINT NOT NULL,
    
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_menu_restaurant ON menu(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_menu_category ON menu(category);
CREATE INDEX IF NOT EXISTS idx_menu_price ON menu(price);
CREATE INDEX IF NOT EXISTS idx_menu_is_veg ON menu(is_veg);


-- ===============================================================================
-- ORDERS TABLE
-- ===============================================================================
CREATE TABLE IF NOT EXISTS orders (
    order_id            VARCHAR(15) PRIMARY KEY,
    user_id             VARCHAR(10) NOT NULL,
    restaurant_id       VARCHAR(10) NOT NULL,
    order_date          DATE NOT NULL,
    delivery_time       TIME NOT NULL,
    order_status        VARCHAR(20) NOT NULL,
    payment_method      VARCHAR(30) NOT NULL,
    total_amount        DECIMAL(10,2) NOT NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_orders_user ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_restaurant ON orders(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_orders_date ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(order_status);
CREATE INDEX IF NOT EXISTS idx_orders_payment ON orders(payment_method);
CREATE INDEX IF NOT EXISTS idx_orders_date_status ON orders(order_date, order_status);


-- ===============================================================================
-- ORDER_ITEMS TABLE
-- ===============================================================================
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id       VARCHAR(15) PRIMARY KEY,
    order_id            VARCHAR(15) NOT NULL,
    menu_id             VARCHAR(10) NOT NULL,
    quantity            INTEGER NOT NULL,
    price               DECIMAL(10,2) NOT NULL,
    
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (menu_id) REFERENCES menu(menu_id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_menu ON order_items(menu_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_menu ON order_items(order_id, menu_id);


-- ===============================================================================
-- COMMENTS (Documentation)
-- ===============================================================================
COMMENT ON TABLE users IS 'Customer/user master data';
COMMENT ON TABLE restaurants IS 'Restaurant partner master data';
COMMENT ON TABLE menu IS 'Menu items offered by restaurants';
COMMENT ON TABLE orders IS 'Order header with delivery and payment info';
COMMENT ON TABLE order_items IS 'Individual items in each order (order lines)';
