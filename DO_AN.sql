CREATE DATABASE RestaurantDB;
USE RestaurantDB;
SET SQL_SAFE_UPDATES = 0;

-- Bảng Nhân viên
CREATE TABLE staff (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    hire_date DATE NOT NULL
);

-- Bảng Khách hàng
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE
);
-- Bảng Đơn hàng
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    staff_id INT,
    status ENUM('pending', 'in progress', 'completed', 'canceled') DEFAULT 'pending',
    payment_status ENUM('unpaid', 'paid', 'refunded') DEFAULT 'unpaid',
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (staff_id) REFERENCES staff(id)
);

-- Bảng Món ăn
CREATE TABLE menu (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50) NOT NULL
);

-- Bảng Chi tiết đơn hàng
CREATE TABLE order_items (
    order_id INT,
    menu_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, menu_id),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_id) REFERENCES menu(id)
);

-- Bảng Nguyên liệu
CREATE TABLE inventory (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    quantity DECIMAL(10,2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    supplier_id INT,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

-- Bảng Liên kết món ăn và nguyên liệu
CREATE TABLE menu_ingredients (
    menu_id INT,
    inventory_id INT,
    quantity DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (menu_id, inventory_id),
    FOREIGN KEY (menu_id) REFERENCES menu(id),
    FOREIGN KEY (inventory_id) REFERENCES inventory(id)
);

-- Bảng Nhà cung cấp
CREATE TABLE suppliers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Bàn ăn
CREATE TABLE tables (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_number INT UNIQUE NOT NULL,
    status ENUM('available', 'occupied', 'reserved') DEFAULT 'available',
    seats INT NOT NULL,
    location VARCHAR(50)
);

-- Bảng Đặt bàn
CREATE TABLE reservations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_id INT,
    customer_id INT,
    reservation_date DATETIME NOT NULL,
    number_people INT NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') DEFAULT 'pending',
    FOREIGN KEY (table_id) REFERENCES tables(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- insert
INSERT INTO suppliers (name, contact_name, phone, email, address) VALUES
('Fresh Farm', 'John Doe', '0123456789', 'john@freshfarm.com', '123 Green St.'),
('Organic Goods', 'Jane Smith', '0987654321', 'jane@organic.com', '456 Blue Rd.'),
('Seafood Supply', 'Mark Lee', '0345678901', 'mark@seafood.com', '789 Ocean Ave.');

INSERT INTO inventory (name, description, quantity, unit, supplier_id) VALUES
('Tomato', 'Fresh red tomatoes', 100, 'kg', 1),
('Olive Oil', 'Extra virgin olive oil', 50, 'liters', 2),
('Salmon', 'Fresh Atlantic salmon', 30, 'kg', 3),
('Flour', 'Organic whole grain flour', 80, 'kg', 2),
('Salt', 'Fine sea salt', 20, 'kg', 1);

INSERT INTO menu (name, description, price, category) VALUES
('Grilled Salmon', 'Salmon grilled with herbs', 250.00, 'Main Course'),
('Tomato Pasta', 'Pasta with fresh tomatoes and olive oil', 150.00, 'Main Course'),
('Garden Salad', 'Salad with seasonal vegetables', 120.00, 'Appetizer'),
('Garlic Bread', 'Bread with garlic and olive oil', 80.00, 'Appetizer');

INSERT INTO menu_ingredients (menu_id, inventory_id, quantity) VALUES
(1, 3, 0.3),
(2, 1, 0.2),
(2, 2, 0.05), 
(3, 1, 0.1), 
(4, 2, 0.02);

INSERT INTO staff (full_name, phone, email, hire_date) VALUES
('Alice Nguyen', '0912345678', 'alice@example.com', '2023-01-15'),
('Bob Tran', '0923456789', 'bob@example.com', '2022-05-10'),
('Charlie Le', '0934567890', 'charlie@example.com', '2021-11-20');

INSERT INTO customers (name, phone, email) VALUES
('David Pham', '0945678901', 'david@example.com'),
('Emma Vu', '0956789012', 'emma@example.com'),
('Frank Bui', '0967890123', 'frank@example.com');

INSERT INTO tables (table_number, status, seats, location) VALUES
(1, 'available', 4, 'Near window'),
(2, 'occupied', 2, 'Center'),
(3, 'reserved', 6, 'VIP area'),
(4, 'available', 4, 'Near entrance');

INSERT INTO reservations (table_id, customer_id, reservation_date, number_people, status) VALUES
(3, 1, '2025-03-01 19:00:00', 6, 'confirmed'),
(1, 2, '2025-03-02 18:30:00', 4, 'pending'),
(2, 3, '2025-03-03 20:00:00', 2, 'canceled');

INSERT INTO orders (customer_id, staff_id, status, payment_status, order_date) VALUES
(1, 1, 'completed', 'paid', '2025-02-23 18:00:00'),
(2, 2, 'in progress', 'unpaid', '2025-02-23 19:00:00'),
(3, 3, 'pending', 'unpaid', '2025-02-24 12:00:00');

INSERT INTO order_items (order_id, menu_id, quantity) VALUES
(1, 1, 2), 
(1, 2, 1),
(2, 3, 3), 
(2, 4, 2),
(3, 2, 1);

--  1. Sử dụng AND và OR: Tính doanh thu của từng món ăn, nhưng chỉ lấy món có giá trên 100 hoặc số lượng bán ra trên 5
select menu .name, sum(menu.price * order_items.quantity) from menu 
join order_items on menu.id = order_items.menu_id
join orders on orders.id = order_items.order_id
where menu.price > 100 or order_items.quantity >5 and orders.status =  'completed'
group by menu.name;

-- 2 Tìm món ăn có giá cao nhất trong menu
select * from menu where price = (select max(price) from menu);
-- 3. ORDER BY Danh sách đơn hàng được sắp xếp theo ngày đặt hàng mới nhất:
select * from orders order by order_date desc;

-- 4 Thống kê số đơn hàng của từng khách hàng và chỉ hiển thị những khách có từ 2 đơn trở lên:
select customers.id, customers.name , count(orders.id) from orders 
join customers on customers.id = orders.customer_id
group by customer_id having count(orders.id)>2;

-- 5 Tính tổng số lượng món ăn đã bán, trung bình giá món ăn và tổng doanh thu:
select sum(order_items.quantity), avg(menu.price), sum(order_items.quantity * menu.price) from order_items
 join menu on menu.id = order_items.menu_id;

-- 6 Tìm các món ăn có tên chứa chữ "Pizza":
select * from menu where menu.name like '%Pasta%';

-- 7 Tạo view thống kê doanh thu theo món ăn:
create view View_ds_menu as select menu.name, sum(menu.price * order_items.quantity) from menu
join order_items on menu.id = order_items.menu_id
group by menu.name;

select * from View_ds_menu;

-- 8 Hàm tính tổng tiền của một đơn hàng theo ID:\
delimiter $$
create function order_sum (id_order int)
returns DECIMAL(10,2)
DETERMINISTIC
begin
	declare total DECIMAL(10,2);
    select sum(menu.price * order_items.quantity) into total from order_items
    join menu on menu.id = order_items.menu_id
    where order_id = id_order;
    
    return total;

end $$
delimiter ;

select order_sum(2);

-- 9. STORED PROCEDURE Lấy danh sách bàn trống theo ngày:
delimiter $$
create procedure get_table( in Idate datetime)
begin
	select t.table_number, t.seats from tables t left join reservations r
    on t.id = r.table_id
    and date(r.reservation_date) = date(Idate)
    where t.status =  'available' OR r.id IS NULL;
end $$
delimiter ;

call get_table('2025-09-08');


