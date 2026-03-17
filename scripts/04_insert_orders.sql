-- Objective: To populate the orders table with basic test data.
-- Notice:
-- 1. Please execute first. 01_create_customers.sql、02_insert_customers.sql、03_create_orders.sql
-- 2. customer_id It must already exist in the customers table.
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES
    (1, DATE '2024-03-01', 500.00),    -- Customer 1: First order
    (1, DATE '2024-03-05', 1200.50),   -- Customer 1: Second order
    (2, DATE '2024-03-10', 350.00),    
    (3, DATE '2024-03-15', 2100.00);   

-- Verification materials
SELECT * FROM orders;