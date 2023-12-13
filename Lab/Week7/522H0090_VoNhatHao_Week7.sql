create database BTTL;

create table Lop (
    malop varchar(10) primary key,
    tenlop nvarchar(30)
)

create table Sinhvien (
    masv varchar(10) primary key,
    hoten nvarchar(30),
    ngaysinh date,
    malop varchar(10) foreign key references Lop(malop)
)

create table Monhoc (
    mamh varchar(10) primary key,
    tenmh nvarchar(30)
)

create table Ketqua (
    masv varchar(10),
    mamh varchar(10),
    diem float,
    primary key(masv, mamh),
    foreign key (masv) references Sinhvien(masv),
    foreign key (mamh) references Monhoc(mamh)
)

INSERT INTO Lop VALUES
('TH01', N'Lớp TH01'),
('TH02', N'Lớp TH02'),
('TH03', N'Lớp TH03'),
('TH04', N'Lớp TH04'),
('TH05', N'Lớp TH05')

INSERT INTO Sinhvien VALUES
('SV001', N'Nguyễn Văn A', '2000-01-01', 'TH01'),
('SV002', N'Trần Thị B', '2000-02-02', 'TH01'),
('SV003', N'Lê Văn C', '2000-03-03', 'TH02'),
('SV004', N'Phạm Thị D', '2000-04-04', 'TH02'),
('SV005', N'Hoàng Văn E', '2000-05-05', 'TH03')

INSERT INTO Monhoc VALUES
('MH001', N'Toán'),
('MH002', N'Văn'),
('MH003', N'Lý'),
('MH004', N'Hóa'),
('MH005', N'Sinh')

INSERT INTO Ketqua VALUES
('SV001', 'MH001', 8.5),
('SV001', 'MH002', 7.5),
('SV001', 'MH003', 9.0),
('SV002', 'MH001', 6.0),
('SV002', 'MH002', 7.0)

--a 
---Lay ra Ho
go
Create function layHo (@ht nvarchar(50)) 
returns nvarchar(20)
as 
begin 
	declare @vtri int 
	set @vtri = CHARINDEX(' ', @ht)
	declare @h nvarchar(20)
	set @h = left(@ht, @vtri)
	return @h
end
go

print(dbo.layHo('Võ Nhật Hào'))


---Lay ra ten 
GO
CREATE FUNCTION layTen(@ten NVARCHAR(30))
RETURNS NVARCHAR(30)
AS
BEGIN
    DECLARE @vt INT
    DECLARE @name NVARCHAR(30)
    SET @vt = CHARINDEX(' ', REVERSE(@ten))
    SET @name = RIGHT(@ten, @vt - 1)
    RETURN @name
END
GO

print(dbo.layTen('Võ Nhật Hào'))
-- Lay ra ho lot
GO
CREATE FUNCTION layHoLot(@ten NVARCHAR(30))
RETURNS NVARCHAR(30)
AS
BEGIN
    DECLARE @vt INT
    DECLARE @hoLot NVARCHAR(30)
    SET @vt = CHARINDEX(' ', REVERSE(@ten))
    SET @hoLot = SUBSTRING(@ten, len(dbo.layHo(@ten)) + 2, len(@ten) - len(dbo.layHo(@ten)) -1 - len(dbo.layTen(@ten)) - 1)
    RETURN @hoLot
END

GO
print(dbo.layHoLot('Võ Nhật Hào'))

--b
GO
CREATE FUNCTION TenNgayTrongTuan(@Ngay DATE)
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @TenNgay NVARCHAR(20)

    SET @TenNgay = 
        CASE DATEPART(WEEKDAY, @Ngay)
            WHEN 1 THEN N'Chủ Nhật'
            WHEN 2 THEN N'Thứ Hai'
            WHEN 3 THEN N'Thứ Ba'
            WHEN 4 THEN N'Thứ Tư'
            WHEN 5 THEN N'Thứ Năm'
            WHEN 6 THEN N'Thứ Sáu'
            WHEN 7 THEN N'Thứ Bảy'
            ELSE N'Không hợp lệ'
        END

    RETURN @TenNgay
END
GO


GO
CREATE FUNCTION BTB() 
RETURNS TABLE 
AS 
	RETURN (SELECT hoten, ngaysinh, dbo.TenNgayTrongTuan(ngaysinh) AS THU FROM Sinhvien )
GO

SELECT * FROM BTB()


--C 
GO 
CREATE FUNCTION BTC()
RETURNS TABLE 
AS 
	RETURN (SELECT Sinhvien.masv , hoten, YEAR(ngaysinh) AS namsinh , str(avg(diem), 5, 2) as DTB 
	FROM Sinhvien, Ketqua WHERE Sinhvien.masv = Ketqua.masv GROUP BY Sinhvien.masv , hoten, YEAR(ngaysinh) )
GO

SELECT * FROM BTC()

--D 
--DROP FUNCTION BTD
GO 
CREATE FUNCTION BTD(@masv NVARCHAR(10))
RETURNS TABLE 
AS 
	RETURN (SELECT DISTINCT SUBSTRING(@masv, 1, 4) AS malop , tenlop FROM Sinhvien , Lop WHERE Lop.malop = SUBSTRING(@masv, 1, 4))
GO

SELECT * FROM BTD('SV001')

--E
--DROP FUNCTION BTE
GO 
CREATE FUNCTION BTE(@mamh NVARCHAR(10)) 
RETURNS TABLE
AS 
	RETURN (SELECT mamh , AVG(diem) AS diemtb FROM Ketqua WHERE @mamh = mamh GROUP BY mamh)
GO


SELECT * FROM BTE('MH001')

--F
--DROP FUNCTION BTF 
GO 
CREATE FUNCTION BTG(@MaLop NVARCHAR(10))
RETURNS FLOAT
AS
BEGIN
    DECLARE @DiemMax FLOAT;

    SELECT @DiemMax = MAX(DiemTB1)
    FROM (
        SELECT AVG(diem) AS DiemTB1
        FROM Ketqua
        WHERE masv IN (SELECT masv FROM Sinhvien WHERE malop = @MaLop)
        GROUP BY masv
    ) AS DiemTB2;

    RETURN @DiemMax;
END;
GO
SELECT dbo.BTG('SV001') AS DIEMCAONHAT;
 
ALTER TABLE Lop ADD makhoa varchar(10)
GO
CREATE FUNCTION MaLopTuDong (@malop NVARCHAR(2))
RETURNS NVARCHAR(4)
AS
BEGIN
    DECLARE @ML NVARCHAR(4);

    SELECT @ML = MAX(malop)
    FROM Lop
    WHERE LEFT(malop, 2) = @malop;

    IF @ML IS NULL
    BEGIN
        SET @ML = @malop + '00';
    END
    ELSE
    BEGIN
        SET @ML = @malop + RIGHT('00' + CAST(CAST(RIGHT(@ML, 2) AS INT) + 1 AS NVARCHAR), 2);
    END

    RETURN @ML;
END
