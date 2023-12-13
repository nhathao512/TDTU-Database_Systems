CREATE TABLE Khoa
(
	MaKhoa varchar(10) CONSTRAINT PK_MK PRIMARY KEY,
	TenKhoa varchar(30)
)

CREATE TABLE SinhVien 
(
	HoSV nvarchar(15),
	TenSV nvarchar(15),
	MaSV varchar(10) CONSTRAINT PK_MaSV PRIMARY KEY,
	NgaySinh date,
	Phai varchar(10),
	MaKhoa varchar(10) CONSTRAINT PK_MK1 FOREIGN KEY (MaKhoa) REFERENCES Khoa (MaKhoa)
)

CREATE TABLE MonHoc
(
	TenMH varchar(30),
	MaMH varchar(10) CONSTRAINT PK_MaMH PRIMARY KEY,
	SoTiet int
)

CREATE TABLE KetQua 
(
	MaSV varchar(10),
	MaMH varchar(10),
	LanThi int ,
	Diem float,
	PRIMARY KEY (MaSV, MaMH, LanThi),
	CONSTRAINT PK_MSV1 FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV),
	CONSTRAINT PK_MMH1 FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH)
)
Insert into SinhVien values(N'Tran Minh',N'Son','S001','5/1/1985', N'Nam','CNTT')
Insert into SinhVien values(N'Nguyen Quoc',N'Bao','S002','6/15/1986', N'Nam','CNTT')
Insert into SinhVien values(N'Phan Anh',N'Trung','S003','12/20/1983', N'Nam','QTKT')
Insert into SinhVien values(N'Bui Thi Anh',N'Thu','S004','2/1/1985', N'Nu','QTKT')
Insert into SinhVien values(N'Le Thi Lan',N'Anh','S005','7/3/1987', N'Nu','DTVT')
Insert into SinhVien values(N'Nguyen Thi',N'Lam','S006','11/25/1984', N'Nu','DTVT')
Insert into SinhVien values(N'Phan Thi',N'Ha','S007','7/3/1988', N'Nu','CNTT')
Insert into SinhVien values(N'Tran The',N'Long','S008','10/21/1985', N'Nam','CNTT')

INSERT INTO MonHoc VALUES('Anh Van', 'AV', 45)
INSERT INTO MonHoc VALUES('Co So Du Lieu', 'CSDL', 45)
INSERT INTO MonHoc VALUES('Ky Thuat Lap Trinh', 'KTLT', 60)
INSERT INTO MonHoc VALUES('Ke Toan Tai Chinh', 'KTTC', 45)
INSERT INTO MonHoc VALUES('Toan Cao Cap', 'TCC', 60)
INSERT INTO MonHoc VALUES('Tin Hoc Van Phong', 'THVP', 30)
INSERT INTO MonHoc VALUES('Tri Tue Nhan Tao', 'TTNT', 45)

INSERT INTO Khoa VALUES('AVAN', 'Khoa Anh Van')
INSERT INTO Khoa VALUES('CNTT', 'Cong Nghe Thong Tin')
INSERT INTO Khoa VALUES('DTVT', 'Dien Tu Vien Thong')
INSERT INTO Khoa VALUES('QTKD', 'Quan Tri Kinh Doanh')

INSERT INTO KetQua VALUES('S001', 'CSDL', 1, 4)
INSERT INTO KetQua VALUES('S001', 'TCC', 1, 6)
INSERT INTO KetQua VALUES('S002', 'CSDL', 1, 3)
INSERT INTO KetQua VALUES('S002', 'CSDL', 2, 6)
INSERT INTO KetQua VALUES('S003', 'KTTC', 1, 5)
INSERT INTO KetQua VALUES('S004', 'AV', 1, 8)
INSERT INTO KetQua VALUES('S004', 'THVP', 1, 4)
INSERT INTO KetQua VALUES('S004', 'THVP', 2, 8)
INSERT INTO KetQua VALUES('S006', 'TCC', 1, 5)
INSERT INTO KetQua VALUES('S007', 'AV', 1, 2)
INSERT INTO KetQua VALUES('S007', 'AV', 2, 9)
INSERT INTO KetQua VALUES('S007', 'KTLT', 1, 6)
INSERT INTO KetQua VALUES('S008', 'AV', 1, 7)

--Câu 2
ALTER TABLE KetQua 
DROP CONSTRAINT PK_MSV1 
ALTER TABLE KetQua
DROP CONSTRAINT PK_MMH1


--Câu 3
DROP TABLE Khoa
DROP TABLE MonHoc

--Câu 4
ALTER TABLE KetQua
ADD CONSTRAINT PK_PK_MSV1 FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV)
ALTER TABLE KetQua
ADD CONSTRAINT PK_MMH1 FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH)


--Câu 6
update MonHoc set SoTiet = 30 
where TenMH = 'Tri Tue Nhan Tao'

--Cau 7
delete from ketqua where masv = 's001'

--Cau 9
update sinhvien set HoSV = N'Nguyen Van'
, phai = N'Nam' where HoSV = N'Nguyen thi' and TenSV = N'Lam'

--Cau 10
update sinhvien set makhoa = 'CNTT'
where HoSV = N'Le Thi Lan' and TenSV = N'Anh'


