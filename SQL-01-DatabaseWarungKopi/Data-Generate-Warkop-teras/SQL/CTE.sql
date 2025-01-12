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