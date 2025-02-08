CREATE TABLE NhanVien (
    id INT PRIMARY KEY,
    hoTen VARCHAR(100) NOT NULL,
    luong INT NOT NULL,
    phongban_id INT,
    quanly_id INT,
    FOREIGN KEY (phongban_id) REFERENCES PhongBan(id),
    FOREIGN KEY (quanly_id) REFERENCES NhanVien(id)
);

INSERT INTO PhongBan (tenPhong) 
VALUES ('IT'),('Ke Toan'), ('Nhan Su');

INSERT INTO PhongBan (tenPhong) 
VALUES ('IT2');

insert into NhanVien( id, hoTen, luong, phongban_id, quanly_id)
values (1, 'nguyen thi a', 1500000, 2, null),
(5,'nguyen van e', 2000000, 1, null),
(6,'nguyen van f', 2000000, 3, null),
(2,'nguyen van b', 1000000, 3, 6),
(3,'nguyen van c', 55000000, 1, 5),
(4,'nguyen van d', 1800000, 1, 5);

insert into NhanVien( id, hoTen, luong, phongban_id, quanly_id)
values (9, 'nguyen thi a', 55000000, null, null);

select NhanVien.hoTen, tenPhong from PhongBan inner join NhanVien on NhanVien.phongban_id = PhongBan.id;

select NhanVien.hoTen, tenPhong, luong from PhongBan inner join NhanVien on NhanVien.phongban_id = PhongBan.id where luong>1000000;

select NhanVien.hoTen, tenPhong from PhongBan left join NhanVien on NhanVien.phongban_id = PhongBan.id;

select NhanVien.hoTen, tenPhong from PhongBan right join NhanVien on NhanVien.phongban_id = PhongBan.id;

select NhanVien.hoTen, luong from NhanVien order by luong desc limit 1; 
select hoTen, luong from NhanVien where luong=(select max(luong) from NhanVien);

select tenPhong,sum(luong) from NhanVien right join PhongBan on NhanVien.phongban_id = PhongBan.id  group by PhongBan.tenPhong;

select tenPhong,avg(luong) from NhanVien right join PhongBan on NhanVien.phongban_id = PhongBan.id  group by PhongBan.tenPhong;

select tenPhong,sum(luong) from NhanVien join PhongBan on NhanVien.phongban_id = PhongBan.id 
 group by PhongBan.tenPhong having sum(luong)> 2000000  ;
 
select avg(luong) from NhanVien;

select hoTen, luong from NhanVien where luong> (select avg(luong) from NhanVien);
 
select hoTen, luong, tenPhong from NhanVien join PhongBan on NhanVien.phongban_id = PhongBan.id 
	where luong > (select avg(luong) from NhanVien);

select hoTen,tenPhong, luong from NhanVien join PhongBan on NhanVien.phongban_id = PhongBan.id order by luong asc;

select hoTen,tenPhong, luong from NhanVien join PhongBan on NhanVien.phongban_id = PhongBan.id order by luong desc;

select nv1.hoTen, nv2.hoTen as' quan ly' from NhanVien nv1 
join NhanVien nv2  on nv1.id = nv2.quanly_id;

select nv1.hoTen, nv2.hoTen as' quan ly'  from NhanVien nv1, NhanVien nv2 where   nv1.id = nv2.quanly_id;

select hoTen, tenPhong from NhanVien join PhongBan on NhanVien.phongban_id= PhongBan.id where tenPhong = 'IT' order By hoTen asc;


create table PhongBan(
MaPhong int primary key AUTO_INCREMENT,
TenPhong varchar(100) not null);



