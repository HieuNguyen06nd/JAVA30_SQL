-- 1. Tạo hai bảng lop_hoc và sinh_vien trong datacase QuanLySinhVien với các cột sau:
CREATE TABLE lop_hoc (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ten_lop VARCHAR(255),
    khoa VARCHAR(255)
);
CREATE TABLE sinh_vien (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ten VARCHAR(255),
    ma_lop INT,
    diem FLOAT,
    FOREIGN KEY (ma_lop) REFERENCES lop_hoc(id)
);


INSERT INTO lop_hoc (ten_lop, khoa) VALUES
('Lớp 1', 'Công nghệ thông tin'),
('Lớp 2', 'Kinh tế'),
('Lớp 3', 'Toán học'),
('Lớp 4', 'Văn học'),
('Lớp 5', 'Kỹ thuật điện tử');

INSERT INTO sinh_vien (ten, ma_lop, diem) VALUES
('Nguyễn Văn A', 1, 8.5),
('Trần Thị B', 2, 7.2),
('Phạm Minh C', 3, 6.8),
('Lê Quang D', 4, 9.0),
('Hoàng Anh E', 5, 7.5);

-- 2. Viết truy vấn để tìm giá trị điểm lớn nhất của sinh viên.
select * from sinh_vien where diem = (select max(diem) from sinh_vien);

-- 3. Viết truy vấn để tính giá trị điểm trung bình của sinh viên trong 1 lớp.
select avg(diem) from sinh_vien where ma_lop=3;

-- 4. Viết truy vấn lấy ra thông tin sinh viên gồm điểm, tên lớp, tên sinh viên của 1 lớp cụ thể và sắp xếp tên A-Z.

select sinh_vien.ten, sinh_vien.diem, lop_hoc.ten_lop from sinh_vien join lop_hoc on sinh_vien.ma_lop = lop_hoc.id 
where ma_lop =1 order by lop_hoc.ten_lop asc;

-- 5. Tạo một VIEW để hiển thị danh sách sinh viên có điểm cao nhất trong từng lớp.
create view view_dssv as select * from sinh_vien where diem =( select max(diem) from sinh_vien where ma_lop =3 );

select * from view_dssv;

-- 6. Viết 4 câu lệnh tạo Stored Procedure để:
-- a) Lấy danh sách sinh viên có điểm trên một mức chỉ định. Hiển thị thông báo khi không có sinh viên nào.
delimiter $$
	create procedure checkScore (in IScore float)
	begin
		declare soSv int;
        select count(*) into soSv  from sinh_vien  where diem > IScore;
        if (soSv> 0) then select sinh_vien.id, sinh_vien.ten, sinh_vien.diem from sinh_vien
        where diem > IScore;
        else select 'khong co sinh vien';
        end if;
    end$$
    
delimiter ;

call checkScore(8);
-- b) Cập nhật điểm của một sinh viên dựa trên id. Hiển thị thông báo lỗi, nếu id không tồn tại
delimiter $$
	create procedure updateScoreNew (in idSv int, in nScore float)
	begin
		declare soSv int;
        select count(*) into soSv  from sinh_vien  where id =idSv;
        if (soSv = 1) then 
        update sinh_vien set diem =nScore where id = idSv;
        else select 'khong co sinh vien';
        end if;
    end$$
    
delimiter ;
call updateScoreNew(2, 9);
-- c) Thêm một sinh viên mới vào bảng sinh_vien. nếu tên sinh viên null => hiển thị thông báo lỗi, và không cho update
delimiter $$
	create procedure addStudent (in ten_sv varchar(255), in ma_lop_moi int, in diem_moi float)
	begin
		if ten_sv IS NULL THEN
        select 'ten sv null' AS message;
        else
        insert into sinh_vien(ten, ma_lop, diem) values ( ten_sv, ma_lop_moi, diem_moi);
        end if;
    end$$
    
delimiter ;
call addStudent('hihi', 2, 8);
-- d) Xóa một sinh viên theo id… Hiển thị thông báo
-- “Xóa thành công” => Có bản ghi để xóa
-- “Xóa không thàn” => Không tìm thấy bản ghi nào để xóa
delimiter $$
	create procedure deleteStudent (in idSv int)
	begin
		declare soSv int;
        select count(*) into soSv  from sinh_vien  where id =idSv;
        if (soSv = 1) then 
        delete from sinh_vien where id = idSv;
        select 'xoa thanh cong';
        else select 'xoa that bai';
        end if;
    end$$
    
delimiter ;
call deleteStudent(3s);

select * from sinh_vien;