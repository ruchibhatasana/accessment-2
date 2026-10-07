DROP PROCEDURE IF EXISTS restaurant_monthly_summary;

DELIMITER //

CREATE PROCEDURE restaurant_monthly_summary(
    IN p_restaurant_id INT,
    IN p_month INT
)
BEGIN
    SELECT
        restaurant_id,
        COUNT(order_id) AS total_orders,
        SUM(total_amount) AS total_revenue,
        AVG(total_amount) AS average_order_value
    FROM restaurant_orders
    WHERE restaurant_id = p_restaurant_id
      AND MONTH(order_date) = p_month
    GROUP BY restaurant_id;
END //

DELIMITER ;