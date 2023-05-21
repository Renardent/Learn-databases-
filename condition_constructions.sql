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
