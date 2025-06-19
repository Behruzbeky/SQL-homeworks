select* from employees
where salary=(select min(salary) from employees);
-----------------------------------------------------------
select* from products
where price>(select avg(price) from products);
--------------------------------------------------------------
select e.id, e.name,d.department_name from employees e
right join departments d on d.id=e .department_id
where department_name = 'sales';
------------------------------------------------------------------
select c.customer_id,c.name,o.order_id from customers c
left join orders o on c.customer_id=o.customer_id
where order_id is null;
---------------------------------------------------------------------
select* from products p
where price=(select max(price) from products
where category_id=p.category_id);
---------------------------------------------------------------------------------
WITH dept_avgs AS (
    SELECT
        department_id,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
),

top_depts AS (
    SELECT department_id
    FROM dept_avgs
    WHERE avg_salary = (SELECT MAX(avg_salary) FROM dept_avgs)
)
SELECT
    e.id,
    e.name,
    e.salary,
    d.department_name
FROM employees   e
JOIN top_depts   t ON e.department_id = t.department_id
JOIN departments d ON d.id = e.department_id
ORDER BY d.department_name, e.id;
-----------------------------------------------------------------
select* from employees e
where e.salary>( select avg(salary) from employees 
where department_id=e.department_id)
---------------------------------------------------------------------
with course_max as(
select course_id, max(grade) as Max_Grade from grades
group by course_id)
SELECT
    g.course_id,
    s.student_id,
    s.name,
    g.grade
FROM grades     g
JOIN course_max cm ON cm.course_id = g.course_id
                  AND cm.max_grade = g.grade
JOIN students   s  ON s.student_id = g.student_id
ORDER BY g.course_id, s.student_id;
-----------------------------------------------------------------------
WITH ranked AS (
    SELECT
        p.*,
        DENSE_RANK() OVER (PARTITION BY category_id
                           ORDER BY price DESC) AS rnk
    FROM products p
)
SELECT
    id,
    product_name,
    price,
    category_id
FROM ranked
WHERE rnk = 3
ORDER BY category_id, id;
-------------------------------------------------------------------------
SELECT *
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary) FROM employees
)
AND e.salary < (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = e.department_id
);


