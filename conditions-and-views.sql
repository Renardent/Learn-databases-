

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