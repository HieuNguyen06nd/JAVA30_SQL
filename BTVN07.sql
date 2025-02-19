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

-- 2.  Viết một function trả về tên lớp học dựa trên id của lớp.

delimiter $$
	create function lay_ten_lop( id_lop int)
    returns varchar(255)
    deterministic
	begin
		declare ten_lop1 varchar(255);
		select ten_lop into ten_lop1 from lop_hoc where id = id_lop;
        return ten_lop1;
    end$$
    
delimiter ;

select lay_ten_lop(3);

-- 3.  Viết một function trả về tổng số sinh viên trong một lớp học.
delimiter $$
	create function sum_student( id_lop int)
    returns int
    deterministic
	begin
		declare sum_sv int;
		select count(id) into sum_sv from lop_hoc where id = id_lop;
        return sum_sv;
    end$$
    
delimiter ;

select sum_student(1);
-- 4. Viết một function tính điểm trung bình của tất cả sinh viên trong một lớp.
delimiter $$
	create function avg_score( id_lop int)
    returns FLOAT
    deterministic
	begin
		declare avgScore float;
		select avg(diem)  into avgScore from sinh_vien join lop_hoc on sinh_vien.ma_lop = lop_hoc.id where lop_hoc.id = id_lop;
        return avgScore;
    end$$
    
delimiter ;

select avg_score(1);
-- 5. Viết một function kiểm tra sinh viên có đạt hay không (Điểm trung bình ≥ 5 thì đậu, ngược lại rớt).
delimiter $$
	create function check_student( id_student int)
    returns varchar(255)
    deterministic
	begin
		declare diemSv float;
        declare kq varchar(255);
		select diem into diemSv from sinh_vien where id = id_student;
        
        if diemSv >= 5 then set kq = 'dau';
        else set kq = 'rot';
        end if;
        
        return kq;
    end$$
    
delimiter ;

select check_student(1);
-- 6. Viết một function trả về số lượng sinh viên có điểm trên 8 trong một lớp cụ thể.
delimiter $$
	create function sum_student_score( id_lop int)
    returns int 
    deterministic
	begin
		declare sumSv int;
		select count(sinh_vien.id) into sumSv from sinh_vien
        where ma_lop = id_lop and diem>8;
        return sumSv;
    end$$
    
delimiter ;

select sum_student_score(1);
-- 7.  Viết một trigger tự động cập nhật điểm của sinh viên thành 0 nếu điểm nhập vào nhỏ hơn 0.
delimiter $$
create trigger uppdate_check_socre before update on sinh_vien
for each row
begin 
	if new.diem <0 then set new.diem = 0;
    end if;
end$$

delimiter ;

update sinh_vien set diem = -1 where id = 1;
SELECT * from sinh_vien;
-- 8.  Viết một trigger ghi log vào bảng log_diem mỗi khi điểm sinh viên bị cập nhật.
CREATE TABLE log_diem (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sinh_vien_id INT,
    diem_cu FLOAT,
    diem_moi FLOAT,
    thoi_gian DATETIME,
    hanh_dong VARCHAR(255)
);

delimiter $$
create trigger update_score_log after update on sinh_vien
for each row
begin

	if new.diem != old.diem  then 
    insert into log_diem(sinh_vien_id, diem_cu,diem_moi, thoi_gian, hanh_dong) 
    values (old.id, old.diem, new.diem, now(), 'update');
    
    end if;
end$$

delimiter ; 
update sinh_vien set diem = 3 where id =2;
-- 9.  Viết một trigger không cho phép xóa lớp học nếu vẫn còn sinh viên trong lớp.
delimiter $$
create trigger delete_sinhvien before delete on lop_hoc
for each row
begin
	declare count_sv int;
    select count(id) into count_sv from sinh_vien where ma_lop= lop_hoc.id;
    if count_sv > 0 then 
    SIGNAL SQLSTATE '45000'
     SET MESSAGE_TEXT = 'khong the xoa lop hoc ' ;
	end if;
end$$

delimiter ; 

delete from lop_hoc where id =1;
-- 10. Viết một trigger tự động gán điểm 10 cho sinh viên mới nếu điểm chưa được nhập khi thêm mới.
delimiter $$
create trigger insert_score_10 before insert on sinh_vien
for each row
begin
	if new.diem is null then set new.diem = 10;
    end if;

end $$

delimiter ;

insert into sinh_vien(ten, ma_lop) values ('hehe' , 3);

select * from sinh_vien;
-- 11. Viết một trigger cập nhật điểm trung bình toàn lớp mỗi khi có sinh viên được thêm hoặc sửa điểm.
alter table lop_hoc add column avg_score_class float;

delimiter $$
create trigger insert_avg_score after insert on sinh_vien
for each row
begin
	declare avg_score float;
	select avg(diem) into avg_score from sinh_vien where ma_lop = new.ma_lop;
    update lop_hoc set avg_score_class = avg_socre where id = new.ma_lop;
end $$

delimiter ;

delimiter $$
create trigger update_avg_score after update on sinh_vien
for each row
begin
	declare avg_score float;
    if new.diem != old.diem then
		select avg(diem) into avg_score from sinh_vien where ma_lop = new.ma_lop;
		update lop_hoc set avg_score_class = avg_socre where id = new.ma_lop;
    end if;
end $$

delimiter ;
-- 12.  Viết một stored procedure để lấy danh sách sinh viên trong một lớp cụ thể.
delimiter $$
	create procedure listStudentInClass (in id_lop int)
	begin
		select sinh_vien.id, sinh_vien.ten, sinh_vien.diem from sinh_vien
        where ma_lop = id_lop;
    end$$
    
delimiter ;

call listStudentInClass(2);

-- 13.  Viết một stored procedure để cập nhật điểm của một sinh viên dựa trên ID.
delimiter $$
	create procedure updateScore (in id_sv int, in new_score float)
	begin
		update sinh_vien set diem = new_score where id = id_sv;
    end$$
    
delimiter ;

call updateScore(2, 1);
-- 14. Tạo một View hiển thị danh sách sinh viên cùng tên lớp học.
create view view_dslophoc as select sinh_vien.ten, lop_hoc.ten_lop from sinh_vien
	join lop_hoc on sinh_vien.ma_lop = lop_hoc.id;

SELECT * FROM view_dslophoc;

-- 15.  Tạo một View hiển thị danh sách sinh viên có điểm >= 5.
create view view_dssvdiem as select * from sinh_vien where diem>=5;

select * from view_dssvdiem;
-- 16. Lấy danh sách sinh viên có tên chứa chữ "n".
select * from sinh_vien where ten like '%n%';
-- 17.  Tính số lượng sinh viên trong từng lớp.
select count(sinh_vien.id), lop_hoc.ten_lop  from sinh_vien join lop_hoc
	on sinh_vien.ma_lop = lop_hoc.id
    group by lop_hoc.ten_lop;
-- 18.  Tính điểm trung bình của từng lớp học.
select avg(diem) , lop_hoc.ten_lop from sinh_vien 
	join lop_hoc on sinh_vien.ma_lop = lop_hoc.id
    group by lop_hoc.ten_lop;
-- 19.  Đếm số lượng sinh viên có điểm >= 8 theo từng lớp.
select count(sinh_vien.id) from sinh_vien where diem>=8;


