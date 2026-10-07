
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);


CREATE TABLE menu_items (
    item_id INT PRIMARY KEY,
    restaurant_id INT,
    item_name VARCHAR(100),
    price DECIMAL(10,2),
    category VARCHAR(50),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

INSERT INTO restaurants (restaurant_id, name, city)
VALUES
(1, 'Food Plaza', 'Rajkot'),
(2, 'Spice Garden', 'Ahmedabad'),
(3, 'Pizza House', 'Surat'),
(4, 'Tasty Bites', 'Vadodara'),
(5, 'Green Leaf', 'Rajkot');


INSERT INTO menu_items
(item_id, restaurant_id, item_name, price, category)
VALUES
(1, 1, 'Paneer Tikka', 250, 'Starter'),
(2, 1, 'Veg Biryani', 220, 'Main Course'),
(3, 1, 'Cold Coffee', 120, 'Drink'),

(4, 2, 'Dhokla', 100, 'Gujarati'),
(5, 2, 'Gujarati Thali', 300, 'Main Course'),
(6, 2, 'Fafda Jalebi', 150, 'Snack'),

(7, 3, 'Margherita Pizza', 350, 'Pizza'),
(8, 3, 'Farmhouse Pizza', 450, 'Pizza'),
(9, 3, 'Garlic Bread', 180, 'Starter'),

(10, 4, 'Veg Sandwich', 150, 'Snack'),
(11, 4, 'Pasta', 250, 'Main Course'),
(12, 4, 'Lassi', 100, 'Drink');


SELECT restaurants.name, menu_items.item_name, menu_items.price
FROM restaurants
INNER JOIN menu_items
ON restaurants.restaurant_id = menu_items.restaurant_id;


SELECT restaurants.name, menu_items.item_name, menu_items.price
FROM restaurants
LEFT JOIN menu_items
ON restaurants.restaurant_id = menu_items.restaurant_id;

CREATE VIEW restaurant_menu_summary AS
SELECT 
    restaurants.name AS restaurant_name,
    COUNT(menu_items.item_id) AS total_menu_items,
    AVG(menu_items.price) AS average_item_price
FROM restaurants
LEFT JOIN menu_items
ON restaurants.restaurant_id = menu_items.restaurant_id
GROUP BY restaurants.restaurant_id, restaurants.name;


SELECT * FROM restaurant_menu_summary;