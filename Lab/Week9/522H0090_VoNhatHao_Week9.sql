Create database QLCHBS

Create table NhomSach
(
	Manhom char(5),
	Tennhom nvarchar(25)
)

Create table NhanVien
(
	MaNV char(5),
	HoLot nvarchar(25),
	TenNV nvarchar(10),
	Phai nvarchar(3),
	NgaySinh Smalldatetime,
	DiaChi nvarchar(40)
)

Create table DanhMucSach
(
	MaSach char(5),
	TenSach nvarchar(40), 
	TacGia nvarchar(20),
	MaNhom char(5),
	DonGia Numeric(5),
	SLTon numeric(5)
)

Create table HoaDon
(
	MaHD char(5),
	NgayBan Smalldatetime,
	MaNV char(5)
)

Create table ChiTietHoaDon
(
	MaHD char(5),
	MaSach char(5),
	SoLuong numeric(5)
)

Insert into NhomSach values ('N1', N'Khoa Hoc')
Insert into NhanVien values ('NV1', N'Nguyen Thi', N'A', N'Nu', '2001/12/12', N'TPHCM')
Insert into DanhMucSach values ('MS1', N'Sach Toan', N'Kim Dong', 'N1', 25000, 2)
Insert into HoaDon values ('HD1', '2021/01/01', 'NV1')
Insert into ChiTietHoaDon values ('HD1', 'MS1', 2)

--cau1
go
Create Trigger cau1 on NhomSach
for Insert
as
begin
	declare @count int
	select @count = count(*) from NhomSach
	print 'Có ' + Cast (@count as nvarchar(20)) + ' mau tin duoc chen'
end
--drop trigger cau1
Insert into NhomSach values ('N2', N'Van Hoc')

--cau2
Create table HOADON_Luu (
    MaHD VARCHAR(10),
    NgayBan DATE,
    MaNV VARCHAR(10)
)
go
Create trigger cau2 on HoaDon 
for Insert
as
    insert into HOADON_Luu 
	select * from Inserted

select * from HOADON_Luu
INSERT into HOADON values ('HD2', getDate(), 'NV1')

--cau3
ALTER table HOADON add Tongtrigia int
ALTER table CHITIETHOADON add dongia int

go
CREATE TRIGGER cau3 on ChiTietHoaDon
for INSERT, UPDATE, DELETE
as
    DECLARE @mahd varchar(10), @tongtg int
    if exists (select * from inserted)
    begin
        select @mahd = mahd from INSERTed
        select @tongtg = sum (soluong * dongia) from ChiTietHoaDon where mahd = @mahd
        UPDATE HOADON set tongtrigia = @tongtg where mahd = @mahd
    end
    else if exists (select * from Deleted)
    begin
        select @mahd = mahd from Deleted
        select @tongtg = sum (soluong * dongia) from CHITIETHOADON where mahd = @mahd
        UPDATE HOADON set tongtrigia = @tongtg where mahd = @mahd
    end

select * from HOADON
select * from CHITIETHOADON where mahd = 'HD001'
INSERT into CHITIETHOADON values ('HD001', 'S002', 3, 10)
UPDATE CHITIETHOADON set dongia = 10 where mahd = 'HD001' and Masach = 'S001'

--cau4
Drop TRIGGER Cau2
drop trigger Cau4
insert into HOADON values ('HD002', getdate(), 'NV01', 0)
go
CREATE TRIGGER Cau4 on CHITIETHOADON
for INSERT, UPDATE
AS
    DECLARE @gb int, @masach varchar(10)
    select @masach = masach, @gb = dongia FROM INSERTed
    if not exists(select * from DANHMUCSACH WHERE masach = @masach and dongia = @gb)
    BEGIN
        print ('Don gia ko phu hop')
        rollback tran
    end
UPDATE CHITIETHOADON set dongia = 150000 where masach = 'S001' and mahd = 'HD001'
INSERT into CHITIETHOADON values ('HD002', 'S001', 2, 150000)
INSERT into CHITIETHOADON values ('HD005', 'S002', 3, 120000)

select * from DANHMUCSACH
select * from CHITIETHOADON
go

--cau5
ALTER TABLE CTHDON ADD NGAYLAP SMALLDATETIME
GO
CREATE TRIGGER Trigger_CheckNgayBan
ON HoaDOn
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN ChiTietHoaDon h ON i.maHD = h.maHD
        WHERE i.NgayBan < h.NGAYLAP 
    )
    BEGIN
        PRINT ('NgayBan phai lon hon hoac bang NgayLap')
        ROLLBACK TRANS
    END
END;
GO
DROP TRIGGER CAU4T
INSERT INTO HoaDon VALUES 
	('H002', '2004-03-01', 'N0001')

INSERT INTO ChiTietHoaDon VALUES 
	('H002', 'S002', 35, 25000, '2005-02-01')
DELETE FROM ChiTietHoaDon WHERE MAHD = 'H002'
SELECT * FROM ChiTietHoaDon
SELECT * FROM HoaDon