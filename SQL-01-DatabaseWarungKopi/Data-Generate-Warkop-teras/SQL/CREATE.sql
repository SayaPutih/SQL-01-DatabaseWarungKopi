CREATE DATABASE UASDB2;
USE UASDB2;

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











