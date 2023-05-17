
CREATE TABLE a
(v char(3),
t int);

CREATE TABLE b
(v char(3));

drop table b

INSERT INTO a VALUES
('xxx', 1),
('xxy', 1),
('xxz', 1),
('xyx', 2),
('xyy', 2),
('xyz', 2),
('yxx', 3),
('yxy', 3),
('yxz', 3);

INSERT INTO b VALUES
('zxx'),
('xxx'),
('zxz'),
('yxz'),
('yxy');

SELECT * 
FROM a,b

SELECT v FROM a
UNION 
SELECT * FROM b
--11 rows - 9 з а +2 тих що не повторюються 

SELECT v FROM a
INTERSECT
SELECT * FROM b
--3 rows що повторюються і в А і в В

SELECT v FROM a
EXCEPT
SELECT * FROM b
--6 rows 9 з А мінус ті що повторюються з В

SELECT * FROM b
EXCEPT
SELECT v FROM a
--2 rows 5 з B мінус ті що повторюються з A

------------------------------------------
INSERT INTO users (
first_name,
last_name,
email,
is_subscribe,
birthday,
gender
)
VALUES (
'user1',
'test1',
'email@kdfhg',
true,
'1900-09-10',
'male'
),
(
'user2',
'test2',
'emaiddl@kdfhg',
true,
'1900-09-10',
'male'
),
(
'user3',
'test3',
'emasdfil@kdfhg',
true,
'1900-09-10',
'male'
);

--юзери які робили коли-небудь замовлення
SELECT id from users
INTERSECT
SELECT customer_id from orders

--юзери які не робили жодного разу замовлення
SELECT id from users
EXCEPT
SELECT customer_id from orders

----------------------


--Операції реляційної алгебри
-- 1. Об'єднання - UNION
-- Множина А + множина В, спільні елементи зустрічаються 1 раз (не дублюються)
-- 2. Перехрещення - INTERSECT
-- Тільки спільні для обох множин елементи (в 1 екземплярі)
-- 3. Різниця - EXCEPT 
-- Множина А мінус те, що є в В


SELECT id FROM users
EXCEPT
SELECT customer_id FROM orders;

SELECT * FROM a,b
WHERE A.v=B.v;

SELECT A.v AS "id",
        A.t AS "price",
        B.v AS "phone_id"
FROM a,b
WHERE A.v=B.v;

------Join

SELECT *
FROM a JOIN b
ON a.v=b.v;

/*

Замовлення певного юзера (айди 5)

*/

SELECT * FROM users
JOIN orders
ON orders.customer_id = users.id
WHERE users.id = 5;

/* використовуючи alias*/

SELECT u.*, o.id AS "order_id" 
FROM users AS u
JOIN orders AS o
ON o.customer_id=u.id
WHERE u.id=2;

/* декілька таблиць */

SELECT *
FROM a
JOIN b ON a.v = b.v
JOIN products ON a.t = products.id;

/* зробити топ-5 товарів*/

SELECT p.brand, count(*) AS "quantity"
FROM products AS p
JOIN orders_to_products AS ord
ON p.id = ord.product_id
GROUP BY p.brand 
ORDER BY "quantity" DESC
LIMIT 5;

--- юзери і кількість їхніх замовлень

SELECT count(*), u.* 
FROM users AS u 
JOIN orders AS o
ON u.id = o.customer_id
GROUP BY u.id;


/* юзери які нічого не замовляли*/




