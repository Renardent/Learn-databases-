SELECT * FROM users;

SELECT first_name, last_name FROM users;

SELECT first_name FROM users WHERE id < 1000;

SELECT first_name, last_name FROM users WHERE gender = 'male';


/*
Зробіть запит, щоб отримати всіх користувачів, які підписані на наші новини

*/

SELECT * FROM users WHERE is_subscribe;

SELECT * FROM users WHERE height IS NOT NULL;


/*
1. Вибрати всіх юзерів, в кого парний id

2. Вибрати всіх юзерів, в кого зріст більше 1.5

3. Вибрати всіх юзерів жіногочого роду, які підписані на наші новини

*/

--1

SELECT * FROM users WHERE id % 2 = 0;

--2

SELECT * FROM users WHERE height >= 1.5;

--3

SELECT * FROM users WHERE gender = 'female' AND is_subscribe;


--------------------//////////////////-------------------------

SELECT id FROM users
WHERE id = 33333333; --empty table


SELECT * FROM users
WHERE first_name = 'William';

---

SELECT * FROM users
WHERE first_name = 'William' OR first_name = 'Ava' OR first_name = 'Test';   --v1

SELECT * FROM users
WHERE first_name IN ('William', 'Ava', 'Test', 'Daniel'); --v2


-----

SELECT * FROM users
WHERE id > 2500 AND id < 2560; --v1

SELECT * FROM users
WHERE id BETWEEN 2500 AND 2560; --v2

/* Знайдіть всіх юзерів, id яких знаходиться у проміжку 50 до 100 */

SELECT * FROM users
WHERE id BETWEEN 50 AND 100;

--------------

SELECT * FROM users
WHERE first_name LIKE 'K%';

/*   

% - будь-яку кількість будь-яких символів
_ - 1 будь-який символ
*/

SELECT * FROM users
WHERE first_name LIKE '_____';


/* Знайдіть користувачів, в імені яких 3 літери */

SELECT * FROM users
WHERE first_name LIKE '___';

SELECT * FROM users
WHERE first_name LIKE '%a';



----------------------

ALTER TABLE users
ADD COLUMN weight int CHECK (weight !=0 );

UPDATE users
SET weight = 60;


UPDATE users
SET weight = 70
WHERE id BETWEEN 2500 AND 3000;

UPDATE users
SET weight = 80
WHERE id = 5;


/*
Є таблиця співробітників (employees)
В кожного є стовбець salary (зп), work_hours (кількість відпрацьованих за місяць годин)

Всім співробітникам, які відпрацювали за місяць більше 150 годин, збільшити зп на 20%

*/

UPDATE employees
SET salary = salary * 1.2
WHERE work_hours > 150;

-------


INSERT INTO users
(first_name, last_name, email, gender, birthday, is_subscribe) VALUES 
('Usertest', 'Test', 'ertert@sdfsdfsd', 'male', '1990-12-12', false) RETURNING id;


UPDATE users
SET weight = 100
WHERE id = 2541 
RETURNING *;

DELETE FROM users
WHERE id = 2541
RETURNING *;


SELECT * FROM users
WHERE id = 2541;


----------------


SELECT id, first_name, last_name, birthday, extract('years' from birthday) FROM users
WHERE id = 5;



/*
1. Отримати всіх повнолітніх користувачів чоловічого роду.

2. Отримати всіх користувачів-жінок, ім'я яких починається на "А"

3. Отримати всіх користувачів, вік яких від 20 до 40 років

4. Отримати всіх користувачів, які народились у вересні
SELECT * FROM users
WHERE extract('month' from birthday) = 9;


5. Всім користувачам, які народились 1 листопада, змінити підписку на true

6. Видалити всіх користувачів, які старші за 65 років.

7. Всім користувачам чоловічого роду віком від 40 до 50 встановити вагу = 80;


*/



---1

SELECT * FROM users
WHERE gender = 'male' AND extract ('years' from age(birthday)) > 18; --v1

SELECT * FROM users
WHERE gender = 'male' AND extract ('years' from birthday) < 2004;

--- 2

SELECT * FROM users
WHERE gender = 'female' AND first_name LIKE 'A%';

---- 3

SELECT * FROM users
WHERE extract('years' from age(birthday)) BETWEEN 20 AND 40; ---v1 ----best

SELECT * FROM users
WHERE age(birthday) BETWEEN make_interval(20) AND make_interval(40); --v2


----4

SELECT * FROM users
WHERE extract('month' from birthday) = 9;


----5

UPDATE users
SET is_subscribe = true
WHERE extract('month' from birthday) = 12 AND extract('day' from birthday) = 1;


SELECT * FROM users
WHERE extract('month' from birthday) = 12 AND extract('day' from birthday) = 1;


----6

DELETE FROM users
WHERE extract ('years' from age(birthday)) > 65;


----- 7 

UPDATE users
SET weight = 80
WHERE extract('years' from age(birthday)) BETWEEN 40 AND 50;




--------------------------------------


SELECT *, extract('years' from age(birthday)) AS years FROM users
WHERE extract('years' from age(birthday)) BETWEEN 20 AND 40;


SELECT first_name AS "Ім'я", 
last_name AS "Прізвище", 
id AS "Особистий номер" 
FROM users;

SELECT * FROM chats_to_users AS ctu
WHERE ctu.user_id = 1;


-------//----Пагінація-------//-------------------


SELECT * FROM users
LIMIT 15
OFFSET 30;


------------------------------


SELECT id, concat(first_name, ' ', last_name) AS "full name", gender, email FROM users;


/*
Знайдіть всіх користувачів, повне ім'я (ім'я + прізвище) яких > 5 символів

*/


--v1
SELECT id, 
concat(first_name, ' ', last_name) AS "full name", 
gender, email 
FROM users
WHERE char_length(concat(first_name, ' ', last_name)) > 5;


--v2

SELECT *
FROM (SELECT id, 
concat(first_name, ' ', last_name) AS "full name", 
gender, email 
FROM users) AS "FN"
WHERE char_length("FN"."full name") > 5;





-------Агрегатні функції---------------


SELECT max(weight) FROM users;


SELECT gender, avg(weight) FROM users
GROUP BY gender;


------ Середня вага юзерів, що народилися після 2000 року

SELECT avg(weight)
FROM users
WHERE extract('years' from birthday) > 2000;


----- Середня вага чоловіків, яким 27 років

SELECT avg(weight)
FROM users
WHERE extract('years' from age(birthday)) = 27 AND gender = 'male';



/*
1. Середній вік всіх користувачів
*/

SELECT avg(extract('years' from age(birthday)))
FROM users;


/*
2. Мінімальний та максимальний вік користувачів
*/

SELECT min(extract('years' from age(birthday))), max(extract('years' from age(birthday)))
FROM users;


/*
3. Мінімальний та максимальний вік чоловіків і жінок окремо

*/

SELECT gender, min(extract('years' from age(birthday))), max(extract('years' from age(birthday)))
FROM users
GROUP BY gender;


/*
Порахувати кількість користувачів жіночого роду

*/

SELECT count(id)
FROM users
WHERE gender = 'female';


SELECT gender, count(id)
FROM users
GROUP BY gender;


/*
Кількість користувачів, що народились після 1998 року
*/
SELECT count(id)
FROM users
WHERE extract('years' from birthday) > 1998;


/*
Кількість користувачів віком від 20 до 40

*/

SELECT count(id)
FROM users
WHERE extract('years' from age(birthday)) BETWEEN 20 AND 40;


-------- Зіставлення (сопоставление) ---------


SELECT * FROM a, b
WHERE A.v = B.v;

SELECT A.v AS "id",
        A.t AS "price",
        B.v AS "phone_id"
FROM A,B
WHERE A.v = B.v;

SELECT * 
FROM A JOIN B 
ON A.v = B.v;



---- замовлення певного юзера
--- id = 5


SELECT * FROM users
JOIN orders
ON orders.customer_id = users.id
WHERE users.id = 5;



SELECT * FROM orders WHERE customer_id = 5;

SELECT u.*, o.id AS "order_id"
FROM users AS u 
JOIN orders AS o
ON o.customer_id = u.id
WHERE u.id = 5;


SELECT * 
FROM products 
JOIN orders_to_products
ON products.id = orders_to_products.product_id
WHERE products.brand = 'Samsung';


SELECT count(*) 
FROM products AS p
JOIN orders_to_products AS otp
ON p.id = otp.product_id
WHERE p.brand = 'Samsung';


SELECT p.brand, count(*) AS "quantity"
FROM products AS p
JOIN orders_to_products AS otp
ON p.id = otp.product_id
GROUP BY p.brand
ORDER BY "quantity" DESC
LIMIT 3;





--- юзери і кількість їхніх замовлень

SELECT count(*), u.* 
FROM users AS u 
JOIN orders AS o
ON u.id = o.customer_id
GROUP BY u.id;

----- Юзери, які нічого не замовляли


SELECT * 
FROM users AS u
LEFT JOIN orders AS O
ON u.id = o.customer_id
WHERE o.customer_id IS NULL;


SELECT * 
FROM users
WHERE id IN (
    SELECT id 
    FROM users 
    EXCEPT 
    SELECT customer_id 
    FROM orders);


--------------- JOINS -------------

--- INNER JOIN - внутрішнє співставлення
SELECT *
FROM users AS u 
INNER JOIN orders AS o
ON u.id = o.customer_id;



--- LEFT JOIN
SELECT * 
FROM users AS u
LEFT JOIN orders AS O
ON u.id = o.customer_id
ORDER BY u.id DESC;



-------
SELECT * 
FROM A 
LEFT JOIN b
ON a.v = b.v;

SELECT * 
FROM a
RIGHT JOIN b
ON a.v = b.v;


SELECT *
FROM A
FULL OUTER JOIN b
ON a.v = b.v;



---------


INSERT INTO products (
    brand,
    model,
    category,
    price,
    quantity
  )
VALUES (
   'LG',
   '10',
   'phones',
   200,
   2
  );



  --- Телефон, який ніколи не купували

SELECT * 
FROM products AS p
LEFT JOIN orders_to_products AS otp
ON p.id = otp.product_id
WHERE otp.product_id IS NULL;

DELETE FROM products
WHERE products.id IN (
    SELECT id FROM products AS p
    LEFT JOIN orders_to_products AS otp
    ON p.id = otp.product_id
    WHERE otp.product_id IS NULL
) RETURNING *;

/*

1. Повна вартість кожного замовлення.

2. Кількість позицій в кожному замовленні.

3. Знайти найпопулярніший товар.


*/


----3
SELECT p.brand, p.model, p.id, sum(otp.quantity) 
FROM products AS p
JOIN orders_to_products AS otp
ON p.id = otp.product_id
GROUP BY p.id
ORDER BY sum(otp.quantity) DESC
LIMIT 1;



---2
SELECT order_id, count(*) 
FROM orders_to_products AS otp
GROUP BY order_id;



---1
SELECT otp.order_id, sum(p.price * otp.quantity)
FROM orders_to_products AS otp
JOIN products AS p
ON otp.product_id = p.id
GROUP BY otp.order_id;



/*

1. Порахувати середній чек по всьому магазину.

2. Витягти всі замовлення вище середнього чека

3. Витягти всіх користувачів, в яких кількість замовлень вище середнього

4. Витягти користувачів та кількість телефонів, які вони замовляли (кількість замовлень * quantity)


*/

---1
SELECT otp.order_id, sum(p.price * otp.quantity) AS cost
FROM orders_to_products AS otp
JOIN products AS p
ON otp.product_id = p.id
GROUP BY otp.order_id;


SELECT avg(owc.cost)
FROM (
  SELECT otp.order_id, sum(p.price * otp.quantity) AS cost
  FROM orders_to_products AS otp
  JOIN products AS p
  ON otp.product_id = p.id
  GROUP BY otp.order_id
  ) AS owc;

SELECT owc.* 
FROM (
  SELECT otp.order_id, sum(p.price * otp.quantity) AS cost
  FROM orders_to_products AS otp
  JOIN products AS p
  ON otp.product_id = p.id
  GROUP BY otp.order_id
  ) AS owc
  WHERE owc.cost > (
    SELECT avg(owc.cost)
  FROM (
  SELECT otp.order_id, sum(p.price * otp.quantity) AS cost
  FROM orders_to_products AS otp
  JOIN products AS p
  ON otp.product_id = p.id
  GROUP BY otp.order_id
  );


  /*

WITH ..alias.. AS table
SELECT ....

  */

  WITH orders_with_cost AS (
  SELECT otp.order_id, sum(p.price * otp.quantity) AS cost
  FROM orders_to_products AS otp
  JOIN products AS p
  ON otp.product_id = p.id
  GROUP BY otp.order_id
)
SELECT orders_with_cost.*
FROM orders_with_cost
WHERE orders_with_cost.cost > (
    SELECT avg(orders_with_cost.cost)
    FROM orders_with_cost
  );



---- Витягти всіх користувачів, в яких кількість замовлень вище середнього


WITH orders_with_counts AS (
  SELECT customer_id, count(*) AS order_count
  FROM orders
  GROUP BY customer_id
)
SELECT * FROM orders_with_counts
JOIN users ON users.id = orders_with_counts.customer_id
WHERE orders_with_counts.order_count > (
    SELECT avg(orders_with_counts.order_count)
    FROM orders_with_counts
);


--- Витягти користувачів та кількість телефонів, які вони замовляли (кількість замовлень * quantity)

SELECT sum(quantity), u.first_name, u.last_name
FROM orders_to_products AS otp
JOIN orders ON orders.id = otp.order_id
JOIN users AS u ON u.id = orders.customer_id
GROUP BY u.id;
