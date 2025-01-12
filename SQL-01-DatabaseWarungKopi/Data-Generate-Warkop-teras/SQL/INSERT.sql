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
