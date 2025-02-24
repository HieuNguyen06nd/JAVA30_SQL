CREATE DATABASE RestaurantDB;
USE RestaurantDB;

-- Bảng Nhân viên
CREATE TABLE staff (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    hire_date DATE NOT NULL
);

INSERT INTO staff (full_name, phone, email, hire_date) VALUES
('Nguyen Van A', '0123456789', 'a@example.com', '2022-01-15'),
('Tran Thi B', '0987654321', 'b@example.com', '2021-05-20');


-- Bảng Khách hàng
CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE
);
INSERT INTO customers (name, phone, email) VALUES
('Le Van C', '0112233445', 'c@example.com'),
('Pham Thi D', '0223344556', 'd@example.com');
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
INSERT INTO orders (customer_id, staff_id, status, payment_status) VALUES
(1, 1, 'completed', 'paid'),
(2, 2, 'pending', 'unpaid');

-- Bảng Món ăn
CREATE TABLE menu (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50) NOT NULL
);

INSERT INTO menu (name, description, price, category) VALUES
('Pho Bo', 'Vietnamese beef noodle soup', 50000, 'Soup'),
('Banh Mi', 'Vietnamese sandwich', 25000, 'Fast Food');

-- Bảng Chi tiết đơn hàng
CREATE TABLE order_items (
    order_id INT,
    menu_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (quantity * price) STORED,
    PRIMARY KEY (order_id, menu_id),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_id) REFERENCES menu(id)
);

INSERT INTO order_items (order_id, menu_id, quantity, price) VALUES
(1, 1, 2, 50000),
(2, 2, 1, 25000);

INSERT INTO order_items (order_id, menu_id, quantity, price) VALUES
(1, 2, 2, 50000);

-- Bảng Nguyên liệu
CREATE TABLE inventory (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    quantity DECIMAL(10,2) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO inventory (name, description, quantity, unit) VALUES
('Beef', 'Fresh beef for pho', 20, 'kg'),
('Bread', 'Fresh baguette', 50, 'pcs');


-- Bảng Liên kết món ăn và nguyên liệu
CREATE TABLE menu_ingredients (
    menu_id INT,
    inventory_id INT,
    quantity DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (menu_id, inventory_id),
    FOREIGN KEY (menu_id) REFERENCES menu(id),
    FOREIGN KEY (inventory_id) REFERENCES inventory(id)
);

INSERT INTO menu_ingredients (menu_id, inventory_id, quantity) VALUES
(1, 1, 0.5),
(2, 2, 1);

-- Bảng Bàn ăn
CREATE TABLE tables (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_number INT UNIQUE NOT NULL,
    status ENUM('available', 'occupied', 'reserved') DEFAULT 'available',
    seats INT NOT NULL,
    location VARCHAR(50)
);

INSERT INTO tables (table_number, status, seats, location) VALUES
(1, 'available', 4, 'Indoor'),
(2, 'reserved', 2, 'Outdoor');

INSERT INTO tables (table_number, status, seats, location) VALUES
(3, 'available', 4, 'Indoor'),
(4, 'reserved', 2, 'Outdoor');

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

INSERT INTO reservations (table_id, customer_id, reservation_date, number_people, status) VALUES
(1, 1, '2025-02-22 18:00:00', 4, 'confirmed'),
(2, 2, '2025-02-23 19:30:00', 2, 'pending');

-- 1. Hiển thị tất cả đơn hàng cùng thông tin khách hàng và nhân viên phục vụ
select orders.id, staff.full_name as staff_name , customers.name as customer_name from orders 
join staff on orders.staff_id = staff.id
join customers on customers.id = orders.customer_id;

-- 2. Danh sách các món ăn kèm theo giá và loại xap xep theo gia
select menu.name, menu.price, menu.category from menu order by price desc;
-- 3. Hiển thị tất cả đơn hàng cùng chi tiết món ăn
select order_items.order_id, menu.name from order_items
join menu on menu.id = order_items.menu_id;

-- 4. Tính tổng doanh thu của nhà hàng
select sum(subtotal) from order_items;

-- 5. Tính tổng số tiền mà mỗi khách hàng đã chi tiêu
select sum(order_items.subtotal), customers.name from customers
join orders on orders.customer_id = customers.id
join order_items on order_items.order_id = orders.id
group by customers.id;

-- 6. Danh sách bàn ăn đã được đặt trong ngày hôm nay
select tables.table_number from tables
join reservations on reservations.table_id = tables.id
where date(reservation_date) = '2025-02-22'; -- CURDATE()

-- 7. Kiểm tra bàn nào đang trống
select tables.table_number from tables where tables.status = 'available';

-- 8 Tự động update khi đặt bàn
DELIMITER $$

CREATE TRIGGER update_table_status_after_reservation
AFTER INSERT ON reservations
FOR EACH ROW
BEGIN
    UPDATE tables
    SET status = 'reserved'
    WHERE id = NEW.table_id;
END$$

DELIMITER ;
-- 9 
DELIMITER $$

CREATE TRIGGER update_table_status_after_reservation
AFTER INSERT ON reservations
FOR EACH ROW
BEGIN
    UPDATE tables
    SET status = 'reserved'
    WHERE id = NEW.table_id;
END$$

DELIMITER ;
-- 10 Stored Procedure: Tự động hủy đặt bàn nếu quá giờ mà chưa được xác nhận

-- 11 Function: Tính tổng số lượng món ăn đã bán được

-- 12 Stored Procedure: Danh sách bàn trống theo ngày

-- 13 





