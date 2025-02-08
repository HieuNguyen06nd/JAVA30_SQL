create Table Authors(
	AuthorID INT PRIMARY KEY AUTO_INCREMENT,
	AuthorName VARCHAR(100) NOT NULL
);

create table Books(
	BookID INT PRIMARY KEY AUTO_INCREMENT,
	Title VARCHAR(200) NOT NULL,
	AuthorID INT,
	FOREIGN KEY (AuthorID) references Authors(AuthorID),
	PublishedYear YEAR NOT NULL
);

create table Members(
	MemberID INT PRIMARY KEY AUTO_INCREMENT,
	MemberName VARCHAR(100) NOT NULL,
	JoinDate DATE NOT NULL
);

create table Loans (
	LoanID INT PRIMARY KEY AUTO_INCREMENT,
	BookID INT,
    FOREIGN KEY (BookID) references Books(BookID),
	MemberID INT ,
    FOREIGN KEY (MemberID) references Members(MemberID),
	LoanDate DATE NOT NULL,
	ReturnDate DATE
    );

-- Chèn dữ liệu vào bảng Authors
INSERT INTO Authors (AuthorName) VALUES
('J.K. Rowling'),
('George Orwell'),
('J.R.R. Tolkien'),
('Agatha Christie'),
('Dan Brown');

-- Chèn dữ liệu vào bảng Books
INSERT INTO Books (Title, AuthorID, PublishedYear) VALUES
('Harry Potter and the Sorcerer\'s Stone', 1, 1997),
('1984', 2, 1949),
('The Hobbit', 3, 1937),
('Murder on the Orient Express', 4, 1934),
('The Da Vinci Code', 5, 2013);

-- Chèn dữ liệu vào bảng Members
INSERT INTO Members (MemberName, JoinDate) VALUES
('Alice Nguyen', '2022-01-15'),
('Bob Tran', '2021-03-10'),
('Charlie Le', '2024-02-05'),
('Diana Kim', '2023-06-22'),
('Eva Pham', '2024-01-12');

-- Chèn dữ liệu vào bảng Loans
INSERT INTO Loans (BookID, MemberID, LoanDate, ReturnDate) VALUES
(1, 1, '2024-01-20', '2024-02-01'),
(2, 2, '2024-01-15', NULL),
(3, 3, '2022-02-07', NULL),
(4, 4, '2023-12-01', '2023-12-15'),
(5, 5, '2022-01-25', '2022-02-05');

INSERT INTO Loans (BookID, MemberID, LoanDate, ReturnDate) VALUES
(1, 1, '2024-01-20', '2024-02-01'),
(2, 2, '2024-01-15', NULL),
(3, 3, '2024-02-07', NULL);


-- Lấy ra thông tin gồm 4 cột: BookID, Title, AuthorName và PublishedYear.
-- Điều kiện: chỉ lấy những cuốn sách có PublishedYear sau năm 2010.
Create view View_InfoBooks as select Books.BookID, Books.Title, Authors.AuthorName, Books.PublishedYear 
from Books JOIN Authors on Authors.AuthorID = Books.AuthorID
where PublishedYear >2010;

-- Tính số lượng sách mà mỗi thành viên đã mượn.
create view View_SLBookLoans as select Members.MemberName, count(Loans.LoanId) from Members
join Loans on Members.MemberID = Loans.MemberID
group by Members.MemberID;

-- Hiển thị kết quả gồm tên thành viên và số lượng sách mượn.
Create view View_DSNameAndQuantity as select Members.MemberName, count(Loans.LoanId) from Members
join Loans on Members.MemberID = Loans.MemberID
group by Members.MemberID;

-- Chỉ hiển thị những thành viên có số lượng sách mượn lớn hơn 2.
Create view View_DSNameAndQuantity2 as select Members.MemberName, count(Loans.LoanId) from Members
join Loans on Members.MemberID = Loans.MemberID
group by Members.MemberID having count(Loans.LoanId)>2;

-- Lấy ra năm xuất bản sớm nhất (tức là giá trị nhỏ nhất của PublishedYear) từ bảng Books.
create view View_MinPublishedYear as select  Books.PublishedYear, Books.Title from Books
WHERE PublishedYear = (select min(PublishedYear) from Books);

-- Lấy ra danh sách các thành viên có ngày tham gia (JoinDate) nằm trong khoảng từ ‘2020-01-01’ đến ‘2022-12-31’.
create view View_Member as select  Members.MemberName, Members.JoinDate from Members
where JoinDate between '2020-01-01' and '2022-12-31';

-- Lấy ra danh sách các tác giả có tên chứa chữ a
create view View_AuthName as select AuthorName from Authors
where AuthorName  like '%a%';

-- Lấy ra danh sách các năm xuất bản (PublishedYear) từ bảng Books mà không bị trùng lặp.
create view View_PublishedYear as select DISTINCT PublishedYear from Books;
