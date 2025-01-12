/*Trigger*/
DELIMITER //
CREATE OR REPLACE TRIGGER after_employee_left
    AFTER DELETE ON employee FOR EACH ROW
BEGIN 
    DECLARE full_name VARCHAR(255);
    SET full_name = CONCAT(OLD.first_name_e,' ',OLD.last_name_e);
    INSERT INTO history_employee (full_name,date_leave,time_leave)
    VALUES (full_name,CURDATE(),CURTIME());
END //
DELIMITER ;
