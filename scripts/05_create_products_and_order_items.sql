-- Objective:
-- 1. Create the products table
-- 2. Create the order_items table
-- 3. Build a complete relationship among customers, orders, and products

-- If order_items already exists, drop it first
DROP TABLE IF EXISTS order_items;

-- If products already exists, drop it first
DROP TABLE IF EXISTS products;

-- Create the products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY, -- Product ID, auto-incrementing primary key
    product_name VARCHAR(100) NOT NULL, -- Product name, cannot be empty
    price DECIMAL(12, 2) NOT NULL CHECK (price >= 0), -- Product price, must be >= 0
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0), -- Inventory quantity, must be >= 0
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Creation time
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP -- Update time
);

-- Create the order_items table
CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY, -- Order item ID, auto-incrementing primary key

    order_id INTEGER NOT NULL, -- Order ID, foreign key to orders table
    product_id INTEGER NOT NULL, -- Product ID, foreign key to products table

    quantity INTEGER NOT NULL CHECK (quantity > 0), -- Purchase quantity, must be greater than 0
    unit_price DECIMAL(12, 2) NOT NULL CHECK (unit_price >= 0), -- Purchase price at the time of ordering

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Creation time
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Update time

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT uq_order_items_order_product
        UNIQUE (order_id, product_id) -- Prevent duplicate product rows in the same order
);

-- Create indexes for faster joins and filtering
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_products_product_name ON products(product_name);

-- Insert test data into products
INSERT INTO products (product_name, price, stock_quantity)
VALUES
    ('iPhone 15', 29900.00, 50),
    ('MacBook Air', 32900.00, 20),
    ('AirPods', 5990.00, 100),
    ('iPad Air', 21900.00, 35),
    ('Apple Watch', 12900.00, 60);

-- Insert test data into order_items
-- Notice:
-- order_id must already exist in orders table
-- product_id must already exist in products table
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 1, 29900.00), -- Order 1 buys 1 iPhone 15
    (1, 3, 2, 5990.00),  -- Order 1 buys 2 AirPods
    (2, 2, 1, 32900.00), -- Order 2 buys 1 MacBook Air
    (3, 4, 1, 21900.00), -- Order 3 buys 1 iPad Air
    (4, 5, 1, 12900.00); -- Order 4 buys 1 Apple Watch
ON CONFLICT (order_id, product_id) DO NOTHING;

-- Verification query
SELECT * FROM products ORDER BY product_id;
SELECT * FROM order_items ORDER BY item_id;