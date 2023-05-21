
/*
Вивести всі телефони (з таблиці products), 
якщо ціна більше 6тис - флагман
якщо ціна від 2 до 6 - середній клас
якщо ціна <2 тис - бюджетний

*/


SELECT *,(
    CASE
    WHEN price > 6000 THEN 'Флагман'
    WHEN price BETWEEN 2000 AND 6000 THEN 'Середній клас'
    WHEN price < 2000 THEN 'Бюджетний'
    ELSE 'Інше'
END
)
FROM products;


/*
Вивести користувачів з інформацією про їхні замовлення у вигляді:
- якщо більше >=3 - постійний клієнт
- якщо від 1 до 2 - активний клієнт
- якщо 0 замовлень - новий клієнт

*/

SELECT u.id, u.email, (
    CASE 
        WHEN count(o.id) >= 3
        THEN 'Постійний клієнт'
        WHEN count(o.id) BETWEEN 1 AND 2
        THEN 'Активний клієнт'
        WHEN count(o.id) = 0
        THEN 'Новий клієнт'
        ELSE 'Клієнт'
    END
)
FROM users AS u
LEFT JOIN orders AS o 
ON u.id = o.customer_id
GROUP BY u.id, u.email
ORDER BY count(o.id);



INSERT INTO users (
    first_name,
    last_name,
    email,
    gender,
    is_subscribe,
    birthday
) VALUES
('Iron', 'Man', 'tonymail@com', 'male', true, '1990-08-09');




-------------


SELECT count(id)
FROM products
WHERE price > 3000;

SELECT sum(
    CASE WHEN
    price > 3000 THEN 1
    ELSE 0
    END
)
FROM products;



------COALESCE

SELECT COALESCE(NULL, 12, 24) --- 12
COALESCE(NULL, NULL, NULL) --- NULL

/* Опис телефонів - якщо опису немає, вивести "Про цей товар нічого не відомо"  */

UPDATE products
SET description = 'Супер телефон з довгим описом'
WHERE id BETWEEN 324 AND 350;

SELECT id, brand, model, price, COALESCE(description, 'Про цей товар нічого не відомо')
FROM products;



-------------NULLIF

NULLIF(NULL, NULL) --- NULL
NULLIF(12, 12) - NULL
NULLIF(12, NULL) - 12
NULLIF(NULL, 12) - NULL


--- Не можемо порівнювати рядок і число

SELECT model, price, NULLIF(category, 'phones')
FROM products;




-------GREATEST, LEAST

--GREATEST - найбільше зі списку аргументів
--LEAST - найменше зі списку аргументів

SELECT id, brand, model, LEAST(price, discounted_price)
FROM products;


INSERT INTO products
(brand, model, category, price, discounted_price, quantity)
VALUES
('Iphone', '2000', 'smartphones', 10000, 8000, 1);




------Підзапити----

---IN, NOT IN, SOME, ANY, EXISTS


/* Знайти всіх користувачів, які не робили замовлень */

SELECT * FROM users AS u
WHERE u.id NOT IN (SELECT customer_id FROM orders);

----Телефони, яких ніхто не замовляв

SELECT * FROM products AS p
WHERE p.id NOT IN (SELECT product_id FROM orders_to_products);


----EXISTS---

SELECT EXISTS (SELECT * 
        FROM users AS u
        WHERE u.id = 23 );


SELECT EXISTS (SELECT * FROM orders AS o
                WHERE o.customer_id = 2542);

SELECT * FROM orders AS o
WHERE o.customer_id = 2542;


------ANY/SOME---

--ANY - IN

SELECT * FROM users AS u
WHERE u.id = ANY (SELECT customer_id FROM orders);

SELECT * FROM users AS u
WHERE u.id = SOME (SELECT customer_id FROM orders);


SELECT * FROM products AS p
WHERE p.id != ALL 
    (SELECT product_id FROM orders_to_products);



/*
Знайти всі телефони, які купував юзер №23

*/

SELECT * 
FROM products AS p
WHERE p.id = ANY (
            SELECT product_id FROM orders_to_products AS otp
            WHERE otp.order_id = SOME (
                            SELECT id FROM orders AS o
                            WHERE customer_id = 2335
                            )
            );



SELECT * FROM products AS p
JOIN orders_to_products AS otp
ON otp.product_id = p.id
JOIN orders AS o
ON otp.order_id = o.id
WHERE o.customer_id = 2335;




------VIEWS---------

--Віртуальні таблиці--

SELECT * FROM users;

SELECT u.*, count(o.id) AS "orders_amount"
FROM users AS u
LEFT JOIN orders AS o ON u.id = o.customer_id
GROUP BY u.id, u.email
ORDER BY "orders_amount";

CREATE VIEW users_with_orders_amount AS (
    SELECT u.*, count(o.id) AS "orders_amount"
    FROM users AS u
    LEFT JOIN orders AS o ON u.id = o.customer_id
    GROUP BY u.id, u.email
    ORDER BY "orders_amount"
);

SELECT * FROM users_with_orders_amount;


---- Витягти всі мейли юзерів, які мають 1 замовлення
SELECT email FROM
users_with_orders_amount
WHERE orders_amount = 1;



/*
Представлення, яке зберігає замовлення з їхньою вартістю

*/


SELECT o.id, o.customer_id, sum(p.price * otp.quantity), o.status 
FROM orders AS o 
JOIN orders_to_products AS otp 
ON o.id = otp.order_id
JOIN products AS p
ON p.id = otp.product_id
GROUP BY o.id;

DROP VIEW orders_with_price;

CREATE VIEW orders_with_price AS (
    SELECT o.id, o.customer_id, sum(p.price * otp.quantity) AS "order_sum", o.status
    FROM orders AS o 
    JOIN orders_to_products AS otp 
    ON o.id = otp.order_id
    JOIN products AS p
    ON p.id = otp.product_id
    GROUP BY o.id
);


/*
Вивести юзерів з сумою коштів, які вони витратили в нашому магазині

*/

SELECT u.id, u.email, sum(owp.order_sum) FROM
users AS u 
JOIN orders_with_price AS owp
ON u.id = owp.customer_id
GROUP BY u.id;

--- Вивести топ-10 покупців, які залишили найбільше грошей в нашому магазині
SELECT u.id, u.email, u.first_name, u.last_name, sum(owp.order_sum) AS sum_amount
FROM
users AS u 
JOIN orders_with_price AS owp
ON u.id = owp.customer_id
GROUP BY u.id
ORDER BY sum_amount DESC
LIMIT 10;


DROP VIEW users_with_total_amounts;

CREATE VIEW users_with_total_amounts AS (
    SELECT u.*, sum(owp.order_sum) AS "total_amount"
    FROM
        users AS u 
        JOIN orders_with_price AS owp
        ON u.id = owp.customer_id
        GROUP BY u.id
);




SELECT * FROM users_with_total_amounts
ORDER BY total_amount DESC
LIMIT 10;


-- Створіть представлення, що містить дані юзера, кількість повних років та повну суму їхніх замовлень.
--На основі цього виведіть всіх користувачів старше 30 років

CREATE VIEW users_with_age_and_amounts AS (
SELECT *, extract('years' from age(birthday)) AS "age"
FROM users_with_total_amounts
);

SELECT * FROM users_with_age_and_amounts
WHERE age > 30;

DROP VIEW users_with_age_and_amounts;
DROP VIEW users_with_total_amounts;
DROP VIEW users_with_orders_amount;

DROP VIEW orders_with_price;

-----------------

/*  ENUM   */

SELECT * FROM orders
WHERE status = true;

---- order status:
-- true - виконано
-- false - не виконано


--- 'processing' - 'proccessing' -- 'prosesing'


-- ('new', 'processing', 'shiped', 'done')

CREATE TYPE order_status AS ENUM('new', 'processing', 'shiped', 'done');

ALTER TABLE orders
ALTER COLUMN status TYPE order_status;  ----- problem! impossible cast


ALTER TABLE orders
ALTER COLUMN status
TYPE order_status
USING (
    CASE status
    WHEN false THEN 'processing'
    WHEN true THEN 'done'
    ELSE 'new'
    END
)::order_status;


INSERT INTO orders (customer_id, status) VALUES
(2335, 'new');  ---ok!

SELECT * FROM orders
ORDER BY created_at DESC;


INSERT INTO orders (customer_id, status) VALUES
(2335, 'shiped');

UPDATE orders
SET status = 'shiped'
WHERE id = 2543;



------------------


CREATE SCHEMA newtask;


/*
Зробити дві ніяк не пов'язані між собою таблиці:
users: login, email, password
employees: salary, department, position, hire_date, name

*/

CREATE TABLE newtask.users(
    login varchar(200) NOT NULL CHECK (login!=''),
    email varchar(300) NOT NULL CHECK (email!=''),
    password varchar(300) NOT NULL CHECK (password != '')
);

CREATE TABLE newtask.employees(
    name varchar(200) NOT NULL CHECK (name!=''),
    salary int NOT NULL CHECK (salary >= 0),
    department varchar(200) NOT NULL CHECK (department!=''),
    position varchar(200) NOT NULL CHECK (position!=''),
    hire_date date DEFAULT current_date
);

/*
Проблеми:
1. Відсутність ключа у юзерів. Ключем має бути мейл
2. Надлишкові дані про співробітників потребують нормалізації - декомпозиції таблиць на дві: співробітники та відділи
3. Зберігання паролю у сирому вигляді. Паролі мають зберігатись у захешованому вигляді (drop password + create password_hash).
*/

--- Всі зміни в таблицях проводити виключно ALTER-ом.



---1

ALTER TABLE newtask.users
ADD PRIMARY KEY (email);

ALTER TABLE newtask.employees
ADD COLUMN id serial PRIMARY KEY;

CREATE TABLE newtask.positions(
    department varchar(200) NOT NULL CHECK (department!=''),
    position varchar(200) NOT NULL CHECK (position!=''),
    PRIMARY KEY (department, position)
);

INSERT INTO newtask.positions VALUES (
    'HR', 'Secretary'
);

ALTER TABLE newtask.positions
DROP CONSTRAINT "positions_pkey";

ALTER TABLE newtask.positions 
ADD COLUMN id serial PRIMARY KEY;

ALTER TABLE newtask.positions 
ADD CONSTRAINT "unique_pair" UNIQUE(department, position);

ALTER TABLE newtask.employees
DROP COLUMN department;

ALTER TABLE newtask.employees
DROP COLUMN position;

ALTER TABLE newtask.employees
ADD COLUMN position_id int REFERENCES newtask.positions(id);



ALTER TABLE newtask.employees
ADD COLUMN dismissal_date date DEFAULT current_date 
CHECK (dismissal_date>=hire_date);


/*

1. Зв'язати таблиці юзерів та співробітників за принципом:
Юзер може бути співробітником, а може не бути ним.
Співробітник має бути юзером.

2.Створити view, яке містить інформацію про юзерів, їхні дані співробітника: департамент та позицію, де вони працюють і скільки вони заробляють. При цьому, якщо в колонці з зарплатнею буде 0, має вивестись "Практикант"

*/















----------

CREATE TABLE dates (
    new_date date CHECK(new_date > '1990-02-05')
);


INSERT INTO dates VALUES('2021-09-09'); 
INSERT INTO dates VALUES('1987-02-03');