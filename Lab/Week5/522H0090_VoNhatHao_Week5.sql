CREATE DATABASE QLNGK;

--Cau1
--a
CREATE TABLE loaiNGK 
(
	MaLoai varchar(10) primary key,
	TenLoai nvarchar (20) NOT NULL unique ,
)
--b
CREATE TABLE NGK
(
	MaNGK varchar (10) primary key,
	TenNGK nvarchar (20) NOT NULL unique ,
	DVT nvarchar (10) NOT NULL check (DVT in (N'chai', N'lon',N'thùng',N'kết')),
	soLuong int NOT NULL check (soLuong > 0),
	Dongia int NOT NULL check (Dongia > 0),
	MaLoaiNGK varchar (10) NOT NULL,
	FOREIGN KEY ( MaLoaiNGK) REFERENCES LoaiNGK(MaLoai) ,
)
--c
CREATE TABLE Khachhang
( 
	MsKH varchar(10) primary key ,
	HoTen nvarchar (20) NOT NULL, 
	DiaChi nvarchar (20) ,
	DienThoai varchar (20) default 'chưa có'
)
--d
CREATE TABLE Hoadon 
(
  Sohd varchar(10) PRIMARY KEY,
  MsKH varchar(10) NOT NULL,
  Nhanvien VARCHAR(50),
  Ngaylap DATE DEFAULT GETDATE(),
  FOREIGN KEY(MsKH) REFERENCES Khachhang (MsKH),
)
--e
CREATE table CTHD 
(
  Sohd varchar(10) ,
  MaNGK varchar (10) ,
  soluong INT NOT NULL CHECK (Soluong >= 0),
  Dongia INT NOT NULL CHECK (Dongia >= 1000),
  PRIMARY KEY (Sohd, MaNGK),
  FOREIGN KEY (Sohd) REFERENCES Hoadon (Sohd),
  FOREIGN KEY (MaNGK) REFERENCES NGK (MaNGK)
)
--f
ALTER TABLE CTHD ADD ThanhTien int 
ALTER TABLE CTHD ADD CONSTRAINT FK_soHD FOREIGN KEY (soHD) REFERENCES HoaDon(soHD)
ALTER TABLE CTHD ADD CONSTRAINT FK_MaNGK FOREIGN KEY (MaNGK) REFERENCES NGK(MaNGK)
ALTER TABLE NGK ADD CHECK (Dongia > 1000)

--g 
ALTER TABLE CTHD DROP CONSTRAINT FK_soHD
ALTER TABLE CTHD DROP CONSTRAINT FK_MaNGK
--h
ALTER TABLE CTHD ADD CHECK (ThanhTien > 0)

--Cau2
--a
INSERT INTO loaiNGK (MaLoai, TenLoai) VALUES 
('M1','A'),
('M2','B'),
('M3','C')

INSERT INTO NGK (MaNGK, TenNGK, DVT, soLuong, Dongia, MaLoaiNGK) VALUES 
('N0001','NGK1','lon',40,5000, 'M1'), 
('N0002','NGK2','chai',20,6000, 'M2'), 
('N0003','NGK3','thùng',10,7000, 'M3') 

INSERT INTO khachHang(msKH, hoTen, diaChi, DienThoai) VALUES 
('KH1','TC1','TPHCM','0123456789'),
('KH2','TC2','HN','0987654321'),
('KH3','TC3','DN','0135792468')

INSERT INTO HoaDon(soHD, msKH, ngayLap) VALUES 
('HD1','KH2','2023-01-02'),
('HD2','KH1','2023-01-03'),
('HD3','KH3','2023-01-04')

INSERT INTO CTHD (soHD, MaNGK, soLuong, Dongia) VALUES 
('HD2','N0001',4, 10000),
('HD3','N0002',8, 20000),
('HD1','N0003',2, 30000)

SELECT * FROM loaiNGK
SELECT * FROM NGK
SELECT * FROM Khachhang
SELECT * FROM Hoadon
SELECT * FROM CTHD
--b 
UPDATE NGK SET Dongia = Dongia + 10000 WHERE DVT like N'lon'

--c 
DELETE khachHang WHERE msKH IN 
(SELECT msKH FROM HoaDon WHERE YEAR(ngayLap) <= 2010 )

--d 
DELETE NGK WHERE soLuong = 0 

--e 
UPDATE NGK
SET Dongia = CASE
    WHEN DVT = 'thùng' THEN
        CASE
            WHEN (Dongia + 100000) <= 500000 THEN (Dongia + 100000)
            ELSE 500000
        END
    ELSE Dongia
END

--Cau3 
--a
SELECT * FROM NGK WHERE DVT like N'lon'

--b 
SELECT * FROM khachHang WHERE diaChi like N'TPHCM'
--c 
SELECT * FROM NGK WHERE MaNGK IN
(SELECT MaNGK FROM CTHD WHERE soHD IN 
(SELECT soHD FROM HoaDon WHERE MONTH(ngayLap) BETWEEN 7 AND 9))
--d
SELECT TenNGK , soLuong FROM NGK 
--e 
SELECT DISTINCT cthd.Sohd
FROM CTHD cthd
JOIN loaiNGK lngk1 ON cthd.MaNGK = lngk1.MaLoai
JOIN loaiNGK lngk2 ON cthd.MaNGK = lngk2.MaLoai
WHERE lngk1.TenLoai = N'Nước Có Ga' OR lngk2.TenLoai = N'Nước Ngọt';
--f 
SELECT * FROM NGK WHERE MaNGK NOT IN 
(SELECT MaNGK FROM CTHD)