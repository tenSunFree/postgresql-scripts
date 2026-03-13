-- If the orders table already exists, delete it first.
-- CASCADE indicates that if other objects depend on this table, they will also be processed.
DROP TABLE IF EXISTS orders CASCADE;

-- Create the orders table
CREATE TABLE orders (
     order_id SERIAL PRIMARY KEY, -- Order ID, auto-incrementing, and primary key.

    customer_id INTEGER NOT NULL, -- Customer ID, cannot be empty, used to correspond to the customers table.

    order_date DATE NOT NULL DEFAULT CURRENT_DATE, -- Order date, cannot be empty, defaults to today's date.

    total_amount DECIMAL(12, 2) NOT NULL CHECK (total_amount >= 0), -- Total order amount, cannot be empty, and must not be less than 0.

    status VARCHAR(20) NOT NULL DEFAULT 'Pending' -- Order status, cannot be empty, defaults to Pending
        CHECK (status IN ('Pending', 'Shipped', 'Completed', 'Cancelled')), -- The restricted state can only be one of these fixed values.

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Creation time, including time zone, cannot be empty, defaults to the current time.

    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Update time, including time zone, cannot be empty, defaults to current time.

    CONSTRAINT fk_orders_customer -- Foreign key constraint name
        FOREIGN KEY (customer_id) -- Specify customer_id as a foreign key field
        REFERENCES customers(customer_id) -- Refer to customer_id in the customers table
        ON DELETE CASCADE -- If the customer's information is deleted, the related orders will also be deleted.
);

-- Create a customer_id index to speed up order retrieval by customer.
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- Create a status index to speed up queries based on order status.
CREATE INDEX idx_orders_status ON orders(status);

--Create an index on order_date to speed up queries or sorting by order date.
CREATE INDEX idx_orders_order_date ON orders(order_date);