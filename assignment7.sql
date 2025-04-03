CREATE DATABASE bookstoredb;

CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL,
    published_year INT NOT NULL CHECK (published_year > 0)
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    joined_date DATE NOT NULL
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    book_id INT NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity > 0),
    order_date DATE NOT NULL
);

-- Insert values into books table
INSERT INTO books (title, author, price, stock, published_year) VALUES
('Book A', 'Author A', 19.99, 10, 2020),
('Book B', 'Author B', 25.50, 5, 2018),
('Book C', 'Author C', 15.75, 20, 2021),
('Book D', 'Author D', 30.00, 8, 2019),
('Book E', 'Author E', 12.99, 15, 2022),
('Book F', 'Author F', 22.49, 12, 2017),
('Book G', 'Author G', 18.00, 7, 2020),
('Book H', 'Author H', 27.99, 9, 2021),
('Book I', 'Author I', 14.50, 25, 2016),
('Book J', 'Author J', 35.00, 4, 2019);


-- INSERT INTO books (title, author, price, stock, published_year) VALUES
-- ('Book K', 'Author A', 18.99, 0, 2020);


-- Insert values into customers table
INSERT INTO customers (name, email, joined_date) VALUES
('Customer A', 'customerA@example.com', '2023-01-01'),
('Customer B', 'customerB@example.com', '2023-02-15'),
('Customer C', 'customerC@example.com', '2023-03-10'),
('Customer D', 'customerD@example.com', '2023-04-05'),
('Customer E', 'customerE@example.com', '2023-05-20'),
('Customer F', 'customerF@example.com', '2023-06-25'),
('Customer G', 'customerG@example.com', '2023-07-30'),
('Customer H', 'customerH@example.com', '2023-08-15'),
('Customer I', 'customerI@example.com', '2023-09-10'),
('Customer J', 'customerJ@example.com', '2023-10-01');

-- INSERT INTO customers (name, email, joined_date) VALUES ('Customer K', 'customerk@example.com', '2023-10-05'), ('Customer L', 'customerL@example.com', '2023-10-04');
 

-- Insert values into orders table
INSERT INTO orders (customer_id, book_id, quantity, order_date) VALUES
(1, 1, 2, '2023-01-05'),
(2, 2, 1, '2023-02-20'),
(3, 3, 3, '2023-03-15'),
(4, 4, 1, '2023-04-10'),
(5, 5, 2, '2023-05-25'),
(6, 6, 1, '2023-06-30'),
(7, 7, 4, '2023-07-20'),
(8, 8, 2, '2023-08-25'),
(9, 9, 1, '2023-09-15'),
(10, 10, 3, '2023-10-05');

--  INSERT INTO orders (customer_id, book_id, quantity, order_date) VALUES
--   (1, 11, 1, '2023-01-10');


--! Testing the database
-- ?
SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

--?


--TODO: Query 1: Find books that are out of stock.
SELECT * FROM books 
    WHERE stock = 0;

-- NOTE: The above query will return no results since all books have stock > 0.

--TODO: Query 2: Retrieve the most expensive book in the store.
SELECT * FROM books 
    WHERE price = 
        (SELECT MAX(price) FROM books);

-- NOTE: The above query will return the most expensive book in the store. 

--TODO: Query 3: Find the total number of orders placed by each customer.
SELECT c.name, COUNT(o.id) AS total_orders 
    FROM customers c 
        INNER JOIN orders o 
            ON c.id = o.customer_id 
                GROUP BY c.name 
                    ORDER BY c.name ASC;

-- NOTE: The above query will return the total number of orders placed by each customer. First the customers are joined with the orders table, then grouped by customer name, and finally ordered by customer name in ascending order.

-- TODO: Query 4: Calculate the total revenue generated from book sales.
SELECT SUM(b.price * o.quantity) 
    AS total_revenue 
        FROM books b
            INNER JOIN orders o 
                ON b.id = o.book_id;
-- NOTE: The above query will return the total revenue generated from book sales. The books table is joined with the orders table, and the total revenue is calculated by multiplying the price of each book by the quantity sold. The result is the sum of all these values.


--TODO: Query 5: List all customers who have placed more than one order.
SELECT c.name, COUNT(o.id) AS total_orders 
    FROM customers c 
        INNER JOIN orders o 
            ON c.id = o.customer_id 
                GROUP BY c.name 
                    HAVING COUNT(o.id) > 1;
-- NOTE: The above query will return all customers who have placed more than one order. The customers table is joined with the orders table, and the results are grouped by customer name. The HAVING clause filters the results to include only those customers with more than one order.

--TODO: Query 6: Find the average price of books in the store.
SELECT AVG(price) AS average_price 
    FROM books;
-- NOTE: The above query will return the average price of books in the store. The AVG function calculates the average price from the books table.

--TODO: Query 7: Increase the price of all books published before 2000 by 10%.
UPDATE books
    SET price = price*1.10 
        WHERE published_year < 2000;

-- NOTE: The above query will increase the price of all books published before 2000 by 10%. The UPDATE statement modifies the price of the books in the books table where the published year is less than 2000.

--TODO: Query 8: Delete customers who haven't placed any orders.
DELETE FROM 
    customers
        WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders);
-- NOTE: The above query will delete customers who haven't placed any orders. The DELETE statement removes customers from the customers table whose IDs are not present in the orders table.