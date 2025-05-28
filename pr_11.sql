--Упражнение 1
explain select * from emails;
explain select * from emails limit 5;
explain select * from emails where clicked_date between '2011-01-01' and '2011-02-01';


--Практика 1
-- Команда, чтобы вернуть план запроса для выбора всех доступных записей в таблице клиентов
explain select * from customers;
--Получили начальные затраты 0.00, сообщаемую стоимость 1540.00, общую стоимость выполнения запроса 50000,
-- общее количество строк, доступных для возврата 140
--Ограничим количество возвращаемых записей до 15
explain select * from customers limit 15;
--Получили начальные затраты 0.00, сообщаемую стоимость 0.46, общую стоимость выполнения запроса 15, 
--общее количество строк, доступных для возврата 140
--Создадим план запроса, выбрав все строки, где клиенты живут в пределах широты 30
--и 40 градусов.
explain select * from customers where latitude > '30' and latitude < '40';
--Получили начальные затраты 0.00, сообщаемую стоимость 1790.00, общую стоимость выполнения запроса 26183, 
--общее количество строк, доступных для возврата 140

--Упражнение 2
--1.Используйте команду EXPLAIN, чтобы определить стоимость запроса и количество строк, 
--возвращаемых при выборе всех записей со значением состояния FO:
EXPLAIN SELECT * FROM customers WHERE state='FO';
--2. Определить, сколько существует уникальных значений состояния, снова используя команду EXPLAIN:
EXPLAIN SELECT DISTINCT state FROM customers;
--3. Создайте индекс с именем ix_state, используя столбец состояния клиентов:
CREATE INDEX ix_state ON customers(state);
--4. Повторить оператор EXPLAIN с шага 2:
EXPLAIN SELECT * FROM customers WHERE state='FO';
--5. Используйте команду EXPLAIN, чтобы вернуть план запроса для поиска всех записей мужчин в базе данных:
EXPLAIN SELECT * FROM customers WHERE gender='M';
--6. Создать индекс с именем ix_gender, используя столбец пола клиентов:
CREATE INDEX ix_gender ON customers(gender);
--7. Повторить оператор EXPLAIN с шага 5:
EXPLAIN SELECT * FROM customers WHERE gender='M';
--8. Использовать EXPLAIN, чтобы вернуть план запроса, широта меньше 38 градусов и больше 30 градусов:
EXPLAIN SELECT * FROM customers WHERE (latitude < 38) AND (latitude > 30);
--9. Создать индекс с именем ix_latitude, используя столбец широты клиентов:
CREATE INDEX ix_latitude ON customers(latitude);
--10. Повторить оператор EXPLAIN с шага 8:
EXPLAIN SELECT * FROM customers WHERE (latitude < 38) AND (latitude > 30);
--11. Используйте EXPLAIN ANALYZE, чтобы запросить план содержимого таблицы клиентов со значениями широты от 30 до 38:
EXPLAIN ANALYZE SELECT * FROM customers WHERE (latitude < 38) AND (latitude > 30);
--12. Создать еще один индекс, где широта находится между 30 и 38 в таблице клиентов:
CREATE INDEX ix_latitude_less ON customers(latitude)
WHERE (latitude < 38) and (latitude > 30);
--13. Повторить оператор EXPLAIN ANALYZE с шага 11:
EXPLAIN ANALYZE SELECT * FROM customers
WHERE (latitude < 38) AND (latitude > 30);


--Практика 2
--Используем команды EXPLAIN и ANALYZE, чтобы
--профилировать план запроса для поиска всех записей с IPадресом 18.131.58.65.
explain analyze select * from customers where ip_address='18.131.58.65';
--Получаем планирование запроса = 0.208 ms, выполнение запроса = 8.797 ms, начальные затраты 0.00, 
--сообщаемую стоимость 1665.00, общую стоимость выполнения запроса 1, общее количество строк, доступных для возврата 140
--Создаем общий индекс на основе столбца IP-адреса
CREATE INDEX ix_ipaddress ON customers(ip_address);
--Повторяем запрос 1 шага
explain analyze select * from customers;
--Получаем планирование запроса = 2.008 ms, выполнение запроса = 0.158 ms, начальные затраты 0.29, 
--сообщаемую стоимость 8.31, общую стоимость выполнения запроса 1, общее количество строк, доступных для возврата 140
--Создаем более подробный индекс
create index ix_ipaddress_1 on customers (ip_address)
where ip_address='18.131.58.65';
--Повторяем запрос 1 шага
explain analyze select * from customers where ip_address='18.131.58.65';
--Получаем планирование запроса = 5.791 ms, выполнение запроса = 0.091 ms, начальные затраты 0.12, 
--сообщаемую стоимость 8.14, общую стоимость выполнения запроса 1, общее количество строк, доступных для возврата 140
--Используем команды EXPLAIN и ANALYZE для
--профилирования плана запроса для поиска всех записей с
--суффиксом Jr.
explain analyze select * from customers where suffix like '%Jr%';
--Получаем планирование запроса = 0.753 ms, выполнение запроса = 9.931 ms, начальные затраты 0.00, 
--сообщаемую стоимость 1665.00, общую стоимость выполнения запроса 80, общее количество строк, доступных для возврата 140
--Создаем общий индекс
create index ix_suffix on customers (suffix) ;
--Повторно запускаем запрос шага 6
explain analyze select * from customers where suffix like '%Jr%';
--Получаем планирование запроса = 10.739 ms, выполнение запроса = 6.001 ms, начальные затраты 0.00, 
--сообщаемую стоимость 1665.00, общую стоимость выполнения запроса 80, общее количество строк, доступных для возврата 140


--Упражнение 3
--1. Удаляем все существующие индексы
DROP INDEX ix_gender;
--2.  Используем EXPLAIN и ANALYZE для таблицы customer, где указан мужской пол, 
--но без использования хэш-индекса.
EXPLAIN ANALYZE SELECT * FROM customers
WHERE gender='M';
--3. Создайте B-tree индекс для атрибута gender и повторите запрос, 
--чтобы определить производительность, используя индекс по умолчанию:
CREATE INDEX ix_gender ON customers USING btree(gender);
EXPLAIN ANALYZE SELECT * FROM customers
WHERE gender='M';
--4. Удаляем индекс
DROP INDEX ix_gender;
--5. Создаем хеш-индекс для атрибута gender:
CREATE INDEX ix_gender ON customers USING HASH(gender);
--6. Повторяем запрос с шага 3, чтобы увидеть время выполнения:
EXPLAIN ANALYZE SELECT *
FROM customers WHERE gender='M';
--7. Удаляем индекс B-tree ix_state и создайте хэшсканирование:
DROP INDEX ix_state;
CREATE INDEX ix_state ON customers USING HASH(state);
--8. Используем EXPLAIN и ANALYZE для профилирования производительности сканирования
--хэша:
EXPLAIN ANALYZE SELECT * FROM customers WHERE state='FO';


--Практика 3
--Используйте команды EXPLAIN и ANALYZE, чтобы определить время и стоимость
--планирования, а также время и стоимость выполнения для выбора всех строк, где
--тема электронной почты — «Шокирующая экономия на праздничных покупках
--электрических самокатов» в первом запросе и «Черная пятница». Зеленые
--автомобили. во втором запросе.
explain analyze select * from emails 
where email_subject like 'Shocking Holiday Saving On Electric Scooters';
--Получаем планирование запроса = 0.186 ms, выполнение запроса = 66.880 ms, начальные затраты 1000.00, 
--сообщаемую стоимость 8650.01, общую стоимость выполнения запроса 1, общее количество строк, доступных для возврата 79
explain analyze select * from emails
where email_subject like 'Black Friday. Green Cars.';
--Получаем планирование запроса = 0.106 ms, выполнение запроса = 47.649 ms, начальные затраты 0.00, 
--сообщаемую стоимость 10698.98, общую стоимость выполнения запроса 43098, общее количество строк, доступных для возврата 79
--Создаем хеш-сканирование в столбце email_subject.
CREATE INDEX ix_emailsubject ON emails USING HASH(email_subject);
--Повторяем 1 шаг
explain analyze select * from emails 
where email_subject like 'Shocking Holiday Saving On Electric Scooters';
--Получаем планирование запроса = 1.458 ms, выполнение запроса = 0.040 ms, начальные затраты 0.00, 
--сообщаемую стоимость 8.02, общую стоимость выполнения запроса 1, общее количество строк, доступных для возврата 79
explain analyze select * from emails
where email_subject like 'Black Friday. Green Cars.';
--Получаем планирование запроса = 0.143 ms, выполнение запроса = 16.691 ms, начальные затраты 0.00, 
--сообщаемую стоимость 1379.24, общую стоимость выполнения запроса 43098, общее количество строк, доступных для возврата 79
--Создаем хэш-сканирование столбца customer_id
create index ix_customerid on customers using HASH(customer_id);
--Используем EXPLAIN и ANALYZE, чтобы оценить, сколько времени потребуется,
--чтобы выбрать все строки со значением customer_id больше 100.
explain analyze select * from customers
where customer_id > 100;
--Получаем планирование запроса = 1.860 ms, выполнение запроса = 3.133 ms, начальные затраты 0.00, 
--сообщаемую стоимость 1665.00, общую стоимость выполнения запроса 49899, общее количество строк, доступных для возврата 140

