-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника, работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания United Package (company_name в табл shippers)
SELECT
    c.company_name AS customer_company,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
JOIN
    employees e ON o.employee_id = e.employee_id
JOIN
    shippers s ON o.ship_via = s.shipper_id
WHERE
    c.city = 'London'
    AND e.city = 'London'
    AND s.company_name = 'United Package';
-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
SELECT products.product_name, products.units_in_stock, suppliers.contact_name, suppliers.phone
FROM products
JOIN suppliers ON products.supplier_id = suppliers.supplier_id
JOIN categories ON products.category_id = categories.category_id
WHERE products.discontinued = 0 AND products.units_in_stock < 25
      AND (categories.category_name = 'Dairy Products' OR categories.category_name = 'Condiments')
ORDER BY products.units_in_stock ASC;
-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
SELECT customers.company_name
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
WHERE orders.order_id IS NULL;
-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.
SELECT product_name
FROM products
WHERE product_id IN (SELECT product_id FROM order_details WHERE quantity = 10)
GROUP BY product_name;