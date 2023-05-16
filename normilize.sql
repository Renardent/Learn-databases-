-----Нормалізація БД-----

CREATE TABLE test(
    v1 char(13),
    v2 int
);

INSERT INTO test 
VALUES ('test', 1), ('abracadabra', 2), ('test', 1);

DELETE FROM test
WHERE v1 = 'test';

ALTER TABLE test
ADD CONSTRAINT "unique_check" UNIQUE(v1, v2);



------------


CREATE TABLE employees(
    id serial PRIMARY KEY,
    name varchar(200),
    department varchar(300),
    position varchar(300),
    car_aviability boolean
);


INSERT INTO employees (name, position, car_aviability)
VALUES
('John', 'HR', false),
('Jane', 'Sales', false),
('Jake', 'Developer', false),
('Andrew', 'driver', true);

---2NF

DROP TABLE employees;

CREATE TABLE positions (
    name varchar(300) PRIMARY KEY,
    department varchar(300),
    car_aviability boolean
);

INSERT INTO positions (name, car_aviability)
VALUES ('HR', false), ('Sales', false), ('Driver', true);

CREATE TABLE employees(
    id serial PRIMARY KEY,
    name varchar(200),
    position varchar(300) REFERENCES positions(name)
);

INSERT INTO employees (name, position) VALUES
('John', 'HR'), ('Jane', 'Sales'), ('Andrew', 'Driver');

INSERT INTO employees (name, position) VALUES
('Carl', 'Driver');


SELECT * FROM employees
JOIN positions ON employees.position = positions.name;




------------------


DROP TABLE employees;

DROP TABLE positions;


CREATE TABLE employees (
    id serial PRIMARY KEY,
    name varchar(200),
    department varchar(200),
    department_phone varchar(15)
);

INSERT INTO employees (name, department, department_phone) VALUES
('John Doe', 'HR', '23-12-15'),
('Jane Doe', 'Sales', '23-45-13'),
('Carl Moe', 'Developer', '45-67-89');

INSERT INTO employees (name, department, department_phone) VALUES
('Alex Kroe', 'Developer', '45-67-89');


CREATE TABLE departments (
    name varchar(200) PRIMARY KEY,
    phone_number varchar(15)
);

INSERT INTO departments VALUES 
('HR', '23-12-15'),
('Sales', '23-45-13'),
('Developer', '45-67-89');


ALTER TABLE employees
DROP COLUMN department_phone;


ALTER TABLE employees 
ADD FOREIGN KEY (department)
REFERENCES departments(name);


----------


CREATE TABLE students(
    id serial PRIMARY KEY,
    name varchar(30));

CREATE TABLE teachers(
    id serial PRIMARY KEY,
    name varchar(20),
    subject varchar(300) REFERENCES subjects(name)  ------<----
);

CREATE TABLE students_to_teachers(
    teacher_id int REFERENCES teachers(id),
    student_id int REFERENCES students(id),
    PRIMARY KEY (teacher_id, student_id)
);

INSERT INTO students_to_teachers VALUES
(1,1, 'biology'),
(1,2, 'biology'),
(2,1, 'math'),
(2,2, 'phisics'); ----- problem!


CREATE TABLE subjects (
    name varchar(300) PRIMARY KEY
);


------- Now:
INSERT INTO students_to_teachers VALUES
(1,1),
(1,2),
(2,1),
(2,2);

------Pizza Delivery------


/*
Ресторани роблять піци
Служби доставки розвозять піци
Ресторанів багато, ресторан зв'язаний зі службами доставки, які працюють в конкретних районах.
Служби доставки можуть працювати одночасно по декількох районах

*/

CREATE TABLE restaurants(
    id serial PRIMARY KEY
);

CREATE TABLE delivery_services(
    id serial PRIMARY KEY
);

CREATE TABLE restaurants_to_deliveries(
    restaurant_id int REFERENCES restaurants(id),
    delivery_id int REFERENCES delivery_services(id),
     pizza_type varchar(300),  
    PRIMARY KEY (restaurant_id, delivery_id)
);

INSERT INTO restaurants_to_deliveries VALUES
(1, 1, 'pepperoni'),
(1, 1, 'sea'),
(1, 1, '4chease'),
(1, 1, 'hawaii'),
(1, 2, 'peperoni'),
(1, 2, 'sea'),
(1, 2, 'chief'),
(1, 3, 'pepperoni'),
(1, 2, 'sea');   ----- problem!


CREATE TABLE pizzas(
    name varchar(200) PRIMARY KEY
);

CREATE TABLE pizzas_to_restaurants(
    pizza_type varchar(200) REFERENCES pizzas(name),
    restaurant_id int REFERENCES restaurants(id),
    PRIMARY KEY (pizza_type, restaurant_id)
);

CREATE TABLE restaurants_to_deliveries(
    restaurant_id int REFERENCES restaurants(id),
    delivery_id int REFERENCES delivery_services(id),
    PRIMARY KEY (restaurant_id, delivery_id)
);




/*
Practice:


Необхідно спроектувати БД поставки товарів
В БД має зберігатися наступна інформація:

ТОВАРИ:
- код товара, назва, ціна

ЗАМОВЛЕННЯ на поставку:
- код замовлення
- наименування постачальника, 
- адреса постачальника,
- телефон 
- номер договору
- дата заключення договору
- наіменування товару
- план поставки (кількість в шт.)

Фактичні відгрузки товару:
- код відгрузки
- код замовлення
- дата відгрузки
- відгружено товару (шт)

При проектуванні БД необхідно врахувати:
- товар має декілька замовлень на постачання.
- Замовлення відповідає одному товару
- товару можуть відповідати декілька відгрузок
- у одній вігрузці може бути декілька товарів

- товар не обов'язково має замовлення. Кожне замовлення відповідає товару
- товар не обов'язково відгружається замовнику, але кожна вігрузка обов'язково відповідає певному товару.

*/


CREATE TABLE products (
    id serial PRIMARY KEY,
    name varchar(300) CHECK (name != '') NOT NULL
);

CREATE TABLE manufacturers(
    id serial PRIMARY KEY,
    name varchar(300) NOT NULL,
    address text NOT NULL,
    tel_number varchar(20) NOT NULL
);

CREATE TABLE orders(
    id serial PRIMARY KEY,
    product_id int REFERENCES products(id),
    quantity_plan int NOT NULL,
    product_price decimal(10,2),
    contract_number int NOT NULL,
    contract_date date NOT NULL,
    manufacturer_id int REFERENCES manufacturers(id)
);


CREATE TABLE shipments(
    id serial PRIMARY KEY,
    order_id int REFERENCES orders(id),
    shipment_date date NOT NULL,
    PRIMARY KEY(id, order_id)
);

CREATE TABLE products_to_shipments(
    product_id REFERENCES products(id),
    shipment_id REFERENCES shipments(id),
    product_quantity int NOT NULL
)   