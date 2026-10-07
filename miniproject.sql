
CREATE DATABASE IF NOT EXISTS food_delivery;
USE food_delivery;


CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    cuisine_type VARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL
);

CREATE TABLE menu_items (
    item_id INT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50) NOT NULL,

    FOREIGN KEY (restaurant_id)
    REFERENCES restaurants(restaurant_id)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    restaurant_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date DATE NOT NULL,

    FOREIGN KEY (restaurant_id)
    REFERENCES restaurants(restaurant_id),

    FOREIGN KEY (item_id)
    REFERENCES menu_items(item_id)
);

CREATE TABLE order_audit (
    order_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    action VARCHAR(20) NOT NULL,
    log_time DATETIME NOT NULL
);

INSERT INTO restaurants
(restaurant_id, name, city, cuisine_type, created_at)
VALUES
(1, 'Spice Garden', 'Rajkot', 'Indian', NOW()),
(2, 'Pizza Hub', 'Ahmedabad', 'Italian', NOW()),
(3, 'Food Corner', 'Surat', 'Chinese', NOW());

INSERT INTO menu_items
(item_id, restaurant_id, item_name, price, category)
VALUES
(101, 1, 'Paneer Tikka', 180.00, 'Starter'),
(102, 1, 'Veg Biryani', 220.00, 'Main Course'),
(103, 1, 'Gulab Jamun', 80.00, 'Dessert'),
(104, 1, 'Masala Chai', 50.00, 'Beverage'),

(201, 2, 'Margherita Pizza', 250.00, 'Pizza'),
(202, 2, 'Farmhouse Pizza', 350.00, 'Pizza'),
(203, 2, 'Garlic Bread', 150.00, 'Starter'),
(204, 2, 'Cold Coffee', 120.00, 'Beverage'),

(301, 3, 'Veg Noodles', 180.00, 'Main Course'),
(302, 3, 'Manchurian', 200.00, 'Starter'),
(303, 3, 'Fried Rice', 190.00, 'Main Course'),
(304, 3, 'Ice Cream', 90.00, 'Dessert');

INSERT INTO orders
(customer_name, restaurant_id, item_id, quantity, total_amount, order_date)
VALUES
('Riya', 1, 101, 2, 360.00, '2026-10-01'),
('Neha', 1, 102, 1, 220.00, '2026-10-01'),
('Amit', 1, 103, 2, 160.00, '2026-10-02'),
('Rahul', 1, 104, 3, 150.00, '2026-10-02'),
('Priya', 1, 101, 1, 180.00, '2026-10-03'),

('Karan', 2, 201, 1, 250.00, '2026-10-01'),
('Meera', 2, 202, 2, 700.00, '2026-10-02'),
('Jay', 2, 203, 1, 150.00, '2026-10-03'),
('Pooja', 2, 204, 2, 240.00, '2026-10-04'),
('Vishal', 2, 201, 2, 500.00, '2026-10-05'),

('Nisha', 3, 301, 1, 180.00, '2026-10-01'),
('Rohan', 3, 302, 2, 400.00, '2026-10-02'),
('Anjali', 3, 303, 1, 190.00, '2026-10-03'),
('Mihir', 3, 304, 3, 270.00, '2026-10-04'),
('Kavya', 3, 301, 2, 360.00, '2026-10-05');

CREATE OR REPLACE VIEW restaurant_sales_summary AS
SELECT
    r.name AS restaurant_name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_revenue
FROM restaurants r
LEFT JOIN orders o
ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.name;

DROP PROCEDURE IF EXISTS add_order;

DELIMITER //

CREATE PROCEDURE add_order(
    IN p_customer_name VARCHAR(100),
    IN p_restaurant_id INT,
    IN p_item_id INT,
    IN p_quantity INT
)
BEGIN

    DECLARE v_price DECIMAL(10,2);
    DECLARE v_restaurant_count INT;
    DECLARE v_total DECIMAL(10,2);

    START TRANSACTION;

    SELECT COUNT(*)
    INTO v_restaurant_count
    FROM restaurants
    WHERE restaurant_id = p_restaurant_id;

    IF v_restaurant_count = 0 THEN

        ROLLBACK;

        SELECT 'Restaurant does not exist. Order cancelled.' AS Message;

    ELSE

        SELECT price
        INTO v_price
        FROM menu_items
        WHERE item_id = p_item_id
        AND restaurant_id = p_restaurant_id;

        SET v_total = v_price * p_quantity;

        INSERT INTO orders
        (
            customer_name,
            restaurant_id,
            item_id,
            quantity,
            total_amount,
            order_date
        )
        VALUES
        (
            p_customer_name,
            p_restaurant_id,
            p_item_id,
            p_quantity,
            v_total,
            CURDATE()
        );

        COMMIT;

        SELECT 'Order added successfully.' AS Message;

    END IF;

END //

DELIMITER ;

DROP TRIGGER IF EXISTS after_order_insert;

DELIMITER //

CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN

    INSERT INTO order_audit
    (
        order_id,
        restaurant_id,
        action,
        log_time
    )
    VALUES
    (
        NEW.order_id,
        NEW.restaurant_id,
        'INSERT',
        NOW()
    );

END //

DELIMITER ;

SELECT * FROM restaurant_sales_summary;

CALL add_order('Ruchi', 1, 101, 2);

CALL add_order('Ruchi', 99, 101, 2);

SELECT * FROM orders;

SELECT * FROM order_audit;

SELECT * FROM orders;

SELECT * FROM restaurant_sales_summary;

CALL add_order('Ruchi', 1, 101, 2);

CALL add_order('Ruchi', 99, 101, 2);

SELECT * FROM order_audit;

