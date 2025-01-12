/*Procedure*/
DELIMITER //
CREATE OR REPLACE PROCEDURE register_customer(
    IN full_name CHAR(100),
    IN phone VARCHAR(12),
    IN gender CHAR(1),
    IN alamat CHAR(100)
)
BEGIN
    DECLARE id_maker CHAR(100);
    DECLARE first_name CHAR(100);
    DECLARE last_name CHAR(100);
    DECLARE is_avail INT;

    CREATE TEMPORARY TABLE result(
        sentence CHAR(100)
    );

    SET first_name = SUBSTRING(full_name, 1, LOCATE(' ', full_name) - 1);
    SET last_name = SUBSTRING(full_name, LOCATE(' ', full_name) + 1);
    SET id_maker = (create_id(first_name,last_name,phone));

    SELECT COUNT(*) INTO is_avail FROM registered_customer WHERE id_customer = id_maker;
    IF is_avail = 0 THEN 
        INSERT INTO registered_customer
        (id_customer,first_name_c,last_name_c,gender_c,phone_c,alamat_C)
        VALUES 
        (id_maker,first_name,last_name,gender,phone,alamat);

        INSERT INTO result(sentence) VALUES 
        (CONCAT('Successfully Registered Customer!')),
        (CONCAT('Name : ',full_name)),
        (CONCAT('ID   : ',id_maker));

    ELSE 
        INSERT INTO result(sentence) VALUES 
        (CONCAT('Customered Is regiestered Already!'));
    END IF;

    SELECT sentence 'Result' FROM result;
    DROP TEMPORARY TABLE IF EXISTS result;

END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE kick_employee(
    IN id_kick VARCHAR(100),
    IN alesan_nya CHAR(100)
)
BEGIN
    DECLARE name CHAR(100);
    SELECT CONCAT(first_name_e,' ',last_name_e) INTO name FROM employee WHERE id_employee = id_kick;
    DELETE FROM employee WHERE id_employee = id_kick;
    UPDATE history_employee SET alesan = alesan_nya WHERE full_name = name;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE cari_meja(
    IN total_orang INT
)
BEGIN
    DECLARE total_meja INT;
    DECLARE nomor_meja VARCHAR(100);
    DECLARE i INT; 
    DECLARE latest_order_id VARCHAR(100);
    
    DECLARE cari_meja CURSOR FOR 
        SELECT id_meja 
        FROM meja 
        WHERE is_avail = TRUE AND jumlah_bangku >= total_orang; 

    CREATE TEMPORARY TABLE hasil(
        result CHAR(100)
    ); 

    SET i = 0;

    SELECT COUNT(*) INTO total_meja 
    FROM meja 
    WHERE is_avail = TRUE AND jumlah_bangku >= total_orang;
    
    IF total_meja > 0 THEN 
        OPEN cari_meja;

        FETCH cari_meja INTO nomor_meja;
        
        INSERT INTO hasil(result) 
        VALUES(CONCAT('Ketemu meja buat ', total_orang, ' di [', nomor_meja, ']'));

        SELECT CONCAT('OO', LPAD(CAST(COALESCE(MAX(CAST(SUBSTRING(id_order, 3) AS UNSIGNED)), 0) + 1 AS CHAR), 4, '0'))
        INTO latest_order_id
        FROM orders;

        INSERT INTO orders(id_order, id_employee, id_meja, date_order, payment_status)
        VALUES(latest_order_id, NULL, nomor_meja, CURDATE(), 'UNPAID');

        UPDATE meja 
        SET is_avail = FALSE 
        WHERE id_meja = nomor_meja;
        
        CLOSE cari_meja;
    ELSE 
        INSERT INTO hasil(result) 
        VALUES('Gaada Meja yang Available');
    END IF;

    SELECT * FROM hasil;
    DROP TABLE IF EXISTS hasil;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE pesan_makanan(
    IN no_meja VARCHAR(100),
    IN makanan CHAR(30),
    IN jumlah INT
)
BEGIN
    DECLARE find_id_order VARCHAR(100);
    DECLARE find_id_makanan VARCHAR(100);
    DECLARE tot_harga INT;
    DECLARE i INT;
    DECLARE found_or_not INT;
    SELECT COUNT(*) INTO i FROM orders AS o
    WHERE id_meja = no_meja AND payment_status = 'UNPAID';
    SELECT COUNT(*) INTO found_or_not
        FROM menu 
        WHERE nama_makanan LIKE CONCAT('%', makanan, '%') LIMIT 1;
    IF found_or_not > 0 THEN
        IF i > 0 THEN
            SELECT id_makanan INTO find_id_makanan 
            FROM menu 
            WHERE nama_makanan LIKE CONCAT('%', makanan, '%') LIMIT 1;

            SELECT harga_makanan INTO tot_harga 
            FROM menu 
            WHERE nama_makanan LIKE CONCAT('%', makanan, '%') LIMIT 1;
            SET tot_harga = tot_harga * jumlah;

            SELECT id_order INTO find_id_order 
            FROM orders AS o 
            WHERE id_meja = no_meja AND payment_status = 'UNPAID';

            INSERT INTO orderdetails (id_order, id_makanan, qty, total_harga)
            VALUES (find_id_order, find_id_makanan, jumlah, tot_harga);

            SELECT 'Successfully Input' AS Details;
        ELSE
            SELECT 'Failed to Input' AS Details;
        END IF;
    ELSE 
        SELECT 'Menu Tidak Ada' AS Details;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE checkout(
    IN nomor_meja VARCHAR(100),
    IN input_id VARCHAR(100)
)
BEGIN
    DECLARE total_meja INT;
    DECLARE id_makan VARCHAR(100);
    DECLARE jumlah INT;
    DECLARE harga INT;
    DECLARE nama_makan CHAR(30);
    DECLARE i INT;
    DECLARE total_bill INT;
    DECLARE orderidvar VARCHAR(100);
    DECLARE take_data CURSOR FOR 
        SELECT id_makanan, qty, total_harga 
        FROM orderdetails AS od 
        JOIN orders AS o ON (od.id_order = o.id_order)
        WHERE o.id_meja = nomor_meja AND payment_status = 'UNPAID'
        GROUP BY id_makanan;
    CREATE TEMPORARY TABLE bill(hasil CHAR(100));
    SELECT COUNT(*) INTO total_meja 
    FROM orderdetails AS od 
    JOIN orders AS o ON (od.id_order = o.id_order)
    WHERE o.id_meja = nomor_meja AND payment_status = 'UNPAID';
    SELECT id_order INTO orderidvar 
    FROM orders 
    WHERE id_meja = nomor_meja AND payment_status = 'UNPAID';
    SELECT SUM(total_harga) INTO total_bill 
    FROM orderdetails AS od 
    JOIN orders AS o ON (od.id_order = o.id_order)
    WHERE o.id_meja = nomor_meja AND payment_status = 'UNPAID' 
    GROUP BY nomor_meja;
    SET i = 0;
    IF total_meja > 0 THEN 
        INSERT INTO bill(hasil) VALUES
        (CONCAT('Status Pembayaran Untuk Meja [', nomor_meja, ']')), 
        ('');
        OPEN take_data;
        WHILE i < total_meja DO
            FETCH take_data INTO id_makan, jumlah, harga;
            SELECT nama_makanan INTO nama_makan 
            FROM menu 
            WHERE id_makanan = id_makan;
            INSERT INTO bill(hasil) VALUES 
            (CONCAT(nama_makan, '[', jumlah, ']')),
            (CONCAT('Harga : ', harga));
            SET i = i + 1;
        END WHILE;  
        INSERT INTO bill(hasil) VALUES
        (CONCAT('Total Bill : ', total_bill)),
        (''), 
        (CONCAT('Handled by Employee :', 
        (SELECT CONCAT(first_name_e, ' ', last_name_e) 
         FROM employee 
         WHERE id_employee = input_id))), 
        ('Thank You!!');
        UPDATE orders 
        SET id_employee = input_id 
        WHERE id_meja = nomor_meja AND id_order = orderidvar;
        UPDATE orders 
        SET payment_status = 'Paid' 
        WHERE id_meja = nomor_meja AND id_order = orderidvar;
        UPDATE meja 
        SET is_avail = true 
        WHERE id_meja = nomor_meja;
        UPDATE meja 
        SET id_registered_customer = NULL 
        WHERE id_meja = nomor_meja;
    ELSE 
        INSERT INTO bill(hasil) VALUES
        (CONCAT('Nomor Meja ', nomor_meja, ' tidak ada pesanan yang belum dibayar'));
    END IF;
    CLOSE take_data;
    SELECT * FROM bill;
    DROP TEMPORARY TABLE IF EXISTS bill;
END //
DELIMITER ;


DELIMITER //
CREATE OR REPLACE PROCEDURE show_bill(
    IN no_meja VARCHAR(100)
)
BEGIN 
    DECLARE order_id VARCHAR(100);
    DECLARE title VARCHAR(100);
    DECLARE meja_status INT;

    
    SELECT id_order INTO order_id FROM orders 
        WHERE id_meja = no_meja AND payment_status = 'UNPAID';
    
    SELECT COUNT(*) INTO meja_status FROM meja WHERE id_meja = no_meja
    AND is_avail = true;

    IF meja_status = 1 THEN 
        SELECT 'Tidak Ada menu di meja' AS hasil;
    ELSE 
        WITH bill AS (
            SELECT 
                m.nama_makanan Nama_Makanan,
                od.qty Jumlah,
                od.total_harga Total_Harga
            FROM orderdetails AS od 
            JOIN orders AS o ON (o.id_order = od.id_order)
            JOIN menu AS m ON (m.id_makanan = od.id_makanan)
            WHERE o.id_meja = no_meja AND payment_status = 'UNPAID'
        )
        SELECT Nama_Makanan,Jumlah,Total_Harga
        FROM bill;
    END IF;
END //
DELIMITER ;


DELIMITER //
CREATE OR REPLACE PROCEDURE book_for_regis(
    IN nama_orang CHAR(100),
    IN total_orang INT
)
BEGIN
    DECLARE is_avail_pro INT;
    DECLARE customer_exists INT;

    SELECT COUNT(*) 
    INTO customer_exists
    FROM registered_customer
    WHERE CONCAT(first_name_c, ' ', last_name_c) = CONCAT(nama_orang);

    IF customer_exists > 0 THEN
        SELECT COUNT(*) 
        INTO is_avail_pro
        FROM meja 
        WHERE jumlah_bangku >= total_orang AND is_avail = TRUE;

        IF is_avail_pro > 0 THEN 
            CALL cari_meja(total_orang);    
        ELSE 
            SELECT "Meja Sudah Di tempatin" AS message;
        END IF;
    ELSE
        SELECT "Pelanggan tidak terdaftar" AS message;
    END IF;

END //
DELIMITER ;



DELIMITER //
CREATE OR REPLACE PROCEDURE show_monthly_sales()
BEGIN 
    WITH MonthlySales AS (
        SELECT 
            DATE_FORMAT(o.date_order, '%Y-%m') AS Month,
            SUM(od.total_harga) AS TotalSalesThisMonth,
            LEAD(DATE_FORMAT(o.date_order, '%Y-%m')) OVER (ORDER BY DATE_FORMAT(o.date_order, '%Y-%m')) AS NextMonth,
            LEAD(SUM(od.total_harga)) OVER (ORDER BY DATE_FORMAT(o.date_order, '%Y-%m')) AS TotalSalesNextMonth
        FROM orders o
        JOIN orderdetails od ON o.id_order = od.id_order
        GROUP BY DATE_FORMAT(o.date_order, '%Y-%m')
    )
    SELECT 
        Month,
        CONCAT('Rp ', FORMAT(TotalSalesThisMonth, 0, 'id_ID')) AS TotalSalesThisMonth,
        NextMonth,
        CONCAT('Rp ', FORMAT(TotalSalesNextMonth, 0, 'id_ID')) AS TotalSalesNextMonth,
        CONCAT( FORMAT(TotalSalesNextMonth - TotalSalesThisMonth, 0, 'id_ID')) AS Untung
    FROM MonthlySales
    ORDER BY Month;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE RANK_FOOD_QTY()
BEGIN
    WITH RankedFood AS (
        SELECT 
            m.nama_makanan AS FoodName,
            SUM(od.qty) AS TotalQuantity,
            DENSE_RANK() OVER (ORDER BY SUM(od.qty) DESC) AS Rank
        FROM orderdetails od
        JOIN menu m ON od.id_makanan = m.id_makanan
        GROUP BY m.nama_makanan
    )
    SELECT Rank, FoodName, TotalQuantity
    FROM RankedFood
    ORDER BY Rank;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE RANK_FOOD_SALES()
BEGIN
    WITH RankedFood AS (
        SELECT 
            m.nama_makanan AS FoodName,
            SUM(od.total_harga) AS TotalRevenue,
            DENSE_RANK() OVER (ORDER BY SUM(od.total_harga) DESC) AS Rank
        FROM orderdetails od
        JOIN menu m ON od.id_makanan = m.id_makanan
        GROUP BY m.nama_makanan
    )
    SELECT Rank, FoodName, CONCAT('Rp ', FORMAT(TotalRevenue, 0, 'id_ID')) AS TotalRevenue
    FROM RankedFood
    ORDER BY Rank;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE RANK_employee(
    IN top_berapa INT
)
BEGIN
    WITH RankedEmployee AS (
        SELECT 
            CONCAT(e.first_name_e, ' ', e.last_name_e) AS EmployeeName,
            COALESCE(SUM(od.total_harga), 0) AS TotalSales,
            RANK() OVER (ORDER BY COALESCE(SUM(od.total_harga), 0) DESC) AS Rank
        FROM employee e
        LEFT JOIN orders o ON e.id_employee = o.id_employee
        LEFT JOIN orderdetails od ON o.id_order = od.id_order
        GROUP BY e.id_employee, EmployeeName
    )
    SELECT Rank, EmployeeName, TotalSales
    FROM RankedEmployee
    ORDER BY Rank
    LIMIT top_berapa;
END //
DELIMITER ;

DELIMITER //
CREATE OR REPLACE PROCEDURE RANK_FOOD_sales_by_category()
BEGIN
    
    WITH SalesData AS (
        SELECT 
            m.id_kategori,
            c.nama_kategori,
            m.nama_makanan AS MenuItem,
            SUM(od.total_harga) AS TotalRevenue,
            RANK() OVER (PARTITION BY m.id_kategori ORDER BY SUM(od.total_harga) DESC) AS RankByCategory
        FROM orderdetails od
        JOIN menu m ON od.id_makanan = m.id_makanan
        JOIN category_makananan c ON m.id_kategori = c.id_kategori
        JOIN orders o ON od.id_order = o.id_order
        WHERE o.date_order >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
        GROUP BY m.id_kategori, c.nama_kategori, m.id_makanan, m.nama_makanan
    )
    SELECT 
        nama_kategori AS Category,
        MenuItem,
        CONCAT('Rp ', FORMAT(TotalRevenue, 0, 'id_ID')) AS Revenue,
        RankByCategory
    FROM SalesData
    WHERE RankByCategory <= 3 
    ORDER BY id_kategori, RankByCategory;
END //
DELIMITER ;