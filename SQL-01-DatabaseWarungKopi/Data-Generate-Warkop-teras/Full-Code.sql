CREATE DATABASE UASDB2;
USE UASDB2;

/*
Contoh Query
CALL register_customer('Yulianto Laiherman',0812,'M','Banten');
CALL cari_meja(4);
CALL pesan_makanan('M01','Indomie Telor',1);
CALL pesan_makanan('M01','Paket Bento 4',1);
CALL pesan_makanan('M01','Teh Manis (ice)',4);
CALL pesan_makanan('M01','Kopi Gula Aren',1);
CALL show_bill('M01');
CALL checkout('M01','E0001');

CALL show_monthly_sales();
CALL RANK_FOOD_qty();
CALL RANK_FOOD_sales();
CALL RANK_employee(10);
CALL RANK_FOOD_sales_by_category();

(sub-query, join, view SP, SF, trigger, CTE, time series analysis) 

Sub Query
*/

CREATE TABLE registered_customer(
    id_customer VARCHAR(100) PRIMARY KEY NOT NULL,
    first_name_c CHAR(100) NOT NULL,
    last_name_c VARCHAR(100),
    gender_c CHAR(1) CHECK(gender_c IN('M','F')),
    phone_c VARCHAR(12),
    alamat_C CHAR(100)
);

CREATE TABLE shift(
    id_shift VARCHAR(100) PRIMARY KEY,
    start_shift TIME,
    end_shift TIME
);

CREATE TABLE category_makananan(
    id_kategori VARCHAR(100) PRIMARY KEY NOT NULL,
    nama_kategori CHAR(100)
);

CREATE TABLE meja(
    id_meja VARCHAR(100) PRIMARY KEY NOT NULL,
    is_avail BOOLEAN DEFAULT TRUE,
    jumlah_bangku INT,
    id_registered_customer VARCHAR(100),

    FOREIGN KEY(id_registered_customer) REFERENCES registered_customer(id_customer)
); 

CREATE TABLE employee(
    id_employee VARCHAR(100) PRIMARY KEY NOT NULL,
    first_name_e CHAR(100) NOT NULL,
    last_name_e CHAR(100) NOT NULL,
    gender_e CHAR(1) CHECK(gender_e IN('M','F')),
    phone_num_e VARCHAR(12),
    alamat_e CHAR(100),
    id_manager VARCHAR(100),
    id_shift VARCHAR(100)

    /*FOREIGN KEY (id_shift) REFERENCES shift(id_shift)*/
);

ALTER TABLE employee
ADD CONSTRAINT fk_manager
FOREIGN KEY (id_manager) REFERENCES employee(id_employee)
ON DELETE SET NULL;


CREATE TABLE menu(
    id_makanan VARCHAR(100) PRIMARY KEY NOT NULL,
    nama_makanan CHAR(100) NOT NULL,
    harga_makanan INT NOT NULl,
    id_kategori VARCHAR(100),

    FOREIGN KEY (id_kategori) REFERENCES category_makananan(id_kategori)
);

CREATE TABLE orders(
    id_order VARCHAR(100) PRIMARY KEY NOT NULL,
    id_employee VARCHAR(100),
    id_meja VARCHAR(100),
    date_order DATE,
    payment_status VARCHAR(100),

    FOREIGN KEY(id_employee) REFERENCES employee(id_employee),
    FOREIGN KEY(id_meja) REFERENCES meja(id_meja)   
);

ALTER TABLE orders
DROP FOREIGN KEY orders_ibfk_1;

ALTER TABLE orders
ADD CONSTRAINT orders_ibfk_1
FOREIGN KEY (id_employee)
REFERENCES employee(id_employee)
ON DELETE CASCADE;


CREATE TABLE orderdetails(
    id_order VARCHAR(100) ,
    id_makanan VARCHAR(100) ,
    qty INT,
    total_harga INT
);

CREATE OR REPLACE TABLE history_employee(
    full_name CHAR(100) NOT NULL,
    date_leave DATE,
    time_leave TIME,
    alesan CHAR(100)
);

/*Insert Yang Dibutuhkan*/
INSERT INTO meja(id_meja,jumlah_bangku) 
VALUES 
    ('M01',4),
    ('M02',4),
    ('M03',4),
    ('M04',4),
    ('M05',8),
    ('M06',8),
    ('M07',8),
    ('M08',8),
    ('M09',2),
    ('M10',2),
    ('M11',4),
    ('M12',4),
    ('M13',4),
    ('M14',4),
    ('M15',8),
    ('M16',8),
    ('M17',8),
    ('M18',8),
    ('M19',2),
    ('M20',2);

INSERT INTO shift (id_shift, start_shift, end_shift)
VALUES 
    ('S1', '08:00:00', '12:00:00'),
    ('S2', '12:00:00', '16:00:00'),
    ('S3', '16:00:00', '20:00:00');

INSERT INTO category_makananan(id_kategori,nama_kategori)
VALUES 
    ('WAR01','Warkopan (Light Drinks)'),
    ('COF02','Coffee And Non-Coffee'),
    ('FOO03','Foods'),
    ('BEN04','Bento'),
    ('SNA05','Snacks');

INSERT INTO employee (id_employee,first_name_e,last_name_e,gender_e,phone_num_e,alamat_e,id_manager,id_shift)
VALUES
    ('M0001','Prince','Ali','M',0812909090,'Jakarta',NULL,'S1'),
    ('M0002','Jasmine','Ali','F',0812909090,'Aceh',NULL,'S3'),
    ('M0003','Moana','Muatanui','F',08155555,'Banten',NULL,'S2'),
    ('M0004','Maoi','Mataduitan','M',0812909090,'Makasar',NULL,'S1'),
    ('M0005','Elsa','Anna','F',0812909090,'Manado',NULL,'S3'),
    ('M0006','Budi','Hartono','M',08155555,'Banten',NULL,'S2');

-- Warkopan (Light Drinks)
INSERT INTO menu (id_makanan, nama_makanan, harga_makanan, id_kategori)
VALUES
    ('WAR01_TMH', 'Teh Manis (Hot)', 4000, 'WAR01'),
    ('WAR01_TMI', 'Teh Manis (Ice)', 5000, 'WAR01'),
    ('WAR02_TGH', 'Teh Gentong (Hot)', 7000, 'WAR01'),
    ('WAR02_TGI', 'Teh Gentong (Ice)', 8000, 'WAR01'),
    ('WAR03_TTH', 'Teh Tarik (Hot)', 6000, 'WAR01'),
    ('WAR03_TTI', 'Teh Tarik (Ice)', 8000, 'WAR01'),
    ('WAR04_KAH', 'Kopi Kapal Api (Hot)', 5000, 'WAR01'),
    ('WAR05_ABH', 'Kopi ABC (Hot)', 5000, 'WAR01'),
    ('WAR06_INH', 'Kopi Indocafe (Hot)', 5000, 'WAR01'),
    ('WAR06_INI', 'Kopi Indocafe (Ice)', 7000, 'WAR01'),
    ('WAR07_WCH', 'White Coffee (Hot)', 5000, 'WAR01'),
    ('WAR07_WCI', 'White Coffee (Ice)', 7000, 'WAR01'),
    ('WAR08_GDH', 'Good Day (Hot)', 5000, 'WAR01'),
    ('WAR08_GDI', 'Good Day (Ice)', 7000, 'WAR01'),
    ('WAR09_BBH', 'Drink Beng Beng (Hot)', 6000, 'WAR01'),
    ('WAR09_BBI', 'Drink Beng Beng (Ice)', 8000, 'WAR01'),
    ('WAR10_DAH', 'Dancow (Hot)', 6000, 'WAR01'),
    ('WAR11_NUH', 'Nutrisari (Hot)', 4000, 'WAR01'),
    ('WAR11_NUI', 'Nutrisari (Ice)', 5000, 'WAR01'),
    ('WAR12_KBH', 'Kuku Bima (Hot)', 5000, 'WAR01'),
    ('WAR12_KBI', 'Kuku Bima (Ice)', 6000, 'WAR01'),
    ('WAR13_EXH', 'Extra Joss (Hot)', 5000, 'WAR01'),
    ('WAR13_EXI', 'Extra Joss (Ice)', 6000, 'WAR01');

-- Coffee and Non-Coffee
INSERT INTO menu (id_makanan, nama_makanan, harga_makanan, id_kategori)
VALUES
    ('COF01_KTH', 'Kopi Teras', 15000, 'COF02'),
    ('COF02_KGA', 'Kopi Gula Aren', 17000, 'COF02'),
    ('COF03_CLT', 'Cafe Latte', 16000, 'COF02'),
    ('COF04_VLT', 'Vanilla Latte', 16000, 'COF02'),
    ('COF05_CMC', 'Cafe Mocca', 16000, 'COF02'),
    ('COF06_CHH', 'Chocolate (Hot)', 14000, 'COF02'),
    ('COF06_CHI', 'Chocolate (Ice)', 15000, 'COF02'),
    ('COF07_TTH', 'Thai Tea (Hot)', 7000, 'COF02'),
    ('COF07_TTI', 'Thai Tea (Ice)', 8000, 'COF02'),
    ('COF08_LTH', 'Lemon Tea (Hot)', 6000, 'COF02'),
    ('COF08_LTI', 'Lemon Tea (Ice)', 7000, 'COF02'),
    ('COF09_SSS', 'Soda Susu', 11000, 'COF02');

-- Foods
INSERT INTO menu (id_makanan, nama_makanan, harga_makanan, id_kategori)
VALUES
    ('FOO01_NT', 'Nasi Telor', 10000, 'FOO03'),
    ('FOO02_NTK', 'Nasi Telor Kornet', 13000, 'FOO03'),
    ('FOO03_NO', 'Nasi Omelette', 14000, 'FOO03'),
    ('FOO04_SP', 'Spaghetti', 8000, 'FOO03'),
    ('FOO05_IP', 'Indomie Polos', 7000, 'FOO03'),
    ('FOO06_IT', 'Indomie Telor', 10000, 'FOO03'),
    ('FOO07_ITK', 'Indomie Telor Kornet', 13000, 'FOO03'),
    ('FOO08_IKJ', 'Internet Keju', 16000, 'FOO03'),
    ('FOO09_IT', 'Indomie Tabrak', 11000, 'FOO03'),
    ('FOO10_ITD', 'Indomie Tabrak Double', 17000, 'FOO03'),
    ('FOO11_OM', 'Omelette', 11000, 'FOO03');

-- Bento
INSERT INTO menu (id_makanan, nama_makanan, harga_makanan, id_kategori)
VALUES
    ('BEN01_B1', 'Bento Paket 1', 18000, 'BEN04'),
    ('BEN02_B2', 'Bento Paket 2', 19000, 'BEN04'),
    ('BEN03_B3', 'Bento Paket 3', 19000, 'BEN04'),
    ('BEN04_B4', 'Bento Paket 4', 19000, 'BEN04'),
    ('BEN05_BS', 'Bento Spesial', 23000, 'BEN04');

-- Snacks
INSERT INTO menu (id_makanan, nama_makanan, harga_makanan, id_kategori)
VALUES
    ('SNA01_RBC', 'Roti Bakar Cokelat', 10000, 'SNA05'),
    ('SNA02_RBK', 'Roti Bakar Kacang', 10000, 'SNA05'),
    ('SNA03_RBJ', 'Roti Bakar Keju', 11000, 'SNA05'),
    ('SNA04_RB2', 'Roti Bakar 2 Rasa', 13000, 'SNA05'),
    ('SNA05_RB3', 'Roti Bakar 3 Rasa', 16000, 'SNA05'),
    ('SNA06_FF', 'French Fries', 12000, 'SNA05'),
    ('SNA07_OT', 'Otak-Otak', 8000, 'SNA05'),
    ('SNA08_NU', 'Nugget', 9000, 'SNA05'),
    ('SNA09_SO', 'Sosis', 9000, 'SNA05'),
    ('SNA10_MP', 'Mix Platter', 17000, 'SNA05');

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
/*VIEW*/

CREATE VIEW liat_penghasilan_makanan AS 
SELECT 
    m.nama_makanan 'Nama Makanan',
    m.harga_makanan 'Harga Makanan',
    SUM(od.qty) 'Total Pembelian',
    SUM(od.total_harga) 'Total Penghasilan'
    FROM menu AS m 
    JOIN orderdetails AS od ON (m.id_makanan = od.id_makanan)
    GROUP BY m.nama_makanan;

SELECT * FROM liat_penghasilan_makanan;

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