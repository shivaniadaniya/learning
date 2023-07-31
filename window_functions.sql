CREATE TABLE product_groups (
	group_id serial PRIMARY KEY,
	group_name VARCHAR (255) NOT NULL
);


CREATE TABLE products (
	product_id serial PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	price DECIMAL (11, 2),
	group_id INT NOT NULL,
	FOREIGN KEY (group_id) REFERENCES product_groups (group_id)
);

INSERT INTO product_groups (group_name)
VALUES
	('Smartphone'),
	('Laptop'),
	('Tablet');


INSERT INTO products (product_name, group_id,price)
VALUES
	('Microsoft Lumia', 1, 200),
	('HTC One', 1, 400),
	('Nexus', 1, 500),
	('iPhone', 1, 900),
	('HP Elite', 2, 1200),
	('Lenovo Thinkpad', 2, 700),
	('Sony VAIO', 2, 700),
	('Dell Vostro', 2, 800),
	('iPad', 3, 700),
	('Kindle Fire', 3, 150),
	('Samsung Galaxy Tab', 3, 200);
	
************************** AVG() *********************
SELECT AVG (price) FROM products;
-- 586.3636363636363636

SELECT group_name, AVG (price)
FROM products INNER JOIN product_groups USING (group_id)
GROUP BY group_name;

-- "Smartphone"	500.0000000000000000
-- "Tablet"	350.0000000000000000
-- "Laptop"	850.0000000000000000

SELECT product_name, price, group_name, AVG (price) OVER 
(PARTITION BY group_name) FROM products 
INNER JOIN product_groups USING (group_id);

-- "HP Elite"	1200.00	"Laptop"	850.0000000000000000
-- "Lenovo Thinkpad"	700.00	"Laptop"	850.0000000000000000
-- "Sony VAIO"	700.00	"Laptop"	850.0000000000000000
-- "Dell Vostro"	800.00	"Laptop"	850.0000000000000000
-- "Microsoft Lumia"	200.00	"Smartphone"	500.0000000000000000
-- "HTC One"	400.00	"Smartphone"	500.0000000000000000
-- "Nexus"	500.00	"Smartphone"	500.0000000000000000
-- "iPhone"	900.00	"Smartphone"	500.0000000000000000
-- "iPad"	700.00	"Tablet"	350.0000000000000000
-- "Kindle Fire"	150.00	"Tablet"	350.0000000000000000
-- "Samsung Galaxy Tab"	200.00	"Tablet"	350.0000000000000000

********************** ROW_NUMBER() ******************
SELECT * FROM products

select product_id, product_name, group_id, ROW_NUMBER() OVER (ORDER BY product_id)
from products

-- 1	"Microsoft Lumia"	1	1
-- 2	"HTC One"	1	2
-- 3	"Nexus"	1	3
-- 4	"iPhone"	1	4
-- 5	"HP Elite"	2	5
-- 6	"Lenovo Thinkpad"	2	6
-- 7	"Sony VAIO"	2	7
-- 8	"Dell Vostro"	2	8
-- 9	"iPad"	3	9
-- 10	"Kindle Fire"	3	10
-- 11	"Samsung Galaxy Tab"	3	11

select product_id, product_name, group_id, ROW_NUMBER() OVER (ORDER BY product_name)
from products

-- 8	"Dell Vostro"	2	1
-- 5	"HP Elite"	2	2
-- 2	"HTC One"	1	3
-- 9	"iPad"	3	4
-- 4	"iPhone"	1	5
-- 10	"Kindle Fire"	3	6
-- 6	"Lenovo Thinkpad"	2	7
-- 1	"Microsoft Lumia"	1	8
-- 3	"Nexus"	1	9
-- 11	"Samsung Galaxy Tab"	3	10
-- 7	"Sony VAIO"	2	11

select Distinct price, ROW_NUMBER() OVER (ORDER BY price) from products

-- 150.00	1
-- 200.00	2
-- 200.00	3
-- 400.00	4
-- 500.00	5
-- 700.00	6
-- 700.00	7
-- 700.00	8
-- 800.00	9
-- 900.00	10
-- 1200.00	11


select * from (
select product_id, product_name, price, ROW_NUMBER() OVER (ORDER BY product_name) from products
) x WHERE ROW_NUMBER BETWEEN 6 AND 10;
-- 10	"Kindle Fire"	150.00	6
-- 6	"Lenovo Thinkpad"	700.00	7
-- 1	"Microsoft Lumia"	200.00	8
-- 3	"Nexus"	500.00	9
-- 11	"Samsung Galaxy Tab"	200.00	10

-- Ways to fined third highest price from products
select price, ROW_NUMBER() over (order by price desc) from products

-- =================
SELECT price
FROM products
group by price
ORDER BY price DESC
LIMIT 1 OFFSET 2;

-- =========================
select * from products where price = (
    select price from (
        select price, ROW_NUMBER() over (order by price desc) nth from (
            select distinct(price) from products
            ) price
        )sorted_price
    WHERE nth = 3
)
-- 8	"Dell Vostro"	800.00	2
-- =================================

-- ***************** RANK() **********************

The RANK() function assigns a rank to every row within a partition of a result set.
For each partition, the rank of the first row is 1. 
The RANK() function adds the number of tied rows to the tied rank to calculate the rank of the next row, 
so the ranks may not be sequential. In addition, rows with the same values will get the same rank.
-- =====================================
CREATE TABLE ranks (
	c VARCHAR(10)
);

INSERT INTO ranks(c)
VALUES('A'),('A'),('B'),('B'),('B'),('C'),('E');

select * from ranks

select c, rank() over (order by c) from ranks
-- "A"	1
-- "A"	1
-- "B"	3
-- "B"	3
-- "B"	3
-- "C"	6
-- "E"	7











































