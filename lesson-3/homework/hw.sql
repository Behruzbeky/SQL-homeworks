BULK INSERT is a Transact-SQL (T-SQL) command in SQL Server that is used to import a large volume of data from a data file (such as a CSV, TXT, or other delimited file) into a SQL Server table or view in an efficient and fast manner.

CSV (Comma-Separated Values)
Supported by BULK INSERT, bcp, and SQL Server Integration Services (SSIS).
TXT (Plain Text Files)
Compatible with BULK INSERT and bcp.
XML (eXtensible Markup Language)
JSON (JavaScript Object Notation)
Imported using functions like OPENJSON() or through SQL Server Integration Services (SSIS).

create table Products( ProductID INT Primary KEY, ProductName varchar(50), price decimal(10,2))

Insert into Products values(1,'Nivea',1200)
Insert into Products Values(2,'Garnier',4500)
Insert into Products Values(3,'Akfa',65000)

NULL means a value is missing or unknown. It allows the column to be empty.
NOT NULL means the column must always have a value — it cannot be left empty.

alter table Products
add constraint UQ_ProductNAme Unique(ProductName)
--Ensure that each product has a unique name with no duplicates

create table Categories ( CategoryID INT Primary key, CategoryName varchar(50) UNIQUE)

The IDENTITY column in SQL Server is used to automatically generate unique numeric values for a column, usually used as a primary key.

bulk Insert Products
From'C:\Users\user\Desktop\Products.txt'
with(
     Fieldterminator=',',
	 rowterminator='\n',
	 firstrow=2
)

ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID);

A PRIMARY KEY uniquely identifies each row in a table and does not allow NULLs.
A UNIQUE KEY also ensures all values are unique but allows NULLs. Each table can have only one PRIMARY KEY but multiple UNIQUE keys.

ALTER TABLE Products
ADD CONSTRAINT CHK_Price_Positive
CHECK (Price > 0);

alter table Products
add Stock int Not null default 0

SELECT ProductName, ISNULL(Price, 0) AS Price
FROM Products;

A FOREIGN KEY constraint in SQL Server is used to enforce relationships between tables and maintain referential integrity.

create table Custumers( CustumerID int Primary key, CustumerName varchar(100), age int, 
Check (Age>=18))
CREATE TABLE Orders (
    OrderID INT IDENTITY(100, 10) PRIMARY KEY,
    OrderDate DATE,
    CustomerName VARCHAR(100)
);

CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID)
);

ISNULL only takes two arguments.
COALESCE supports multiple and follows standard SQL.

create table Employees (EmpID int primary key, EmpName varchar(100), Email varchar(150) unique)

ALTER TABLE OrderDetails
ADD CONSTRAINT FK_OrderDetails_Orders
FOREIGN KEY (OrderID)
REFERENCES Orders(OrderID)
ON DELETE CASCADE
ON UPDATE CASCADE;


