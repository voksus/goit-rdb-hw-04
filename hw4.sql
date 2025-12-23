-- Task 1:
-- a)
CREATE SCHEMA IF NOT EXISTS library_management; -- Перейменував для кращої ліквідності
USE library_management;
-- b)
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(50) NOT NULL
);
-- c)
CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL
);
-- d)
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    publication_year YEAR,
    author_id INT,
    genre_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);
-- e)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);
-- f)
CREATE TABLE borrowed_books (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    user_id INT,
    borrow_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Task 2:
-- Authors
INSERT INTO authors (author_id, author_name) 
VALUES (1, 'Василь Стус'), 
       (2, 'Ліна Костенко');
-- Genres
INSERT INTO genres (genre_id, genre_name) 
VALUES (1, 'Поезія'), 
       (2, 'Історичний роман');
-- Books
INSERT INTO books (book_id, title, publication_year, author_id, genre_id) 
VALUES (1, 'Палімпсести', 1986, 1, 1),
       (2, 'Записки українського самашедшого', 2010, 2, 2);
-- Users
INSERT INTO users (user_id, username, email) 
VALUES (1, 'Андрій Мельник', 'andrii.m@ukr.net'),
       (2, 'Оксана Петренко', 'oksana.p@gmail.com');
-- Borrowed books
INSERT INTO borrowed_books (borrow_id, book_id, user_id, borrow_date, return_date) 
VALUES (1, 1, 1, '2023-10-01', '2023-10-15'),
       (2, 2, 2, '2023-11-20', NULL);

-- Task 3:
USE mydb_hw3;
SELECT
    od.order_id  AS 'Order ID',
    c.name       AS 'Customer Name',
    e.first_name AS 'Employee First Name',
    e.last_name  AS 'Employee Last Name',
    o.date       AS 'Order Date',
    p.name       AS 'Product Name',
    cat.name     AS 'Category Name',
    s.name       AS 'Supplier Name',
    sh.name      AS 'Shipper Name',
    od.quantity  AS 'Quantity',
    p.price      AS 'Price'
FROM order_details    AS od
INNER JOIN orders     AS o   ON od.order_id   = o.id
INNER JOIN customers  AS c   ON o.customer_id = c.id
INNER JOIN employees  AS e   ON o.employee_id = e.employee_id
INNER JOIN shippers   AS sh  ON o.shipper_id  = sh.id
INNER JOIN products   AS p   ON od.product_id = p.id
INNER JOIN categories AS cat ON p.category_id = cat.id
INNER JOIN suppliers  AS s   ON p.supplier_id = s.id;

-- Task 4:
-- a)
USE mydb_hw3;
SELECT COUNT(*) AS 'Total rows'
FROM order_details    AS od
INNER JOIN orders     AS o   ON od.order_id = o.id
INNER JOIN customers  AS c   ON o.customer_id = c.id
INNER JOIN employees  AS e   ON o.employee_id = e.employee_id
INNER JOIN shippers   AS sh  ON o.shipper_id = sh.id
INNER JOIN products   AS p   ON od.product_id = p.id
INNER JOIN categories AS cat ON p.category_id = cat.id
INNER JOIN suppliers  AS s   ON p.supplier_id = s.id;
-- b)
USE mydb_hw3;
SELECT
    od.order_id  AS 'Order ID',
    c.name       AS 'Customer Name',
    e.first_name AS 'Employee First Name',
    e.last_name  AS 'Employee Last Name',
    o.date       AS 'Order Date',
    p.name       AS 'Product Name',
    cat.name     AS 'Category Name',
    s.name       AS 'Supplier Name',
    sh.name      AS 'Shipper Name',
    od.quantity  AS 'Quantity',
    p.price      AS 'Price'
FROM order_details    AS od
LEFT JOIN orders     AS o   ON od.order_id   = o.id
LEFT JOIN customers  AS c   ON o.customer_id = c.id
INNER JOIN employees  AS e   ON o.employee_id = e.employee_id
INNER JOIN shippers   AS sh  ON o.shipper_id  = sh.id
INNER JOIN products   AS p   ON od.product_id = p.id
INNER JOIN categories AS cat ON p.category_id = cat.id
INNER JOIN suppliers  AS s   ON p.supplier_id = s.id;
-- c,d,e,f,g)
USE mydb_hw3;
SELECT
    cat.name AS category_name,
    COUNT(*) AS row_count,                                 -- 4.d) Amount Calculation...
    AVG(od.quantity) AS avg_product_quantity               -- .... here
FROM order_details AS od
INNER JOIN orders AS o ON od.order_id = o.id
INNER JOIN customers AS c ON o.customer_id = c.id
INNER JOIN employees AS e ON o.employee_id = e.employee_id
INNER JOIN shippers AS sh ON o.shipper_id = sh.id
INNER JOIN products AS p ON od.product_id = p.id
INNER JOIN categories AS cat ON p.category_id = cat.id
INNER JOIN suppliers AS s ON p.supplier_id = s.id
WHERE e.employee_id > 3 AND e.employee_id <= 10            -- 4.c) Filtering
GROUP BY cat.name                                          -- 4.d) Groupping
HAVING avg_product_quantity > 21                           -- 4.e) Filter by quantity
ORDER BY row_count DESC                                    -- 4.f) Ordering
LIMIT 4 OFFSET 1;                                          -- 4.g) Paggination