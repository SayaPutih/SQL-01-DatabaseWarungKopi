/*Function*/
DELIMITER //
CREATE OR REPLACE FUNCTION create_id(
    first_name CHAR(100),
    last_name CHAR(100),
    phone INT
)
RETURNS VARCHAR(100) DETERMINISTIC
BEGIN   
    RETURN CONCAT('C-',LEFT(phone,3),'-',LEFT(first_name,3),LEFT(last_name,3));
END //
DELIMITER ;