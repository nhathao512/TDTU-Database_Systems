﻿CREATE DATABASE QLNV;
-- BÀI 1
CREATE TABLE PHONG
(
    MAPHONG char(3) PRIMARY KEY,
    TENPHONG nvarchar(40),
    DIACHI nvarchar(50),
    TEL char(10)
)

CREATE TABLE DMNN
(
    MANN char(2) PRIMARY KEY,
    TENNN nvarchar(20)
)

CREATE TABLE NHANVIEN
(
    MANV char(5) PRIMARY KEY,
    HOTEN nvarchar(40),
    GIOITINH char(3),
    NGAYSINH Date,
    LUONG int,
    MAPHONG char(3),
    SDT char(10),
    NGAYBC Date
)

CREATE TABLE TDNN
(
    MANV char(5),
    MANN char(2),
    TDO char(1),
    PRIMARY KEY(MaNV, MaNN)
)

-- BÀI 2
INSERT INTO PHONG(MAPHONG, TENPHONG, DIACHI, TEL) VALUES
('HCA', N'Hành chính tổ hợp', N'123, Láng Hạ, Đống Đa, Hà Nội', '04 8585793'),
('KDA', N'Kinh Doanh', N'123, Láng Hạ, Đống Đa, Hà Nội', '04 8574943'),
('KTA', N'Kỹ thuật', N'123, Láng Hạ, Đống Đa, Hà Nội', '04 9480485'),
('QTA', N'Quản trị', N'123, Láng Hạ, Đống Đa, Hà Nội', '04 8508585')

INSERT INTO DMNN(MANN, TENNN) VALUES
('01', N'Anh'),
('02', N'Nga'),
('03', N'Pháp'),
('04', N'Nhật'),
('05', N'Trung Quốc'),
('06', N'Hàn Quốc')

INSERT INTO NHANVIEN(MANV, HOTEN, GIOITINH, NGAYSINH, LUONG, MAPHONG, SDT, NGAYBC) VALUES
('HC001', N'Nguyễn Thị Hà', 'Nu', '1950-08-27', 2500000, 'HCA', NULL,'1975-08-02'),
('HC002', N'Trần Văn Nam', 'Nam', '1975-06-12', 3000000, 'HCA', NULL,'1997-06-08'),
('HC003', N'Nguyễn Thanh Huyền', 'Nu', '1978-07-03', 1500000, 'HCA',NULL,'1999-09-24'),
('KD001', N'Lê Tuyết Anh', 'Nu', '1977-02-03', 2500000, 'KDA', NULL,'2001-10-02'),
('KD002', N'Nguyễn Anh Tú', 'Nam', '1942-07-04', 2600000, 'KDA', NULL, '1999-09-24'),
('KD003', N'Phạm An Thái', 'Nam', '1977-05-09', 1600000, 'KDA', NULL, '1999-09-24'),
('KD004', N'Lê Văn Hải', 'Nam', '1976-01-02', 2700000, 'KDA', NULL,'1997-06-08'),
('KD005', N'Nguyễn Phương Minh', 'Nam', '1980-01-02', 2000000,'KDA', NULL,'2001-10-02'),
('KT001', N'Trần Đình Khâm', 'Nam', '1981-12-02', 2700000, 'KTA', NULL, '2005-01-01'),
('KT002', N'Nguyễn Mạnh Hùng', 'Nam', '1980-08-16', 2300000, 'KTA', NULL, '2005-01-01'),
('KT003', N'Phạm Thanh Sơn', 'Nam', '1984-08-20', 2000000, 'KTA', NULL,'2005-01-01'),
('KT004', N'Vũ Thị Hoài', 'Nu', '1980-12-05', 2500000, 'KTA', NULL, '2001-10-02'),
('KT005', N'Nguyễn Thu Lan', 'Nu', '1977-10-05', 3000000, 'KTA', NULL, '2001-10-02'),
('KT006', N'Trần Hoài Nam', 'Nam', '1978-07-02', 2800000, 'KTA', NULL, '1997-06-08'),
('KT007', N'Hoàng Nam Sơn', 'Nam', '1940-12-03', 3000000, 'KTA', NULL, '1965-07-02'),
('KT008', N'Lê Thu Trang', 'Nu', '1950-07-06', 2500000, 'KTA', NULL, '1968-08-02'),
('KT009', N'Khúc Nam Hải', 'Nam', '1980-07-22', 2000000, 'KTA', NULL, '2005-01-01'),
('KT010', N'Phùng Trung Dũng', 'Nam', '1978-08-28', 2200000, 'KTA', NULL, '1999-09-24')


INSERT INTO TDNN(MANV, MANN, TDO) VALUES
('HC001', '01', 'A'),
('HC001', '02', 'B'),
('HC002', '01', 'C'),
('HC002', '03', 'C'),
('HC003', '01', 'D'),
('KD001', '01', 'C'),
('KD001', '02', 'B'),
('KD002', '01', 'D'),
('KD002', '02', 'A'),
('KD003', '01', 'B'),
('KD003', '02', 'C'),
('KD004', '01', 'C'),
('KD004', '04', 'A'),
('KD004', '05', 'A'),
('KD005', '01', 'B'),
('KD005', '02', 'D'),
('KD005', '03', 'B'),
('KD005', '04', 'B'),
('KT001', '01', 'D'),
('KT001', '04', 'E'),
('KT002', '01', 'C'),
('KT002', '02', 'B'),
('KT003', '01', 'D'),
('KT003', '03', 'C'),
('KT004', '01', 'D'),
('KT005', '01', 'C')

--BAI 4
--1
SELECT * FROM NHANVIEN WHERE MANV = 'KT001'
--3
SELECT * FROM NHANVIEN WHERE GIOITINH = 'Nu'
--4
SELECT * FROM NHANVIEN WHERE HOTEN LIKE N'Nguyễn%'
--5 
SELECT * FROM NHANVIEN WHERE HOTEN LIKE N'%Văn%'
--6
SELECT MANV, HOTEN, GIOITINH, NGAYSINH, YEAR(GETDATE()) - YEAR(NGAYSINH) AS TUOI
FROM NHANVIEN
WHERE YEAR(GETDATE()) - YEAR(NGAYSINH) < 30;
--7
SELECT MANV, HOTEN, GIOITINH, NGAYSINH, YEAR(GETDATE()) - YEAR(NGAYSINH) AS TUOI
FROM NHANVIEN
WHERE YEAR(GETDATE()) - YEAR(NGAYSINH) BETWEEN 25 AND 30;
--8
SELECT MANV FROM TDNN WHERE MANN = '01' AND TDO >='0'
--9
SELECT * FROM NHANVIEN WHERE YEAR(GETDATE()) - YEAR(NGAYBC) < 2000
--10
SELECT * FROM NHANVIEN WHERE YEAR(GETDATE()) - YEAR(NGAYBC) > 10
--11
SELECT MANV ,HOTEN, GIOITINH, NGAYSINH, YEAR(GETDATE()) -YEAR(NGAYSINH) AS TUOI 
FROM NHANVIEN 
WHERE (GIOITINH = N'Nam' AND YEAR(GETDATE()) - YEAR(NGAYSINH) >= 60) OR (GIOITINH = N'Nu' AND YEAR(GETDATE()) - YEAR(NGAYSINH) >= 55)
--12
SELECT MAPHONG,TENPHONG,TEL 
FROM PHONG
--13
SELECT TOP 2 HOTEN, NGAYSINH, NGAYBC
FROM NHANVIEN;
--14
SELECT *
FROM NHANVIEN
WHERE NHANVIEN.LUONG BETWEEN 2000000 AND 3000000
--15
SELECT *
FROM NHANVIEN
WHERE SDT IS NULL
--16
SELECT MANV, HOTEN, NGAYSINH
FROM NHANVIEN
WHERE MONTH(NGAYSINH) = 3;
--17
SELECT MANV, HOTEN, LUONG
FROM NHANVIEN
ORDER BY LUONG ASC;
--18
SELECT AVG(LUONG) AS LuongTrungBinh
FROM NHANVIEN
WHERE MAPHONG = 'KDA';
--19
SELECT 
    COUNT(*) AS TongSoNhanVien,
    AVG(LUONG) AS LuongTrungBinh
FROM NHANVIEN
WHERE MAPHONG = 'KDA';
--20
SELECT MAPHONG, SUM(LUONG) AS TongLuong
FROM NHANVIEN
GROUP BY MAPHONG;
--21
SELECT MAPHONG, SUM(LUONG) AS TongLuong
FROM NHANVIEN
GROUP BY MAPHONG
HAVING SUM(LUONG) > 500000;
--22
SELECT NHANVIEN.MANV, NHANVIEN.HOTEN, PHONG.MAPHONG, PHONG.TENPHONG
FROM NHANVIEN, PHONG 
WHERE NHANVIEN.MAPHONG = PHONG.MAPHONG;
--23
SELECT * 
FROM NHANVIEN, PHONG 
WHERE NHANVIEN.MAPHONG = PHONG.MAPHONG 
--24
SELECT * 
FROM NHANVIEN, PHONG 
WHERE NHANVIEN.MAPHONG = PHONG.MAPHONG

