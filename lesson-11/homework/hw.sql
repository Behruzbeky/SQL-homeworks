
select c.FirstName, c.LastName, o.OrderID, o.OrderDate from Customers c
join Orders o on o.CustomerID=c.CustomerID
where year(o.OrderDate)>2022

select e.Name, d.DepartmentName from Employees e
join Departments d on e.DepartmentID=d.DepartmentID 
where d.DepartmentName in ('Sales', 'Marketing')

select d.DepartmentName, max(e.Salary) from Employees e
join Departments d on d.DepartmentID=e.DepartmentID
group by d.DepartmentName

select c.FirstName, c.LastName, o.OrderID, o.OrderDate  from Customers c
join Orders o on c.CustomerID=o.CustomerID
where c.Country = 'USA' and year(o.OrderDate) = 2023

select c.FirstName, c.LastName, o.Quantity as TotalOrders from Customers c
join Orders o on c.CustomerId=o.CustomerID

select p.ProductName, s.SupplierName from Products p
join Suppliers s on p.SupplierID=s.SupplierID
where SupplierName in ('Gadget Supplies','Clothing Mart') 

SELECT C.FirstName, C.LastName, MAX(o.OrderDate) AS MostRecentOrderDate
FROM Customers  as C
LEFT JOIN Orders as o ON C.CustomerID = O.CustomerID
group by c.FirstName,c.LastName

select c.FirstName,c.LastName,o.TotalAmount from Customers c
join Orders o on o.CustomerID=c.CustomerID
where o.TotalAmount>500

select p.ProductName, s.SaleDate,s.SaleAmount from Sales s
join Products p on p.ProductID=s.ProductID
where year(s.SaleDate)=2022 or s.SaleAmount>400

select  p.ProductName, s.SaleAmount as TotalSaleAmount from Products p
join sales s on s.ProductID=p.ProductID

select e.Name, d.DepartmentName, e.Salary from Employees e
join Departments d on d.DepartmentID=e.DepartmentID 
where d.DepartmentName ='Human Resources' and e.Salary>60000

select p.ProductName, s.SaleDate, p.StockQuantity from Products p
join Sales s on s.ProductID=p.ProductID
where year(s.SaleDate)=2023 and p.StockQuantity>100

select  e.Name,d.DepartmentName, e.HireDate from Employees e
join Departments d on d.DepartmentID=e.DepartmentID
where year(e.HireDate)>2020

SELECT C.FirstName,c.LastName, O.OrderID, C.Address, O.OrderDate
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE C.Country = 'USA'
  AND C.Address LIKE '[0-9][0-9][0-9][0-9]%';

  select p.ProductName, p.Category, s.SaleAmount from Products p
  join Sales s on s.ProductID=p.ProductID
  where p.Category= 1 or s.SaleAmount>350

  SELECT C.CategoryName, COUNT(P.ProductID) AS ProductCount
FROM Categories C
LEFT JOIN Products P ON C.CategoryID = P.Category
GROUP BY C.CategoryName;

select c.FirstName,c.LastName, C.City, O.OrderID, O.TotalAmount
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE C.City = 'Los Angeles'
  AND O.TotalAmount>300

SELECT E.Name, D.DepartmentName
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName IN ('HR', 'Finance')
   OR (LEN(E.Name) - LEN(REPLACE(LOWER(E.Name), 'a', '')) 
       + LEN(E.Name) - LEN(REPLACE(LOWER(E.Name), 'e', ''))
       + LEN(E.Name) - LEN(REPLACE(LOWER(E.Name), 'i', ''))
       + LEN(E.Name) - LEN(REPLACE(LOWER(E.Name), 'o', ''))
       + LEN(E.Name) - LEN(REPLACE(LOWER(E.Name), 'u', ''))) >= 4;

SELECT E.Name, D.DepartmentName, E.Salary
FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName IN ('Sales', 'Marketing')
  AND E.Salary > 60000;
