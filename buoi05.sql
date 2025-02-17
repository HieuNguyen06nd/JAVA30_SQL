SET SQL_SAFE_UPDATES = 0;

create table student(
	student_id int primary key,
    first_name varchar(50),
    last_name varchar(50),
    date_of_birth date,
    class varchar(50)
    );

create table student_score(
	student_id int,
    foreign key (student_id) references student(student_id),
    subject_id int,
    score decimal(5,2),
    primary key(student_id, subject_id)
    );

create table employees (
	employee_id int primary key,
    name varchar(100),
    position varchar(50),
    salary decimal(10,2)
    
    );

create table account(
	account_id int primary key,
    account_name varchar(100),
    balance decimal(10,2)
    );
    
-- 1. Thêm dữ liệu vào bảng students (Sinh viên)
INSERT INTO student (student_id, first_name, last_name, date_of_birth, class) VALUES
(1, 'Nguyen', 'Anh', '2000-05-15', 'Lop 10A'),
(2, 'Le', 'Mai', '1999-08-22', 'Lop 10B'),
(3, 'Tran', 'Hoa', '2001-03-12', 'Lop 10A'),
(4, 'Pham', 'Duy', '2000-11-25', 'Lop 10C'),
(5, 'Nguyen', 'Minh', '1998-12-05', 'Lop 10B');
-- 2. Thêm dữ liệu vào bảng student_scores (Điểm sinh viên)
INSERT INTO student_score (student_id, subject_id, score) VALUES
(1, 101, 9.0),  -- Sinh viên 1, Môn học 101, Điểm 9.0
(1, 102, 8.0),  -- Sinh viên 1, Môn học 102, Điểm 8.0
(2, 101, 6.5),  -- Sinh viên 2, Môn học 101, Điểm 6.5
(2, 103, 7.8),  -- Sinh viên 2, Môn học 103, Điểm 7.8
(3, 102, 8.7),  -- Sinh viên 3, Môn học 102, Điểm 8.7
(3, 103, 9.2),  -- Sinh viên 3, Môn học 103, Điểm 9.2
(4, 101, 5.0),  -- Sinh viên 4, Môn học 101, Điểm 5.0
(4, 103, 6.0),  -- Sinh viên 4, Môn học 103, Điểm 6.0
(5, 102, 7.5);  -- Sinh viên 5, Môn học 102, Điểm 7.5
-- 3. Thêm dữ liệu vào bảng employees (Nhân viên)
INSERT INTO employees (employee_id, name, position, salary)
VALUES
(1, 'Nguyen Thi Mai', 'Manager', 15000.00),
(2, 'Le Thi Lan', 'Developer', 12000.00),
(3, 'Tran Minh Tu', 'Designer', 11000.00),
(4, 'Pham Hoang Duy', 'Developer', 13000.00),
(5, 'Nguyen Thanh Hai', 'Tester', 10000.00);
-- 4. Thêm dữ liệu vào bảng accounts (Tài khoản ngân hàng)
INSERT INTO account (account_id, account_name, balance)
VALUES
(1, 'Nguyen Thi Mai', 2500.00),
(2, 'Le Thi Lan', 1500.00),
(3, 'Tran Minh Tu', 5000.00),
(4, 'Pham Hoang Duy', 1200.00),
(5, 'Nguyen Thanh Hai', 10000.00);

-- 1.	Tạo một stored procedure để lấy thông tin sinh viên theo student_id.
delimiter $$
	create procedure GetStudentId( in student_id int)
	begin 
		select * from student st where st.student_id = student_id;
    end$$
delimiter;

call GetStudentId(1);


-- 2.	Viết một stored procedure để cập nhật điểm của sinh viên trong bảng student_scores.
delimiter $$
	create procedure UpdateScore( 
    in student_id int,
    in subject_id int,
    in newScore decimal(5,2))
	begin 
		update student_score set score = newScore where student_score.student_id = student_id and subject_id = subject_id;
    end$$
delimiter ;

call UpdateScore(1,101, 10);



-- 3.	Tạo stored procedure để xóa một sinh viên khỏi bảng students theo student_id.
delimiter $$
	create procedure DeleteStudent( in student_id int)
	begin 
		delete from student_score where student_score.student_id = student_id;
		delete from student st where st.student_id = student_id;
    end$$
delimiter ;

call DeleteStudent(5);

-- 4.	Tạo stored procedure để tính tổng điểm của tất cả sinh viên trong bảng student_scores.
delimiter $$
	create procedure TotalScore( out total_score decimal(5,2))
	begin 
		select sum(score) into total_score from student_score;
    end$$
delimiter ;

call TotalScore(@total_score);
select @total_score;

-- 5.	Tạo stored procedure để tìm kiếm sinh viên theo tên (họ hoặc tên).
delimiter $$
	create procedure SearchName( in  first_name varchar(50))
	begin 
		select * from student where student.first_name = first_name ;
        
    end$$
delimiter ;

CALL SearchName('haha', '');

-- 6.	Tạo một stored procedure để lấy danh sách các nhân viên có lương cao hơn một mức nhất định.
delimiter $$
	create procedure SearchSalary( in  newSalary decimal(10,2) )
	begin 
		select * from employees where salary>newSalary ; 
    end$$
delimiter ;

CALL SearchSalary(11000);

-- 7.	Tạo một stored procedure để tính điểm trung bình của sinh viên trong một lớp học cụ thể (class).
delimiter $$
	create procedure AvgScoreInClass( 
    in newClass varchar(50), 
    out avg_score decimal(5,2) )
	begin 
		select avg(score) into avg_score from student 
        join  student_score on student_score.student_id = student.student_id where class = newClass;
    end$$
delimiter ;


CALL AvgScoreInClass('Lop 10A', @avg_score);
SELECT @avg_score AS average_score;


-- 8.	Viết một stored procedure để cập nhật thông tin nhân viên trong bảng employees (ví dụ: tên, vị trí, lương).
delimiter $$
	create procedure UpdateInfo(
    in employee_id int, 
    in name varchar(100),
    in position varchar(50),
    in salary decimal(10,2) )
	begin 
		update employees e set e.name = name,
							e.position = position,
                            e.salary = salary
                            where e.employee_id =employee_id;
    end$$
delimiter ;

CALL UpdateInfo(1, 'Nguyen Thi Mai1', 'Manager', 15000.00);

-- 9.	Tạo stored procedure để tính tổng số dư của tất cả tài khoản trong bảng accounts.
delimiter $$
	create procedure CountAccount( out countAccount int)
	begin 
		select count(account_id) into countAccount from account ; 
    end$$
delimiter ;

CALL CountAccount(@countAccount);
select @countAccount;

-- 10.	Tạo stored procedure để tính số lượng sinh viên trong mỗi lớp.
delimiter $$
	create procedure CountStudentInClass( 
    in  newClass varchar(50),
    out countStudent int)
	begin 
		select count(student_id) into countStudent from student where class = newClass; 
    end$$
delimiter ;

CALL CountStudentInClass('Lop 10A', @countStudent);
select @countStudent;
-- 11.	Tạo một stored procedure để hiển thị danh sách các nhân viên có chức vụ Manager.
delimiter $$
	create procedure SearchEmployeeManagere( in  newPosition varchar(50) )
	begin 
		select * from employees where position = newPosition; 
    end$$
delimiter ;

CALL SearchEmployeeManagere('manager');
-- 12.	Tạo stored procedure để tìm các tài khoản ngân hàng có số dư dưới mức quy định.
delimiter $$
	create procedure SearchBalance( in iBanace decimal(10,2) )
	begin 
		select * from account where balance>iBanace;
    end$$
delimiter ;

CALL SearchBalance(1300);
-- 13.	Viết stored procedure để chuyển tiền giữa hai tài khoản ngân hàng, sử dụng giao dịch (transaction) và kiểm tra số dư.
delimiter $$
	create procedure transactionBalance( 
    in fAcount int,
    in tAccount int,
    in iBalnce decimal(10,2))
	begin 
		select * from account where balance>iBanace;
    end$$
delimiter ;
-- 14.	Tạo một stored procedure để tính điểm trung bình của một sinh viên cho tất cả các môn học.
delimiter $$
	create procedure avgStudentSubject( in Istudent_id int )
	begin 
		select avg(score) from student_score 
        join student on student.student_id = student_score.student_id
        group by student.student_id having student.student_id= Istudent_id;
    end$$
delimiter ;

CALL avgStudentSubject(3);
-- 15.	Viết một stored procedure để tạo tài khoản mới trong bảng accounts và đảm bảo số dư không âm.
delimiter $$
	create procedure CreateAccount(
    IN account_name VARCHAR(100),
    IN initial_balance DECIMAL(10,2) )
	begin 
		if initial_balance>0 then insert into account(account_name, balance)  value (account_name,initial_balance);
        else  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'so du k the < 0';
        end if;
    end$$
delimiter ;

CALL CreateAccount('hieu hieu', 1222);
-- 16.	Tạo một stored procedure để tính lương mới cho tất cả nhân viên trong bảng employees có chức vụ Manager, tăng 10%.
delimiter $$
	create procedure calSalaryManager( in position varchar(50),
    in per double)
	begin 
		update employees set salary = salary + salary*per/100 where employees.position = position;
    end$$
delimiter ;

CALL calSalaryManager('manager', 20);
-- 17.	Viết stored procedure để thay đổi tên sinh viên trong bảng students sau khi kiểm tra lớp của sinh viên.

-- 18.	Tạo stored procedure để xóa tài khoản ngân hàng có số dư dưới 500, sau đó thông báo nếu tài khoản bị xóa.


-- 19.	Viết stored procedure để tính tổng số điểm của sinh viên theo từng môn học trong bảng student_scores.
delimiter $$
	create procedure SumScore()
	begin 
		select subject_id, sum(score) from student_score group by subject_id;
    end$$
delimiter ;

CALL SumScore();

-- 20.	Tạo stored procedure để lấy thông tin sinh viên và số điểm trung bình của họ trong một lớp học cụ thể, chỉ lấy sinh viên có điểm trung bình trên 6.0. 
delimiter $$
	create procedure avgcore(in IClass varchar(50))
	begin 
		select first_name, last_name , avg(score) from student
        join student_score on student.student_id = student_score.student_id
        where class = IClass
        group by student.student_id
        having avg(score) >6;
    end$$
delimiter ;

CALL avgcore('Lop 10A');
	
    