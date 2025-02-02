create table Products(
	id int Primary key AUTO_INCREMENT,
    name varchar(255),
    category varchar(100),
	price DECIMAL(10, 2),
    stock INT
    );
    
SET SQL_SAFE_UPDATES = 0;

INSERT INTO Products (name, category, price, stock)
 VALUES
('Products 1', 'Loại 1', 50.00, 10),
('Products 2', 'Loại 2', 100.00, 20),
('Products 3', 'Loại 3', 150.00, 0),
('Products 4', 'Loại 4', 200.00, 5),
('Products 5', 'Loại 5', 300.00, 15);

UPDATE Products
SET price = price * 1.10
WHERE id = 2;

DELETE FROM Products
WHERE stock = 0;

SELECT * FROM Products
ORDER BY price ASC
LIMIT 1;

SELECT * FROM Products
ORDER BY price DESC
LIMIT 1;

SELECT SUM(stock) AS total, AVG(price) AS average_price
FROM Products;

SELECT * FROM Products
WHERE price > 100
ORDER BY price DESC;

SELECT * FROM Products
ORDER BY price ASC;

SELECT * FROM Products
ORDER BY price DESC;

SELECT * FROM Products
WHERE price > (SELECT AVG(price) FROM Products);



