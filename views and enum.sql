-----------------

/*  ENUM   */

SELECT * FROM orders
WHERE status = true;

---- order status:
-- true - виконано
-- false - не виконано
--- 'processing' - 'proccessing' -- 'prosesing'

-- ('new', 'processing', 'shiped', 'done')

DROP VIEW users_with_age_and_amounts;
DROP VIEW users_with_total_amounts;
DROP VIEW users_with_orders_amount;

DROP VIEW orders_with_price;

CREATE TYPE order_status AS ENUM('new', 'processing', 'shiped', 'done');

ALTER TABLE orders
ALTER COLUMN status TYPE order_status;  ----- problem! impossible cast,неможливо змінити таблицю


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
---не вийде якщо дані використовуються views


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

CREATE SCHEMA tasks;


/*
Зробити дві ніяк не пов'язані між собою таблиці:
users: login, email, password
employees: salary, department, position, hire_date, name

*/

CREATE TABLE tasks.user (
    login varchar(100) NOT NULL CHECK (login != ''),
    email varchar(110) NOT NULL CHECK (email != ''),
    password varchar(30) NOT NULL CHECK (password != '')
);

CREATE TABLE tasks.employees (
    salary int NOT NULL CHECK (salary >=0),
    department varchar(100) NOT NULL CHECK (department != ''),
    position varchar(100) NOT NULL CHECK (position != ''),
    hire_date date DEFAULT current_date,
    name varchar(100) NOT NULL CHECK (name != '')
);

----current_date - повертає текущу дату

/*
Проблеми:
1. Відсутність ключа у юзерів. Ключем має бути мейл
2. Надлишкові дані про співробітників потребують нормалізації - декомпозиції таблиць на дві: співробітники та відділи
3. Зберігання паролю у сирому вигляді. Паролі мають зберігатись у захешованому вигляді (drop password + create password_hash).
*/

--- Всі зміни в таблицях проводити ALTER-ом.

--1+3
ALTER TABLE tasks.user
ADD PRIMARY KEY(email);

ALTER TABLE tasks.user
DROP COLUMN password;

ALTER TABLE tasks.user
ADD COLUMN password_hash varchar(200) NOT NULL CHECK (password_hash!='') ;

--2

ALTER TABLE tasks.employees
ADD COLUMN id serial PRIMARY KEY;

CREATE TABLE tasks.positions(
    department varchar(200) NOT NULL CHECK (department!=''),
    position varchar(200) NOT NULL CHECK (position!='')
);

ALTER TABLE tasks.employees
DROP COLUMN department;

ALTER TABLE tasks.employees
DROP COLUMN position;

ALTER TABLE tasks.positions 
ADD COLUMN id serial PRIMARY KEY;

INSERT INTO tasks.employees VALUES
('3000', '1880-09-22', 'Bitter'),
('8000','1880-09-22', 'Danna');


INSERT INTO tasks.positions VALUES (
    'HR', 'Secretary'
);

ALTER TABLE tasks.positions 
ADD CONSTRAINT "unique_pair" UNIQUE(department, position);

ALTER TABLE tasks.employees
ADD COLUMN position_id int REFERENCES tasks.positions(id);

ALTER TABLE task.employees
ADD COLUMN dismissal_date date DEFAULT current_date 
CHECK (dismissal_date>=hire_date);

UPDATE tasks.employees
SET position_id = 1
WHERE name = 'Danna';

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