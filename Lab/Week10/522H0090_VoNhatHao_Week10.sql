Create database QLSB;

Create table San
(
	MaSan varchar(20),
	TenSan nvarchar(30),
	SoTien_Gio int
)

Create table KhachHang
(
	Sdt varchar(20),
	HoTen nvarchar(30)
)

Create table DichVu
(
	MaDV varchar(20),
	TenDV nvarchar(30),
	SoLuong int,
	DonGia int
)

Create table PhieuDatSan
(
	MaDatSan varchar(20),
	Sdt_Khach varchar(20),
	NgayDat date,
	NgayThiDau date,
	GioBD time,
	GioKT time,
	MaSan varchar(20)
)

Create table HoaDon
(
	SoHD varchar(10),
	NgayLap date,
	MaDatSan varchar(20)
)

Create table ChiTietHoaDon
(
	SoHD varchar(10),
	MaDV varchar(20),
	SoLuong int,
	DonGia int
)

Insert into San values
('S1', N'San 1', 50000),
('S2', N'San 2', 75000),
('S3', N'San 3', 60000)

Insert into KhachHang values
('0123456789', N'Nguyen Thi A'),
('0156258889', N'Nguyen Van B'),
('0127632349', N'Tran Nhat C')

Insert into DichVu values
('DV1', N'Thue Ao', 1, 20000),
('DV2', N'Thue Bong', 1, 50000),
('DV3', N'Nuoc Uong', 1, 20000)

Insert into PhieuDatSan values 
('MD1', '0231231238', '2023-10-10', '2023-10-11', '11:00', '13:00', 'S1'),
('MD2', '0232344588', '2023-05-20', '2023-05-21', '10:00', '12:00', 'S2'),
('MD3', '0246123214', '2023-06-06', '2023-06-07', '14:00', '15:00', 'S3')

Insert into HoaDon values
('HD1', '2023-11-11', 'MD2'),
('HD2', '2023-10-01', 'MD3'),
('HD3', '2023-09-12', 'MD1')

Insert into ChiTietHoaDon values 
('HD1', 'DV1', 2, 30000),
('HD2', 'DV3', 10, 200000),
('HD3', 'DV2', 5, 50000)

--2
--a
Select * From ChiTietHoaDon 
--Drop function Cau2a
Go 
Create function Cau2a (@MDV varchar(10))
Returns int 
as 
begin
	if exists (select * from ChiTietHoaDon where @MDV = MaDV)
	begin 
		declare @TongTien int 
		select @TongTien = sum(SoLuong * DonGia) from ChiTietHoaDon where @MDV = MaDV
	end
	return @TongTien
end
Go
print(dbo.caua('DV1'))
--b
--Drop function Cau2b
go
Create function cau2b()
returns varchar(20)
as
begin
    declare @NgayHT varchar(10)
    declare @stt int
    set @NgayHT = convert(varchar(10), getdate(), 103)
    if exists (select * from HoaDon where left(SoHD, 8) = replace(@NgayHT, '/', ''))
    begin
        select @stt = isnull(max(cast(substring(SoHD, 9, 4) as int)), 0) + 1
        from HoaDon
        where left(SoHD, 8) = Replace(@NgayHT, '/', '')
    end
    else
    begin  
        set @stt = 1
    end
    declare @ChuoiStt varchar(4)
    set @ChuoiStt = right('000' + cast(@STT as varchar(4)), 4)
    declare @SOHD varchar(20)
    set @SOHD = replace(@NgayHT, '/', '') + @ChuoiStt
    return @SOHD
end
go

print dbo.caub();

--3
--a
--Drop proc P_cau3a
go
Create proc P_cau3a @MaSan varchar(10) , @TenSan nvarchar(30), @SoTien_Gio int 
as 
begin 
	if ( @SoTien_Gio > 0 ) 
	begin 
		insert into San (MaSan, TenSan, SoTien_Gio) values (@MaSan, @TenSan, @SoTien_Gio) 
	end
	else 
	begin 
		print('So tien/gio phai lon hon 0')
	end
end
go
select * from San 
exec P_cau3a 'S4', N'San 4',200000

--b
--Drop proc P_cau3b
go
create proc P_cau3b @sdt_moi varchar(10), @sdt_cu varchar(10)
as 
begin
	update KhachHang set Sdt = @sdt_moi
		where Sdt = @sdt_cu
	update Phieudatsan set Sdt_Khach = @sdt_moi
		where Sdt_Khach = @sdt_cu
	print N'Da cap nhat xong'
end
go
exec P_cau3b '0123456789', '0369723648'
--4
--a
go
Create trigger tr_cau4a on PhieuDatSan
for insert
as
begin
	if exists(select * from Inserted where NgayThiDau < NgayDat)
	begin 
		rollback
		print N'Ngay thi dau khong the nho hon ngay dat san.'
	end
end
insert into PhieuDatSan values ('MD2', '0231231238', '2023-10-10', '2023-10-09', '11:00', '13:00', 'S1')

--b
go
Create trigger tr_cau4b on ChiTietHoaDon
for insert, update
as
begin
	if exists(select * from Inserted inner join DichVu on Inserted.MaDV = DichVu.MaDV
		where DichVu.SoLuong < Inserted.SoLuong)
		begin
			rollback
			print N'So luong ban phai nho <= so luong hien co'
		end
end
go
Update ChiTietHoaDon set SoLuong = SoLuong + 50