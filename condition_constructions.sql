--змінюємо таблицю ордерсів

ALTER TABLE orders
ADD COLUMN status boolean;

UPDATE orders
SET status = true
WHERE id % 2 = 0;

UPDATE orders
SET status = false
WHERE id % 2 = 1;

SELECT * FROM orders
ORDER BY id;

SELECT id, created_at,customer_id, status AS order_status 
FROM orders; --alias

/* Вивести всі замовлення, там де статус "true" - написати "виконано", де false - написати "нове" */

-----1 syntax-----CASE
    WHEN condition1 = true
    THEN result1
    WHEN condition2 = true
    THEN result2
    ....
    ELSE 
    result3
END;

---

SELECT id, created_at, customer_id, (
        CASE
            WHEN status = TRUE
            THEN 'виконано'
            WHEN status = FALSE
            THEN 'нове замовлення'
            ELSE 'інший статус'
        END
) AS status
FROM orders
ORDER BY id;



------2 syntax ----

CASE condition WHEN value1 THEN result1
                WHEN value2 THEN result2
                .........
        ELSE default_result
END;

------

/* Витягти місяць народження юзера і на його основі вивести, народився юзер восени, навесні, влітку чи взимку*/


SELECT *, (
    CASE extract('month' from birthday)
    WHEN 1 THEN 'winter'
    WHEN 2 THEN 'winter'
    WHEN 3 THEN 'spring'
    WHEN 4 THEN 'spring'
    WHEN 5 THEN 'spring'
    WHEN 6 THEN 'summer'
    WHEN 7 THEN 'summer'
    WHEN 8 THEN 'summer'
    WHEN 9 THEN 'fall'
    WHEN 10 THEN 'fall'
    WHEN 11 THEN 'fall'
    WHEN 12 THEN 'winter'
    ELSE 'unknown'
END
)
FROM users;

----1 Вивести юзерів, в яких в полі "стать" буде українською написано "жінка" або "чоловік", або "інше"

SELECT *, (
    CASE gender 
    WHEN 'female' then 'жінка'
    WHEN 'male' then 'чоловік'
    ELSE 'інше'
    END
) AS "стать"
FROM users;



-----2 Вивести на основі кількості років користувача, що він повнолітній або неповнолітній
<21 - неповнолітній
>=21 - повнолітній

SELECT *, (
    CASE 
    WHEN (extract(year from age(birthday))) < 21
    THEN 'неповнолітній'
    WHEN (extract(year from age(birthday))) >= 21
    THEN 'повнолітній'
    ELSE 'невідомо'
    END
)
FROM users
ORDER BY extract(year from age(birthday));

/*
Вивести всі телефони (з таблиці products), 
якщо ціна більше 6тис - флагман
якщо ціна від 2 до 6 - середній клас
якщо ціна <2 тис - бюджетний

*/

SELECT *, (
    CASE
    WHEN price < 2000
    THEN 'бюджетний'
    WHEN price BETWEEN 2000 AND 6000 THEN 'Середній клас'
    WHEN price >= 6000 THEN 'флагман'
    ELSE 'невідомо'
    END
    ) AS "категорії"
FROM products;


/*
Вивести користувачів з інформацією про їхні замовлення у вигляді:
- якщо більше >=3 - постійний клієнт
- якщо від 1 до 2 - активний клієнт
- якщо 0 замовлень - новий клієнт

*/

SELECT u.id,u.email, (
    CASE WHEN count(o.id) >= 3
    THEN 'постійний клієнт'
    WHEN count (o.id) BETWEEN 1 AND 2 
    THEN 'активний клієнт'
    WHEN count(o.id) = 0 
    THEN 'новий клієнт'
    ELSE 'невідомо'
    END
    )
FROM users AS u
JOIN orders AS o
ON u.id = o.customer_id
GROUP BY  u.id,u.email
ORDER BY count(o.id);


INSERT INTO users (
    first_name,
    last_name,
    email,
    gender,
    is_subscribe,
    birthday
) VALUES
('Big', 'Tox', 'totomail@com', 'male', true, '2000-08-09');


----COALESCE

SELECT COALESCE(NULL, 12, 24) --- 12
COALESCE(NULL, NULL, NULL) --- NULL

/* Опис телефонів - якщо опису немає, вивести "Про цей товар нічого не відомо"  */

---додамо опис до декого
UPDATE products
SET description = 'Супер телефон з довгим описом'
WHERE id BETWEEN 324 AND 350;

SELECT id, brand,  model, price, COALESCE(description, 'Про цей товар нічого не відомо')
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


/*тут певна солянка із всієї таблиці*/
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

SELECT u.id,u.email, sum(owp.order_sum)
 FROM users AS u
JOIN orders_with_price AS owp
ON u.id = owp.customer_id
GROUP BY u.id;

--- Вивести топ-10 покупців, які залишили найбільше грошей в нашому магазині


SELECT u.id,u.email, u.first_name, u.last_name, sum(owp.order_sum) AS sum_amount
 FROM users AS u
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
