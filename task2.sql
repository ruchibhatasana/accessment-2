
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    restaurant_id INT,
    customer_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE
);


INSERT INTO orders
(order_id, restaurant_id, customer_name, total_amount, order_date)
VALUES
(1, 101, 'Ravi', 1800, '2026-10-01'),
(2, 101, 'Priya', 2200, '2026-10-02'),
(3, 101, 'Amit', 1500, '2026-10-03'),
(4, 102, 'Neha', 3000, '2026-10-04'),
(5, 102, 'Rahul', 2500, '2026-10-05'),
(6, 102, 'Pooja', 1800, '2026-10-06'),
(7, 103, 'Karan', 1200, '2026-10-07'),
(8, 103, 'Meena', 1600, '2026-10-08'),
(9, 103, 'Jay', 1400, '2026-10-09'),
(10, 104, 'Riya', 3500, '2026-10-10'),
(11, 104, 'Vikas', 2000, '2026-10-11'),
(12, 104, 'Anjali', 1800, '2026-10-12');


SELECT restaurant_id,
       SUM(total_amount) AS total_revenue,
       AVG(total_amount) AS average_order_value
FROM orders
GROUP BY restaurant_id;


SELECT restaurant_id,
       SUM(total_amount) AS total_revenue
FROM orders
GROUP BY restaurant_id
HAVING SUM(total_amount) > 5000;


SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 5;