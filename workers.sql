/*

Створити нову таблицю workers:
- id,
- name,
- salary,
- birthday

1. Додайти робітника з ім'ям Олег, 90р.н., зп 300
2. Додайте робітницю Ярославу, зп 1200
3. Додайте двох нових робітників одним запитом - Сашу 85р.н., зп 1000, і Машу 95р.н., зп 900

4. Встановити Олегу зп у 500.
5. Робітнику з id = 4 встановити рік народження 87
6. Всім, в кого зп > 500, врізати до 700.
7. Робітникам з 2 по 5 встановити рік народження 99
8. Змінити Сашу на Женю і збільшити зп до 900.

9. Вибрати всіх робітників, чия зп > 400.
10. Вибрати робітника з id = 4
11. Дізнатися зп та вік Жені.
12. Знайти робітника з ім'ям Петя.
13. Вибрати робітників у віці 27 років або з зп > 800
14. Вибрати робітників у віці від 25 до 28 років (вкл)
15. Вибрати всіх робітників, що народились у вересні

16. Видалити робітника з id = 4
17. Видалити Олега
18. Видалити всіх робітників старше 30 років.


*/

--1--2--3

INSERT INTO workers
(name, salary, birthday) VALUES 
('Oleg', 300, '1990-10-12') RETURNING id;

INSERT INTO workers
( name, salary, birthday) VALUES 
('Sasha', 1000, '1985-03-09'),
('Masha', 900, '1995-10-16');

--4--5--6--7--8

UPDATE workers
SET salary = 500
WHERE name = 'Oleg';

UPDATE workers
SET birthday = '1987-09-16'
WHERE id = 4;

UPDATE workers
SET salary = 700
WHERE salary > 500;

UPDATE workers
SET birthday = '1999-10-12'
WHERE id BETWEEN 2 AND 5;

--another

UPDATE workers 
SET birthday = make_date(1999, 
extract('month' from birthday)::integer,
extract('day' from birthday)::integer) 
WHERE id BETWEEN 2 AND 5;

UPDATE workers
SET salary = 900, name = 'Jenna'
WHERE name = 'Jenya'; 


--9--10--11--12--13--14--15


SELECT * FROM workers
WHERE salary > 400;

SELECT * FROM workers
WHERE id = 4;

SELECT * FROM workers
WHERE name='Jenya';

SELECT * FROM workers
WHERE name='Petya';

SELECT * FROM workers
WHERE extract('years' from age(birthday))=27 OR salary>800;

SELECT * FROM workers
WHERE extract('years' from age(birthday)) BETWEEN 25 AND 28;

SELECT * FROM workers
WHERE extract('month' from birthday) = 9;

--16--17--18
DELETE FROM workers
WHERE id = 4;

DELETE FROM workers
WHERE name='Oleg';

DELETE FROM workers
WHERE extract ('years' from age(birthday)) > 30;

