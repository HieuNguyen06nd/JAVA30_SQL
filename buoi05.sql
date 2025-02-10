create table student(
	student_id int primary key,
    fist_name varchar(50),
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
    

	
    