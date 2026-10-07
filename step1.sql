CREATE TABLE restaurant_orders (
    order_id INT PRIMARY KEY,
    restaurant_id INT,
    total_amount DECIMAL(10,2),
    order_date DATE
);
INSERT INTO restaurant_orders
(order_id, restaurant_id, total_amount, order_date)
VALUES
(1, 1, 300, '2026-10-01'),
(2, 1, 200, '2026-10-05'),
(3, 1, 400, '2026-10-10'),
(4, 2, 500, '2026-10-03'),
(5, 2, 700, '2026-10-12');

DROP PROCEDURE IF EXISTS restaurant_monthly_summary;

DELIMITER //

CREATE PROCEDURE restaurant_monthly_summary(
    IN p_restaurant_id INT,
    IN p_month INT
)
BEGIN
    DECLARE v_order_count INT;

    IF p_month < 1 OR p_month > 12 THEN

        SELECT 'Invalid month. Enter a month from 1 to 12.' AS Message;

    ELSE

        SELECT COUNT(*)
        INTO v_order_count
        FROM restaurant_orders
        WHERE restaurant_id = p_restaurant_id
        AND MONTH(order_date) = p_month;

        IF v_order_count = 0 THEN

            SELECT
                'No orders found for this restaurant in the selected month.'
                AS Message;

        ELSE

            SELECT
                restaurant_id,
                COUNT(order_id) AS total_orders,
                SUM(total_amount) AS total_revenue,
                AVG(total_amount) AS average_order_value
            FROM restaurant_orders
            WHERE restaurant_id = p_restaurant_id
            AND MONTH(order_date) = p_month
            GROUP BY restaurant_id;

        END IF;

    END IF;
END //

DELIMITER ;


CALL restaurant_monthly_summary(1, 10);
CALL restaurant_monthly_summary(2, 10);
