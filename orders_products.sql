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

------------------

SELECT brand, min(quantity)
FROM products
GROUP BY brand; /* */