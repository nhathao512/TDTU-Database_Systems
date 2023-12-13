Create database QLSinhvien

Create table Sinhvien
(
	hosv nvarchar(20),
	tensv nvarchar(20),
	masv varchar(10),
	ngaysinh date,
	phai nvarchar(20),
	makhoa varchar(10)
)

Create table Monhoc
(
	tenmh nvarchar(50),
	mamh varchar(10),
	sotiet int
)


Create table Khoa
(
	maKhoa varchar(10),
	tenKhoa nvarchar(20)
)

Create table Ketqua
(
	masv varchar(10),
	mamh varchar(10),
	lanthi int,
	diem int
)

Insert into Sinhvien values 
(N'Vo', N'Hao', '522H0090', '2004/12/05', N'Nam', 'M5'),
(N'Nguyen', N'Tri', '522H0091', '2004/06/05', N'Nam', 'M3'),
(N'Tran', N'Dung', '522H0092', '2004/09/15', N'Nu', 'M2')

Insert into Monhoc values
(N'He co so du lieu','DS', 45),
(N'To chuc may tinh','OC', 45),
(N'Nhap mon mang may tinh','OCN', 30)

Insert into Khoa values
('M5', N'Cong nghe thong tin'),
('M2', N'Tai chinh ngan hang'),
('M3', N'Ky thuat cong trinh')

Insert into Ketqua values
('522H0090', 'DS', 1, 8.0),
('522H0091','OS', 2, 10.0),
('522H0092', 'DS', 1, 6.0)
--cau1
go
create proc cau1 @hosv nvarchar(20), @tensv nvarchar(20), @masv varchar(10), @ngaysinh date, @phai nvarchar(20), @makhoa varchar(10)
as
begin
	insert into Sinhvien values(@hosv, @tensv, @masv, @ngaysinh, @phai, @makhoa)
end
exec cau1 N'Nguyen', N'Thuy', '522H0009', '2010/05/13', N'Nu', 'M1'
select * from SinhVien
--cau2
go
Create proc cau2 @hosv nvarchar(20), @tensv nvarchar(20), @masv varchar(10), @ngaysinh date, @phai nvarchar(20), @makhoa varchar(10)
as
begin
	if(exists(select * from Sinhvien where masv = @masv))
	begin
		print('Khoa chinh ton tai')
		return
	end
	else if(not exists(select * from Khoa where makhoa = @makhoa))
	begin
		print('Khoa ngoai ton tai')
		return
	end
	else if(year(getdate())-year(@ngaysinh) < 18 or year(getdate())-year(@ngaysinh) > 40)
	begin
		print('Khong du tuoi')
		return
	end
	else
		insert into Sinhvien values(@hosv, @tensv, @masv, @ngaysinh, @phai, @makhoa)
end
go
exec cau2 N'Nguyen', N'Huy', '522H0007', '2010/04/13', N'Nam', 'M1'
select * from SinhVien
--cau3
go
Create proc cau3 @masv varchar(10), @mamh varchar(10), @lanthi int, @diem int
as
if not exists(select * from Sinhvien where masv = @masv)
    Begin
        Print 'Ma sinh vien truyen vao khong ton tai trong bang sinhvien'
        return
    end
else if not exists(select * from Monhoc where mamh = @mamh)
    begin
        print 'Ma mon hoc truyen vao khong ton tai trong bang monhoc'
        return
    end
else
    insert into Ketqua values(@masv, @mamh, @lanthi, @diem)
exec cau3 '522H0082', 'BS', 1, 6.0
select * from Ketqua
--cau4
go
Create proc cau4 @maKhoa varchar(10), @tenKhoa nvarchar(20)
as
begin
    select count(*) as N'Số lượng' from Sinhvien
    where Makhoa = @maKhoa
end

exec cau4 'M1', 'My thuat'
select * from Ketqua

--cau5
go
Create function cau5 (@maKhoa varchar(10))
returns table
as
	return(select * from Sinhvien where makhoa = @maKhoa)
go
select * from cau5('M5')
--cau6
go
Create function cau6()
returns table
as
	return(select Khoa.maKhoa, Khoa.tenKhoa, count(Sinhvien.masv) as 'so luong'
	from Khoa, Sinhvien where Sinhvien.maKhoa = Khoa.maKhoa
	Group by Khoa.maKhoa, Khoa.tenKhoa)
go
select * from cau6()
--cau7
go
Create function cau7 (@masv varchar(10))
returns table 
as 
	return (select * from Ketqua where masv = @masv)
go
select * from cau7('522H0090')
--cau8
go
Create function cau8 (@maKhoa varchar(10))
returns table
as
	return (select count(*) as soluongsv from Sinhvien
	where makhoa = @maKhoa)
go
select * from cau8('522H0091')

-----------------------------------
--Cau 5 bai tap ve nha
--a
GO

CREATE FUNCTION TaoSoHD(@STT int)
RETURNS varchar(50)
AS
BEGIN
	DECLARE @NgayLap varchar(50);
	SET @NgayLap = CONVERT(varchar(50), GETDATE(), 12);
	RETURN @NgayLap + RIGHT('000' + CAST(@STT AS varchar(50)), 3);
END
GO

--b
CREATE PROCEDURE ThemHoaDonMoi(@STT int)
AS
BEGIN
	INSERT INTO Hoadon(sohd, ngaylap)
	VALUES (dbo.TaoSoHD(@STT), GETDATE());
END
GO

--c
GO
CREATE FUNCTION TaoMaNGK(@MaNSX varchar(50), @STT int)
RETURNS varchar(50)
AS
BEGIN
	RETURN @MaNSX + RIGHT('000' + CAST(@STT AS varchar(50)), 3);
END
GO 


CREATE PROCEDURE ThemNGKMoi(@MaNSX varchar(50), @STT int, @TenNGK nvarchar(50), @DVT nvarchar(50), @soluong int, @dongia float, @Maloai varchar(10))
AS
BEGIN
	INSERT INTO NGK(MaNGK, TenNGK, DVT, soluong, dongia, Maloai)
	VALUES (dbo.TaoMaNGK(@MaNSX, @STT), @TenNGK, @DVT, @soluong, @dongia, @Maloai);
END


--d
GO
CREATE PROCEDURE ThemCTHD(@sohd varchar(50), @MaNGK varchar(50), @soluong int)
AS
BEGIN
	DECLARE @dongia float;
	SELECT @dongia = dongia FROM NGK WHERE MaNGK = @MaNGK;
	IF @soluong <= (SELECT soluong FROM NGK WHERE MaNGK = @MaNGK)
	BEGIN
		INSERT INTO CTHD(sohd, MaNGK, soluong, dongia)
		VALUES (@sohd, @MaNGK, @soluong, @dongia * 1.5);
	END
	ELSE
	BEGIN
		RAISERROR ('Số lượng không hợp lệ', 16, 1);
		RETURN;
	END
END

--e
GO
CREATE FUNCTION TinhTongTien(@sohd varchar(50))
RETURNS float
AS
BEGIN
	RETURN (SELECT SUM(soluong * dongia) FROM CTHD WHERE sohd = @sohd);
END
GO 

SELECT dbo.TinhTongTien('2303161')

--f
GO
CREATE FUNCTION NGKBanThang3Nam2016()
RETURNS TABLE
AS
RETURN 
(
	SELECT NGK.* FROM NGK
	INNER JOIN CTHD ON NGK.MaNGK = CTHD.MaNGK
	INNER JOIN Hoadon ON CTHD.sohd = Hoadon.sohd
	WHERE MONTH(Hoadon.ngaylap) = 3 AND YEAR(Hoadon.ngaylap) = 2016
)
GO