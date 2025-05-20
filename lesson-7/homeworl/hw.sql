select min(price) from Products

select max(salary) from Employees

select count(*) from Customers

SELECT COUNT(DISTINCT Category) AS UniqueCategoryCount
FROM Products;

SELECT SUM(SaleAmount) AS TotalSales
FROM Sales
WHERE ProductID = 7;

select avg(age)as average_age from Employees

select DepartmentName, count(EmployeeID) as Number_employees from Employees
group by DepartmentName

select min(price), max(price) from Products
group by Category

select sum(saleamount) from sales
group by CustomerID

select count(EmployeeID) from Employees
group by DepartmentName
having count(EmployeeID)>5

SELECT  p.Category,
    SUM(s.SaleAmount) AS TotalSales,
    AVG(s.SaleAmount) AS AverageSales
FROM Sales s
JOIN 
    Products p ON s.ProductID = p.ProductID
GROUP BY p.Category;


SELECT COUNT(*) AS NumberOfEmployees
FROM Employees
WHERE DepartmentName = 'HR';

SELECT DepartmentName,
    MAX(Salary) AS HighestSalary,
    MIN(Salary) AS LowestSalary
FROM Employees
GROUP BY DepartmentName;

SELECT DepartmentName,
    AVG(Salary) AS AverageSalary
FROM 
    Employees
GROUP BY DepartmentName;

SELECT  DepartmentName,
    AVG(Salary) AS AverageSalary,
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY  DepartmentName;

SELECT Category,
    AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category
HAVING  AVG(Price) > 400;

SELECT YEAR(SaleDate) AS SaleYear,SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY YEAR(SaleDate)
ORDER BY SaleYear;

SELECT CustomerID,COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING  COUNT(*) >= 3;

SELECT DepartmentName,AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 60000;

select category,avg(Price) from Products
group by category
having avg(Price)>150

SELECT CustomerID,SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID
HAVING SUM(SaleAmount) > 1500;

SELECT DepartmentName,
    SUM(Salary) AS TotalSalary,
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 65000;

SELECT 
    CustomerID,
    SUM(CASE WHEN Freight > 50 THEN TotalDue ELSE 0 END) AS TotalAmount_Over50Freight,
    MIN(TotalDue) AS LeastPurchaseAmount
FROM 
    tsql2012.sales.orders
GROUP BY 
    CustomerID;

SELECT 
    YEAR(OrderDate) AS SaleYear,
    MONTH(OrderDate) AS SaleMonth,
    SUM(totalamount) AS TotalSales,
    COUNT(DISTINCT ProductID) AS UniqueProductsSold
FROM Orders
GROUP BY 
    YEAR(OrderDate),
    MONTH(OrderDate)
HAVING 
    COUNT(DISTINCT ProductID) >= 2
ORDER BY
    SaleYear,
    SaleMonth;

	SELECT
    YEAR(OrderDate) AS OrderYear,
    MIN(totalamount) AS MinOrderQuantity,
    MAX(totalamount) AS MaxOrderQuantity
FROM
    Orders
GROUP BY
    YEAR(OrderDate)
ORDER BY
    OrderYear;

