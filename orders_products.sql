/*
Агрегатні функції 

1. Кількість тел, які були продані (СУМА ВСІХ КІЛЬКОСТЕЙ)
2. Кількість тел, які є "на складі" ( в продуктс)
3. Середня ціна всіх телефонів
4. Середня ціна кожного бренду
5. Сума вартості всіх телефонів, які коштують в діапазоні від 1 до 2к
6. Кількість моделей кожного бренду
7. Кількість замовлень кожного користувача, який робив замовлення (по ордерсам і згрупувати по ід користувача)
8. Середня ціна нокії
9. Кількість проданих моделей

*/

--1

SELECT sum(quantity)
FROM orders_to_products;

--2

SELECT sum(quantity)
FROM products;

--3

SELECT avg(price)
FROM products;

--4

SELECT brand, avg(price)
FROM products
GROUP BY brand;

--5

SELECT sum(quantity*price)
FROM products
WHERE price BETWEEN 1000 AND 2000;

--6

SELECT brand, count(*)
FROM products
GROUP BY brand;

--7

SELECT count(*), customer_id
FROM orders
GROUP BY customer_id;

--8

SELECT  avg(price)
FROM products
WHERE brand = 'Nokia';

--9

SELECT sum(quantity), product_id
FROM orders_to_products
GROUP BY product_id;

--------Скільки моделей залишилось менше всього----------------

SELECT *
FROM products
ORDER BY quantity ASC;

--------Sorting----------

SELECT * FROM users
ORDER BY id ASC;

/*ascending*/

SELECT * FROM users
ORDER BY id DESC;

/*descending*/

UPDATE users
SET birthday = '1940-05-12'
WHERE id BETWEEN 5 AND 10;

SELECT * FROM users
ORDER BY birthday;

SELECT * FROM users
ORDER BY birthday ASC,
                first_name ASC;


/*

1. Вісортувати юзерів за віком (кількістю повних років)
2. Відсортувати телефони за ціною від найдорожчого до найдешевшого
3. Виведіть топ-5 телефонів, які частіше за все купують

*/

--1

SELECT extract('years' from age(birthday)),* FROM users
ORDER BY extract('years' from age(birthday)) ;

--2

SELECT * FROM products
ORDER BY price DESC;

--3

SELECT * FROM orders_to_products
ORDER BY product_id DESC;


/*
1. Витягти всі бренди, у яких кількість телефонів > 1000
2. Витягти всі бренди, в яких продано більше 50 тел
*/

--1
SELECT brand, sum(quantity)
FROM products
GROUP BY brand
HAVING sum(quantity) > 1000;

--2
SELECT product_id, sum(quantity)
FROM orders_to_products
GROUP BY product_id
HAVING sum(quantity) > 50;

----