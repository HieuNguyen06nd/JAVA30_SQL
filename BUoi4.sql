create table PhongBan(
MaPhong int primary key AUTO_INCREMENT,
TenPhong varchar(100) not null);

CREATE TABLE NhanVien (
    MaNhanVien INT PRIMARY KEY AUTO_INCREMENT, 
    HoTen VARCHAR(100) NOT NULL, 
    Luong DECIMAL(15,2) NOT NULL,  
    MaPhong INT, 
    QuanLy_id INT, 
    FOREIGN KEY (MaPhong) REFERENCES PhongBan(MaPhong), 
    FOREIGN KEY (QuanLy_id) REFERENCES NhanVien(MaNhanVien)
);

Create table KhachHang(
	MaKhach INT PRIMARY KEY AUTO_INCREMENT,
    TenKhach varchar(100) not null
);
Create table DonHang (
	MaDon int PRIMARY KEY AUTO_INCREMENT,
    MaKhach int ,
    FOREIGN KEY (MaKhach) REFERENCES KhachHang(MaKhach),
    NgayDat Date not null,
    TongTien Decimal(15,2) not null
);

create table SanPham (
	MaSanPham int primary key auto_increment,
    TenSanPham varchar(100) not null,
    Gia Decimal(15,2) not null
);


create table ChiTietDonHang(
	MaChiTiet int primary key auto_increment,
    MaDon int,
    MaSanPham int,
    SoLuong int not null,
	foreign key (MaDon) references DonHang(MaDon),
    foreign key (MaSanPham) references SanPham(MaSanPham)
);

-- 1. Chèn dữ liệu vào bảng PhongBan
INSERT INTO PhongBan (TenPhong) VALUES 
('CNTT'),
('Kinh doanh'),
('Nhân sự');
-- 2. Chèn dữ liệu vào bảng NhanVien
INSERT INTO NhanVien (HoTen, Luong, MaPhong) VALUES 
('Nguyễn Văn A', 20000000, 1), 
('Trần Thị B', 15000000, 1), 
('Lê Văn C', 18000000, 2), 
('Phạm Thị D', 16000000, 3);
-- 3. Chèn dữ liệu vào bảng KhachHang
INSERT INTO KhachHang (TenKhach) VALUES 
('Công ty ABC'),
('Công ty XYZ');
-- 4. Chèn dữ liệu vào bảng DonHang
INSERT INTO DonHang (MaKhach, NgayDat, TongTien) VALUES 
(1, '2025-02-01', 5000000), 
(2, '2025-02-02', 8000000), 
(1, '2025-02-05', 12000000);
-- 5. Chèn dữ liệu vào bảng SanPham
INSERT INTO SanPham (TenSanPham, Gia) VALUES 
('Laptop', 20000000), 
('Chuột', 500000);
-- 6. Chèn dữ liệu vào bảng ChiTietDonHang
INSERT INTO ChiTietDonHang (MaDon, MaSanPham, SoLuong) VALUES 
(1, 1, 2), 
(1, 2, 3), 
(2, 1, 1);

create view View_NVLuongLonHonTB as select HoTen, Luong from NhanVien where Luong> (select avg(Luong) from NhanVien);
SELECT * FROM Buoi4.View_NVLuongLonHonTB;

CREATE VIEW View_DSKHCungSLDH AS SELECT KhachHang.TenKhach, COUNT(DonHang.MaDon)
FROM KhachHang JOIN DonHang ON KhachHang.MaKhach = DonHang.MaKhach GROUP BY KhachHang.TenKhach;

create view View_DSNVvaPB as select NhanVien.HoTen, PhongBan.TenPhong from NhanVien right join PhongBan on NhanVien.MaPhong = PhongBan.MaPhong;

create view View_DsNvcoPB as select NhanVien.HoTen, PhongBan.TenPhong from NhanVien left join PhongBan on NhanVien.MaPhong = PhongBan.MaPhong;

select * from Buoi4.View_DsNvcoPB;

create view View_Ds as select SanPham.TenSanPham, sum(SanPham.Gia* ChiTietDonHang.SoLuong) from SanPham join ChiTietDonHang 
on SanPham.MaSanPham = ChiTietDonHang.MaSanPham group by SanPham.TenSanPham;
SELECT * FROM Buoi4.View_Ds;

select PhongBan.TenPhong ,count(NhanVien.MaNhanVien) from PhongBan join NhanVien on PhongBan.MaPhong = NhanVien.MaPhong 
group by PhongBan.TenPhong Having  count(NhanVien.HoTen)>1;

select KhachHang.TenKhach, count(DonHang.MaDon) from KhachHang 
join DonHang on KhachHang.MaKhach = DonHang.MaKhach
GROUP BY KhachHang.MaKhach having sum(DonHang.TongTien)> 5000000;

select count(SanPham.MaSanPham), SanPham.TenSanPham, sum(ChiTietDonHang.SoLuong * SanPham.Gia) from SanPham 
JOIN ChiTietDonHang on SanPham.MaSanPham = ChiTietDonHang.MaSanPham
Group by SanPham.MaSanPham having sum(ChiTietDonHang.SoLuong * SanPham.Gia) > 10000000;


select NhanVien.HoTen, PhongBan.TenPhong from NhanVien left join PhongBan on NhanVien.MaPhong = PhongBan.MaPhong;

select KhachHang.TenKhach, sum(DonHang.TongTien) ,Sum(DonHang.MaDon)  from KhachHang
JOIN DonHang on KhachHang.MaKhach = DonHang.MaKhach 
group by KhachHang.MaKhach;

select NhanVien.HoTen, Luong from NhanVien where Luong = (select min(Luong) from NhanVien);

select SanPham.TenSanPham, Gia from SanPham where Gia = (select max(Gia) from SanPham);

select KhachHang.TenKhach, sum(DonHang.TongTien) from KhachHang
join DonHang on DonHang.MaKhach = KhachHang.MaKhach
group by KhachHang.MaKhach
order by sum(DonHang.TongTien)  desc;












    
