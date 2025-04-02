-- Create Database
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- Create Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create Cart table
CREATE TABLE cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_name VARCHAR(100),
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Create Wishlist table
CREATE TABLE wishlist (
    wishlist_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_name VARCHAR(100),
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert Sample Data into Users
INSERT INTO users (username, email) VALUES
('john_doe', 'john@example.com'),
('jane_smith', 'jane@example.com'),
('bob_jones', 'bob@example.com');

-- Insert Sample Data into Orders
INSERT INTO orders (user_id, total_amount) VALUES
(1, 199.99),
(1, 49.99),
(2, 89.99),
(3, 149.99);

-- Insert Sample Data into Cart
INSERT INTO cart (user_id, product_name, quantity, price) VALUES
(1, 'Wireless Mouse', 1, 29.99),
(2, 'USB Cable', 2, 9.99),
(3, 'Keyboard', 1, 49.99);

-- Insert Sample Data into Wishlist
INSERT INTO wishlist (user_id, product_name) VALUES
(1, 'Gaming Monitor'),
(2, 'Headphones'),
(3, 'SSD Drive');

-- Create Procedure to Delete User and Associated Data
DELIMITER //
CREATE PROCEDURE delete_user(IN p_user_id INT)
BEGIN
    -- The CASCADE constraints will automatically delete related records
    DELETE FROM users WHERE user_id = p_user_id;
    
    -- Check if user was deleted
    IF ROW_COUNT() > 0 THEN
        SELECT CONCAT('User ', p_user_id, ' and all associated data deleted successfully') AS message;
    ELSE
        SELECT CONCAT('User ', p_user_id, ' not found') AS message;
    END IF;
END //
DELIMITER ;

-- Example Usage of the Delete Procedure
-- View data before deletion
SELECT * FROM users;
SELECT * FROM orders;
SELECT * FROM cart;
SELECT * FROM wishlist;

-- Delete user with ID 1
CALL delete_user(1);

-- View data after deletion
SELECT * FROM users;
SELECT * FROM orders;
SELECT * FROM cart;
SELECT * FROM wishlist;

-- Optional: Clean up (uncomment to drop tables)
-- DROP TABLE wishlist;
-- DROP TABLE cart;
-- DROP TABLE orders;
-- DROP TABLE users;
-- DROP DATABASE ecommerce_db;
