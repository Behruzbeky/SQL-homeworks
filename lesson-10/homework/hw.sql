

SELECT e.Name,e.Salary,d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 50000;

select c.FirstName, c.LastName ,o.orderdate from Customers c
join Orders o on c.CustomerID=o.CustomerID
where year(o.orderdate) =2023

select e.Name, d.DepartmentName from Employees e
left join Departments d on e.DepartmentID=d.DepartmentID

select s.SupplierName,p.ProductName from Products p
right join Suppliers s on p.SupplierID=s.SupplierID

select o.OrderID, o.OrderDate, p.PaymentDate, p.Amount from Orders o
full outer join Payments p on o.OrderID=p.OrderID

SELECT 
    e.Name,
    m.Name AS ManagerName
FROM 
    Employees e
LEFT JOIN 
    Employees m ON e.ManagerID = m.EmployeeID;

SELECT 
    s.Name,
    c.CourseName
FROM 
    Enrollments e
JOIN 
    Students s ON e.StudentID = s.StudentID
JOIN 
    Courses c ON e.CourseID = c.CourseID
WHERE 
    c.CourseName = 'Math 101';

select c.FirstName, c.LastName, o.Quantity from Customers c
join Orders o on c.CustomerID=o.CustomerID
where o.Quantity>3

SELECT 
    e.Name,
    d.DepartmentName
FROM 
    Employees e
JOIN 
    Departments d ON e.DepartmentID = d.DepartmentID
WHERE 
    d.DepartmentName = 'Human Resources';

	select* from Employees
select* from Departments

SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM 
    Departments d
JOIN 
    Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY 
    d.DepartmentName
HAVING 
    COUNT(e.EmployeeID) > 5;

	SELECT 
    p.ProductID,
    p.ProductName
FROM 
    Products p
LEFT JOIN 
    Sales s ON p.ProductID = s.ProductID
WHERE 
    s.ProductID IS NULL;

SELECT 
    c.FirstName,
    c.LastName,
    COUNT(o.OrderID) AS TotalOrders
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
GROUP BY 
    c.FirstName,
    c.LastName;

SELECT 
    e.Name,
    d.DepartmentName
FROM 
    Employees e
INNER JOIN 
    Departments d ON e.DepartmentID = d.DepartmentID;

SELECT 
    e1.Name AS Employee1,
    e2.Name AS Employee2,
    e1.ManagerID
FROM 
    Employees e1
JOIN 
    Employees e2 ON e1.ManagerID = e2.ManagerID
WHERE 
    e1.EmployeeID < e2.EmployeeID
    AND e1.ManagerID IS NOT NULL;

SELECT 
    o.OrderID,
    o.OrderDate,
    c.FirstName,
    c.LastName
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
WHERE 
    YEAR(o.OrderDate) = 2022;

SELECT 
    e.Name,
    e.Salary,
    d.DepartmentName
FROM 
    Employees e
JOIN 
    Departments d ON e.DepartmentID = d.DepartmentID
WHERE 
    d.DepartmentName = 'Sales'
    AND e.Salary > 60000;

SELECT 
    p.ProductID,
    p.ProductName
FROM 
    Products p
LEFT JOIN 
    Orders o ON p.ProductID = o.ProductID
WHERE 
    o.ProductID IS NULL;

SELECT 
    e.Name,
    e.Salary
FROM 
    Employees e
WHERE 
    e.Salary > (
        SELECT 
            AVG(e2.Salary)
        FROM 
            Employees e2
        WHERE 
            e2.DepartmentID = e.DepartmentID
    );

SELECT 
    o.OrderID,
    o.OrderDate
FROM 
    Orders o
LEFT JOIN 
    Payments p ON o.OrderID = p.OrderID
WHERE year(o.OrderDate) < 2020
    AND p.OrderID IS NULL;
	select* from Products
SELECT 
    p.ProductID,
    p.ProductName
FROM 
    Products p
LEFT JOIN 
    Categories c ON p.Category = c.CategoryID
WHERE 
    c.CategoryID IS NULL;

SELECT 
    e1.Name AS Employee1,
    e2.Name AS Employee2,
    e1.ManagerID,
    e1.Salary
FROM 
    Employees e1
JOIN 
    Employees e2 ON e1.ManagerID = e2.ManagerID
WHERE 
    e1.EmployeeID < e2.EmployeeID
    AND e1.Salary > 60000
    AND e2.Salary > 60000
    AND e1.ManagerID IS NOT NULL;

SELECT 
    e.Name,
    d.DepartmentName
FROM 
    Employees e
JOIN 
    Departments d ON e.DepartmentID = d.DepartmentID
WHERE 
    d.DepartmentName LIKE 'M%';

SELECT 
    s.SaleID,
    p.ProductName,
    s.SaleAmount
FROM 
    Sales s
JOIN 
    Products p ON s.ProductID = p.ProductID
WHERE 
    s.SaleAmount > 500;

SELECT 
    s.StudentID,
    s.Name
FROM 
    Students s
WHERE NOT EXISTS (
    SELECT 1
    FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE e.StudentID = s.StudentID
      AND c.CourseName = 'Math 101'
);


SELECT 
    o.OrderID,
    o.OrderDate,
    p.PaymentID
FROM 
    Orders o
LEFT JOIN 
    Payments p ON o.OrderID = p.OrderID
WHERE 
    p.PaymentID IS NULL;

SELECT 
    p.ProductID,
    p.ProductName,
    c.CategoryName
FROM 
    Products p
JOIN 
    Categories c ON p.Category = c.CategoryID
WHERE 
    c.CategoryName IN ('Electronics', 'Furniture');
