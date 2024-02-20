-- Напишите запросы, которые выводят следующую информацию:
-- 1. заказы, отправленные в города, заканчивающиеся на 'burg'. Вывести без повторений две колонки (город, страна) (см. таблица orders, колонки ship_city, ship_country)
SELECT
    ship_city,
    ship_country
FROM
    orders
WHERE
    LOWER(ship_city) LIKE '%burg'
GROUP BY
    ship_city, ship_country;

-- 2. из таблицы orders идентификатор заказа, идентификатор заказчика, вес и страну отгрузки. Заказ отгружен в страны, начинающиеся на 'P'. Результат отсортирован по весу (по убыванию). Вывести первые 10 записей.
SELECT
    order_id,
    customer_id,
    MAX(freight) AS freight,
    ship_country
FROM
    orders
WHERE
    UPPER(ship_country) LIKE 'P%'
GROUP BY
    order_id, customer_id, ship_country
ORDER BY
    freight DESC
LIMIT 10;

-- 3. имя, фамилию и телефон сотрудников, у которых в данных отсутствует регион (см таблицу employees)
SELECT
    first_name,
    last_name,
    home_phone
FROM
    employees
WHERE
    region IS NULL OR TRIM(notes) = ''

-- 4. количество поставщиков (suppliers) в каждой из стран. Результат отсортировать по убыванию количества поставщиков в стране
SELECT
    country,
    COUNT(supplier_id)
FROM
    suppliers
GROUP BY
    country
ORDER BY
    COUNT(supplier_id) DESC;

-- 5. суммарный вес заказов (в которых известен регион) по странам, но вывести только те результаты, где суммарный вес на страну больше 2750. Отсортировать по убыванию суммарного веса (см таблицу orders, колонки ship_region, ship_country, freight)
SELECT
    ship_country,
    SUM(freight)
FROM
    orders
WHERE
    ship_region IS NOT NULL
GROUP BY
    ship_country
HAVING
    SUM(freight) > 2750
ORDER BY
    SUM(freight) DESC;

-- 6. страны, в которых зарегистрированы и заказчики (customers) и поставщики (suppliers) и работники (employees).
SELECT DISTINCT country
FROM (
    SELECT country FROM customers
    WHERE country IS NOT NULL

    INTERSECT

    SELECT country FROM suppliers
    WHERE country IS NOT NULL

    INTERSECT

    SELECT country FROM employees
    WHERE country IS NOT NULL
) AS combined_data;

-- 7. страны, в которых зарегистрированы и заказчики (customers) и поставщики (suppliers), но не зарегистрированы работники (employees).
SELECT DISTINCT country
FROM (
    SELECT country FROM customers
    WHERE country IS NOT NULL

    INTERSECT

    SELECT country FROM suppliers
    WHERE country IS NOT NULL

    EXCEPT

    SELECT country FROM employees
    WHERE country IS NOT NULL
) AS combined_data;
