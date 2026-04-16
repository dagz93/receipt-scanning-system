-- PostgreSQL Database Schema for Receipt Scanning System

-- Users Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Receipts Table
CREATE TABLE receipts (
    receipt_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    ocr_data JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Receipt Line Items Table
CREATE TABLE receipt_line_items (
    line_item_id SERIAL PRIMARY KEY,
    receipt_id INT REFERENCES receipts(receipt_id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    price NUMERIC(10, 2) NOT NULL
);

-- Invoices Table
CREATE TABLE invoices (
    invoice_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE SET NULL,
    total_amount NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Bills Table
CREATE TABLE bills (
    bill_id SERIAL PRIMARY KEY,
    supplier_id INT REFERENCES suppliers(supplier_id) ON DELETE SET NULL,
    total_amount NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Products Table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Stock Levels Table
CREATE TABLE stock_levels (
    stock_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id) ON DELETE CASCADE,
    quantity_available INT NOT NULL
);

-- Stock Movements Table
CREATE TABLE stock_movements (
    movement_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id) ON DELETE CASCADE,
    movement_type VARCHAR(10) CHECK (movement_type IN ('IN', 'OUT')) NOT NULL,
    quantity INT NOT NULL,
    movement_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Customers Table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Suppliers Table
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_user_username ON users(username);
CREATE INDEX idx_receipt_user ON receipts(user_id);
CREATE INDEX idx_line_item_receipt ON receipt_line_items(receipt_id);
CREATE INDEX idx_invoice_user ON invoices(user_id);
CREATE INDEX idx_bill_supplier ON bills(supplier_id);
CREATE INDEX idx_product_name ON products(name);
CREATE INDEX idx_stock_product ON stock_levels(product_id);
CREATE INDEX idx_movement_product ON stock_movements(product_id);
CREATE INDEX idx_customer_email ON customers(email);
CREATE INDEX idx_supplier_email ON suppliers(email);