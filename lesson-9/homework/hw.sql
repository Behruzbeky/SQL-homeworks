SELECT Products.ProductName, Suppliers.SupplierName
FROM Products
CROSS JOIN Suppliers;

select Departments.departmentname , Employees.name
from Departments
cross join Employees

SELECT Suppliers.SupplierName, Products.ProductName
FROM Products
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID;

SELECT Custumers.Name, Orders.OrderID
FROM Orders
INNER JOIN Custumers ON Orders.CustomerID = Custumers.ID;

SELECT Students.Name, Courses.CourseName
FROM Students
CROSS JOIN Courses;

SELECT Products.ProductName, Orders.OrderID
FROM Orders
INNER JOIN Products ON Orders.ProductID = Products.ProductID;

SELECT Students.Name, Enrollments.CourseID
FROM Students
INNER JOIN Enrollments ON Students.StudentID = Enrollments.StudentID;

SELECT Orders.OrderID, Payments.PaymentID, Payments.PaymentDate, Payments.Amount
FROM Orders
INNER JOIN Payments ON Orders.OrderID = Payments.OrderID;

SELECT Orders.OrderID, Products.ProductName, Products.Price
FROM Orders
INNER JOIN Products ON Orders.ProductID = Products.ProductID
WHERE Products.Price > 100;

SELECT Employees.Name, Departments.DepartmentName, Employees.DepartmentID AS EmployeeDeptID, Departments.DepartmentID AS DeptID
FROM Employees
CROSS JOIN Departments
WHERE Employees.DepartmentID <> Departments.DepartmentID;

SELECT Orders.OrderID, Products.ProductName, Orders.Quantity AS OrderedQuantity, Products.StockQuantity
FROM Orders
INNER JOIN Products ON Orders.ProductID = Products.ProductID
WHERE Orders.Quantity > Products.StockQuantity;

SELECT Custumers.Name, Sales.ProductID, Sales.SaleAmount
FROM Sales
INNER JOIN Custumers ON Sales.CustomerID = Custumers.ID
WHERE Sales.SaleAmount >= 500;

SELECT Students.Name, Courses.CourseName
FROM Enrollments
INNER JOIN Students ON Enrollments.StudentID = Students.StudentID
INNER JOIN Courses ON Enrollments.CourseID = Courses.CourseID;

SELECT Products.ProductName, Suppliers.SupplierName
FROM Products
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE Suppliers.SupplierName LIKE '%Tech%';

SELECT Orders.OrderID, Orders.TotalAmount, Payments.Amount
FROM Orders
INNER JOIN Payments ON Orders.OrderID = Payments.OrderID
WHERE Payments.Amount < Orders.TotalAmount;

SELECT Employees.Name, Departments.DepartmentName
FROM Employees
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID;

SELECT Products.ProductName, Categories.CategoryName
FROM Products
INNER JOIN Categories ON Products.Category = Categories.CategoryID
WHERE Categories.CategoryName IN ('Electronics', 'Furniture');

SELECT Sales.SaleID, Sales.ProductID, Sales.SaleAmount, Custumers.Name, Custumers.City
FROM Sales
INNER JOIN Custumers ON Sales.CustomerID = Custumers.ID
WHERE Custumers.City = 'USA';

SELECT Orders.OrderID, Custumers.Name, Orders.TotalAmount
FROM Orders
INNER JOIN Custumers ON Orders.CustomerID = Custumers.ID
WHERE Custumers.City = 'Germany'
  AND Orders.TotalAmount > 100;

SELECT 
  e1.Name AS Employee1, 
  e1.DepartmentID AS Dept1,
  e2.Name AS Employee2, 
  e2.DepartmentID AS Dept2
FROM Employees e1
JOIN Employees e2 ON e1.EmployeeID <> e2.EmployeeID
WHERE e1.DepartmentID <> e2.DepartmentID;

SELECT 
  Payments.PaymentID,
  Payments.OrderID,
  Payments.Amount,
  Orders.Quantity,
  Products.ProductName,
  Products.Price,
  (Orders.Quantity * Products.Price) AS ExpectedAmount
FROM Payments
INNER JOIN Orders ON Payments.OrderID = Orders.OrderID
INNER JOIN Products ON Orders.ProductID = Products.ProductID
WHERE Payments.Amount <> (Orders.Quantity * Products.Price);

SELECT Students.Name
FROM Students
LEFT JOIN Enrollments ON Students.studentID = Enrollments.StudentID
WHERE Enrollments.CourseID IS NULL;

SELECT DISTINCT m.Name AS ManagerName, m.Salary AS ManagerSalary,
                e.Name AS EmployeeName, e.Salary AS EmployeeSalary
FROM Employees e
JOIN Employees m ON e.ManagerID = m.EmployeeID
WHERE m.Salary <= e.Salary;

SELECT DISTINCT Custumers.Name
FROM Orders
LEFT JOIN Payments ON Orders.OrderID = Payments.OrderID
JOIN Custumers ON Orders.CustomerID = Custumers.ID
WHERE Payments.OrderID IS NULL;

