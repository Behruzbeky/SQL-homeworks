Data-information, more specifically facts, figures, measurements and amounts that we gather for analysis or reference
Database is an organized collection of structured information or data, typically stored electronically in a computer system
Relational Databases- databases that organize data into tables with rows and columns, making it easy to access and manipulate structured information using SQL
Table is a collection of data elements organised in terms of rows and columns
SQL server compare to its competitors stands higher becouse of:
 1. High Availability: Offers features like Always On Availability Groups and Failover Clustering for minimal downtime and data loss.
 2. Security: Provides robust security with Transparent Data Encryption, row-level security, and dynamic data masking.
Performance
 3. Optimization: Includes tools like Query Store, In-Memory OLTP, and intelligent query processing for faster performance.
 4. Scalability: Supports large-scale databases with features like partitioning, stretch database, and cloud integration with Azure.
Business 
 5. Intelligence: Integrates with SQL Server Analysis Services, Reporting Services, and Power BI for advanced analytics and reporting.

Windows Authentication
Uses: Active Directory credentials.
Security: More secure since it uses Kerberos or NTLM.
Management: Centralized via Windows user accounts or groups.
Login format: DOMAIN\username or username@domain.com

SQL Server Authentication
Uses: SQL Server-specific username and password.
Login format: Just the username (e.g., sa or a custom SQL login).
Advantages:
Works in non-Windows environments.
Useful for external applications or services.
Credentials are managed within SQL Server itself.
Disadvantages:
Less secure if passwords are not properly protected.

Mixed Mode Authentication
Definition: SQL Server can be configured to support both Windows and SQL Server Authentication.
This is often enabled for flexibility in environments with mixed client types.
Optional / Special Modes:
Azure Active Directory Authentication (for Azure SQL Database): Uses Azure AD identities.
Certificate-based or Integrated Authentication (Kerberos via AD): Advanced enterprise setups.

create database SchoolIDB

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT
);

SQL Server is the program that stores your data, SSMS is the app you use to see and work with that data, and SQL is the language you use to ask questions or make changes to the data.

1. DQL – Data Query Language
Purpose: To query or retrieve data from a database.
Main command: SELECT
Example:
SELECT * FROM Students;
Explanation: Gets all rows and columns from the Students table.
2. DML – Data Manipulation Language
Purpose: To add, change, or remove data (but not the table itself).
Commands: INSERT, UPDATE, DELETE
Examples:
INSERT INTO Students VALUES (1, 'Alice', 20);
UPDATE Students SET Age = 21 WHERE StudentID = 1;
DELETE FROM Students WHERE StudentID = 1;
3. DDL – Data Definition Language
Purpose: To define or change the structure of database objects like tables.
Commands: CREATE, ALTER, DROP
Examples:
CREATE TABLE Students (StudentID INT PRIMARY KEY, Name VARCHAR(50), Age INT);
ALTER TABLE Students ADD Grade VARCHAR(10);
DROP TABLE Students;
4. DCL – Data Control Language
Purpose: To control access to data (permissions).
Commands: GRANT, REVOKE
Examples:
GRANT SELECT ON Students TO user1;
REVOKE SELECT ON Students FROM user1;
5. TCL – Transaction Control Language
Purpose: To manage changes made by DML statements; ensures data integrity.
Commands: COMMIT, ROLLBACK, SAVEPOINT
Examples:
BEGIN TRANSACTION;
UPDATE Students SET Age = 22 WHERE StudentID = 1;
COMMIT;  -- saves the change permanently

-- or
ROLLBACK;  -- undoes the change

INSERT INTO Students (StudentID, Name, Age) VALUES
(1, 'Alice', 20),
(2, 'Bob', 21),
(3, 'Charlie', 22);

