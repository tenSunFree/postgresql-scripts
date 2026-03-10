-- If customers already exist, delete them first.
DROP TABLE IF EXISTS customers;

-- Create the most basic customers table.
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY, -- Customer ID (auto-incrementing primary key)
    company_name VARCHAR(100) NOT NULL, -- Company name, cannot be empty
    city VARCHAR(50), -- City
    country VARCHAR(50), -- nation
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Creation time, preset to the current time
);