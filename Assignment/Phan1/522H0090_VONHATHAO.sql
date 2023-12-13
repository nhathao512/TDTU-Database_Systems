use master
drop database QLNV
Create database QLNV;
use QLNV

--Tạo bảng
Create table NhaDauTu
(
  maNDT varchar(10) not null,
  tenNDT nvarchar(30) not null,
  SoVon varchar(30) not null,
  primary key (maNDT)
);

Create table DuAn
(
  maDA varchar(10) not null,
  tenDA nvarchar(30) not null,
  TongVon varchar(30) not null,
  primary key (maDA)
);

Create table TaiKhoan
(
  tenTK nvarchar(30) not null,
  MatKhau varchar(30) not null,
  primary key (tenTK)
);

Create table PhongBan
(
  maPB varchar(10) not null,
  tenPB nvarchar(30) not null,
  emailPB varchar(30) not null,
  sdtPB varchar(30) not null,
  primary key (maPB)
);

Create table DauTu
(
  maNDT varchar(10) not null,
  maDA varchar(10) not null,
  primary key (maNDT, maDA),
  foreign key (maNDT) references NhaDauTu(maNDT),
  foreign key (maDA) references DuAn(maDA)
);

Create table NhanVien
(
  maNV varchar(10) not null,
  tenNV nvarchar(30) not null,
  sdtNV varchar(30) not null,
  DiaChi varchar(30) not null,
  maDA varchar(10) not null,
  maPB varchar(10) not null,
  primary key (maNV),
  foreign key (maDA) references DuAn(maDA),
  foreign key (maPB) references PhongBan(maPB)
);

Create table LapTrinhVien
(
  emailLTV varchar(30) not null,
  ChuyenMon varchar(30) not null,
  maNV varchar(10) not null,
  tenTK nvarchar(30) not null,
  primary key (maNV),
  foreign key (maNV) references NhanVien(maNV),
  foreign key (tenTK) references TaiKhoan(tenTK)
);

Create table Designer
(
  KinhNghiem nvarchar(30) not null,
  NgaySinh date not null,
  maNV varchar(10) not null,
  primary key (maNV),
  foreign key (maNV) references NhanVien(maNV)
);

Create table NguoiThan
(
  tenNT nvarchar(30) not null,
  sdtNT varchar(30) not null,
  maNV varchar(10) not null,
  primary key (maNV),
  foreign key (maNV) references Designer(maNV)
);

--Thêm dữ liệu
insert into NhaDauTu values ('NDT0001', N'Nhà đầu tư 1', '5000000'),
							('NDT0002', N'Nhà đầu tư 2', '7000000'),
							('NDT0003', N'Nhà đầu tư 3', '10000000');

insert into DuAn values ('DA0001', N'Dự án 1', '2000000'),
						('DA0002', N'Dự án 2', '3000000'),
						('DA0003', N'Dự án 3', '5000000');

insert into TaiKhoan values ('user1', 'passworduser@1'),
							('user2', 'passworduser@2'),
							('user3', 'passworduser@3');

insert into PhongBan values ('PB0001', N'Phòng ban 1', 'phongban1@gmail.com', '033456789'),
							('PB0002', N'Phòng ban 2', 'phongban2@gmail.com', '038765432'),
							('PB0003', N'Phòng ban 3', 'phongban3@gmail.com', '031223344');

insert into DauTu values ('NDT0001', 'DA0001'),
						 ('NDT0002', 'DA0002'),
						 ('NDT0003', 'DA0003');

insert into NhanVien values ('NV0001', N'Nhân viên 1', '032341234', N'Địa chỉ 1', 'DA0001', 'PB0001'),
							('NV0002', N'Nhân viên 2', '036477127', N'Địa chỉ 2', 'DA0002', 'PB0002'),
							('NV0003', N'Nhân viên 3', '037341244', N'Địa chỉ 3', 'DA0003', 'PB0003');

insert into LapTrinhVien values ('ltv1@gmail.com', N'Lập trình viên 1', 'NV0001', 'user1'),
								('ltv2@gmail.com', N'Lập trình viên 2', 'NV0002', 'user2'),
								('ltv3@gmail.com', N'Lập trình viên 3', 'NV0003', 'user3');

insert into Designer values (N'3 năm', '1990-01-01', 'NV0001'),
							(N'5 năm', '1985-05-05', 'NV0002'),
							(N'2 năm', '1993-08-10', 'NV0003');

insert into NguoiThan values (N'Người thân 1', '034234234', 'NV0001'),
							 (N'Người thân 2', '045347773', 'NV0002'),
							 (N'Người thân 3', '033552888', 'NV0003');

--Function
-- Tạo mã Nhà đầu tư tự động
--drop function TaoMaNDT
go
Create function TaoMaNDT()
returns varchar(10)
as 
begin
	if (select top 1 maNDT from NhaDauTu) is null
		return 'NDT0001'
	declare @vt int
	select top 1 @vt = convert(int, right(maNDT, 4)) from NhaDauTu
	order by maNDT desc
	set @vt = @vt + 1
	declare @MaNDT varchar(10)
	set @MaNDT = 'NDT'
	declare @s int
	set @s = len(convert(varchar(4), @vt))
	while @s < 4
		begin 
			set @MaNDT = @MaNDT + '0'
			set @s = @s + 1
		end
	set @MaNDT = @MaNDT + convert(varchar(4), @vt)
	return (@MaNDT)
end
--drop proc P_NDT
go
Create proc P_NDT @TenNDT nvarchar(30), @SoVon varchar(30)
as 
begin
	insert into NhaDauTu values (dbo.TaoMaNDT(), @TenNDT, @SoVon)
end
Exec P_NDT N'Nhà đầu tư 4', '10000000'
Select * from NhaDauTu

-- Tạo mã Dự Án tự động
--drop function TaoMaDA
go
Create function TaoMaDA()
returns varchar(10)
as 
begin
	if (select top 1 maDA from DuAn) is null
		return 'DA0001'
	declare @vt int
	select top 1 @vt = convert(int, right(maDA, 4)) from DuAn
	order by maDA desc
	set @vt = @vt + 1
	declare @MaDA varchar(10)
	set @MaDA = 'DA'
	declare @s int
	set @s = len(convert(varchar(4), @vt))
	while @s < 4
		begin 
			set @MaDA = @MaDA + '0'
			set @s = @s + 1
		end
	set @MaDA = @MaDA + convert(varchar(4), @vt)
	return (@MaDA)
end
--drop proc P_NV
go
Create proc P_DA @TenDA nvarchar(30), @TongVon varchar(30)
as 
begin
	insert into DuAn values (dbo.TaoMaDA(), @TenDA, @TongVon)
end
Exec P_DA N'Dự án 4', '55000000'
Select * from DuAn

--Trigger
drop trigger T_TaiKhoan
go
Create trigger T_TaiKhoan on TaiKhoan
after insert, update
as
begin
	declare @tenTk nvarchar(30)
	declare @MK varchar(30)
	select @tenTk = tenTK, @MK = MatKhau from inserted

	--Kiểm tra ràng buộc
	if (@tenTk is null or exists (select @tenTk from LapTrinhVien where tenTK = @tenTk))
		begin
			if ((select count(tenTK) from TaiKhoan where tenTK = @tenTk) = 2)
				begin
					print (N'Lập trình viên đã có tài khoản')
					rollback tran
				end
			if (@MK is null)
				begin
					print (N'Mật khẩu không được trống')
					rollback tran
				end
			if (len(@MK) > 30)
				begin
					print (N'Mật khẩu phải nhỏ hơn 30 kí tự')
					rollback tran
				end
			if (len(@tenTk) > 30)
				begin
					print (N'Tên tài khoản phải nhỏ hơn 30 kí tự')
					rollback tran
				end
		end
	else
		begin 
			print (N'Tên tài khoản không tồn tại')
			rollback tran
		end
end
Insert into TaiKhoan values ('user5', 'passwordusersagchseasd@1')