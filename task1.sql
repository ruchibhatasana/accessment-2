
CREATE DATABASE foodapp_db;


USE foodapp_db;


CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    cuisine_type VARCHAR(50),
    rating DECIMAL(3,1)
);


INSERT INTO restaurants (name, city, cuisine_type, rating)
VALUES
('Food Plaza', 'Rajkot', 'Indian', 4.2),
('Spice Garden', 'Ahmedabad', 'Gujarati', 4.5),
('Pizza House', 'Surat', 'Italian', 4.0),
('Tasty Bites', 'Rajkot', 'Chinese', 4.3),
('Royal Dine', 'Ahmedabad', 'Punjabi', 4.6),
('Green Leaf', 'Surat', 'South Indian', 3.9);


UPDATE restaurants
SET rating = 4.7
WHERE restaurant_id = 1;


DELETE FROM restaurants
WHERE restaurant_id = 6;


SELECT *
FROM restaurants
ORDER BY rating DESC;