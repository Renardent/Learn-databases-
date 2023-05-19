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
