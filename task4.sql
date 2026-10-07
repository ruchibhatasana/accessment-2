
CREATE TABLE customer_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    amount DECIMAL(10,2),
    order_date DATE
);


DROP PROCEDURE IF EXISTS place_order;

DELIMITER //

CREATE PROCEDURE place_order(
    IN p_customer_id INT,
    IN p_restaurant_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE v_wallet DECIMAL(10,2);

    START TRANSACTION;

    SELECT wallet_balance
    INTO v_wallet
    FROM customers
    WHERE customer_id = p_customer_id
    FOR UPDATE;

    IF v_wallet >= p_amount THEN

        UPDATE customers
        SET wallet_balance = wallet_balance - p_amount
        WHERE customer_id = p_customer_id;

        INSERT INTO customer_orders
        (customer_id, restaurant_id, amount, order_date)
        VALUES
        (p_customer_id, p_restaurant_id, p_amount, CURDATE());

        COMMIT;

        SELECT 'Order placed successfully' AS Message;

    ELSE

        ROLLBACK;

        SELECT 'Insufficient wallet balance' AS Message;

    END IF;

END //

DELIMITER ;



CALL place_order(1, 101, 300);


SELECT * FROM customers;


SELECT * FROM customer_orders;



CALL place_order(1, 101, 2000);


SELECT * FROM customers;


SELECT * FROM customer_orders;
CALL place_order(1, 101, 300);
CALL place_order(1, 101, 2000);