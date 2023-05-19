 -----Нормалізація БД---------

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


---------NF3---------


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

-----Людина залежить від департмент, департмент від телефона, а людина не від телефона, це порушення БД

-----Образується надлишковість даних, дублюють номери 

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

INSERT INTO departments VALUES 
('Manager', '21-00-15');


ALTER TABLE employees
DROP COLUMN department_phone;


ALTER TABLE employees 
ADD FOREIGN KEY (department)
REFERENCES departments(name); 

---Поки в департменс не з'явиться нова посада, її не додати в емплойс

INSERT INTO employees (name, department) VALUES
('Alex Kris', 'Manager');


----BCNF------

CREATE TABLE students(
    id serial PRIMARY KEY,
    name varchar(30));

INSERT INTO students(name) VALUES 
('Alex Kris'),
('Bruno Mars Kris'),
('Alexsis Kroe');

----Викладач може вести лише один предмет
CREATE TABLE teachers(
    id serial PRIMARY KEY,
    name varchar(20),
    subject varchar(300) REFERENCES subjects(name)  ------<----
    ---посилаємось на сабжект
);

INSERT INTO teachers(name, subject) VALUES
('Moriarty William','math'),
('Doctor Who', 'biology'),
('Binarius Level','phisics');

CREATE TABLE students_to_teachers(
    teacher_id int REFERENCES teachers(id),
    student_id int REFERENCES students(id),
    PRIMARY KEY (teacher_id, student_id)
);

INSERT INTO students_to_teachers VALUES
(1,1, 'biology'),
(1,2, 'biology'),
(2,1, 'math'),
(2,2, 'phisics'); ----- problem! Викладач не викладає 2 предмети

---Створюємо ще одну таблицю

CREATE TABLE subjects (
    name varchar(300) PRIMARY KEY
);

INSERT INTO subjects(name) VALUES
('biology'),
('math'),
('phisics');

------- Result with data
INSERT INTO students_to_teachers VALUES
(1,1),
(1,2),
(2,1),
(2,2);

------4NF------
------Pizza Delivery------
/*
Ресторани роблять піци
Служби доставки розвозять піци
Ресторанів багато, ресторан зв'язаний зі службами доставки, які працюють в конкретних районах.
Служби доставки можуть працювати одночасно по декількох районах

*/

CREATE TABLE restaurants (
    id serial PRIMARY KEY
);

CREATE TABLE delivery_services(
    id serial PRIMARY KEY
);

INSERT INTO restaurants_to_deliveries VALUES 
(1,1, 'pepperoni'),
(1,1, '4chease'),
(1,2, 'hawaii'),
(1,2, 'chief'),
(1,1, 'sea');   ----- проблема, дуже багато даних тільки для одного ресторану

CREATE TABLE pizzas(
    name varchar(200) PRIMARY KEY
);

-----ще дві созалежні таблиці, піца залежить від ресторанів, де її роблять
-----прибираємо багатозначні залежності що приводять до аномалій

CREATE TABLE pizzas_to_restaurants(
    pizza_type varchar(200) REFERENCES pizzas(name),
    restaurant_id int REFERENCES restaurants(id),
    PRIMARY KEY (pizza_type, restaurant_id)
);

CREATE TABLE restaurants_to_deliveries (
    restaurant_id int REFERENCES restaurants(id),
    delivery_id int REFERENCES delivery_services(id),
    PRIMARY KEY (restaurant_id, delivery_id)
);
