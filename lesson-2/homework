create table Employees(EmpID INT, Name varchar(50), Salary Decimal(10,2))
insert into Employees (EmpID, Name, Salary)
values (1, 'Alice', 55000)
insert into Employees values(2,'Rob', 62000)
insert into Employees( EmpID,Name, Salary)
values
(3, 'Carol',71000)
Update Employees
set Salary=7000
where EmpID=1
DELETE FROM Employees
WHERE EmpID = 2

DELETE removes specific rows based on a condition and can be rolled back.
TRUNCATE removes all rows quickly without logging each row and cannot be rolled back (in most systems).
DROP deletes the entire table structure and data permanently.

ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);
Alter table Employees
Add Department varchar(50)
Select* from Employees
Alter table Employees 
Alter column Salary FLOAT

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);
Delete from Employees
select* from Departments
INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT 1, 'Finance'
UNION ALL
SELECT 2, 'HR'
UNION ALL
SELECT 3, 'Call Center'
UNION ALL
select 4, 'IT'  
UNION ALL
select 5, 'Finance';
update Departments
set department= 'management'
where salary > 5000
truncate table Employees
Alter table Employees
drop column Department
select* from Departments
exec sp_rename 'Employees','StaffMembers'
drop table Departments

Create table Products (ProductID int primary key, ProductName Varchar(100), Category varchar(100), Price decimal(10.2))
alter table Products
add constraint chk_price check (Price>0)

alter table Products
Add StockQuantity int default 50
exec sp_rename 'Products.Category','ProductCategory','COLUMN'
insert into Products (ProductID, ProductName, ProductCategory, Price, StockQuantity)
select 1, 'Milk','grocery',1200,150
UNION ALL
select 2, 'CocaCola','Drinks', 1100,600
UNION ALL
select 3, 'Iphone','Technology', 72000,200
UNION ALL
select 4, 'Polo','Clothes',40000,150
UNION ALL
select 5, 'NoteBook','stationery', 1300, 500;
select* into Products_Backup
From Products
exec sp_rename 'Products','Inventory'
ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;
ALTER TABLE Inventory
ADD ProductCode INT IDENTITY(1000, 5);
