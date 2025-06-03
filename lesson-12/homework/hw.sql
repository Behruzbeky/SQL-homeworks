select p.firstName,p.lastName,a.city,a.state from Person p
left join Address a on p.personId=a.personId 

select e.Name from Employee e
join employee m on e.managerId=m.id
where e.salary>m.Salary   


SELECT email
FROM Person
GROUP BY email
HAVING COUNT(email) >1;

select id, email from Person 
group by email 
having count(email)>=1


select* from boys
select* from girls

SELECT DISTINCT g.ParentName FROM girls g
WHERE g.ParentName NOT IN (SELECT DISTINCT b.ParentName FROM boys b)

select* from TSQL2012.Sales.orders

select custID, sum(case when freight>50 then TotalDue else 0 end) as TotalSalesOver50,
min(freight) as LeastWeight
from TSQL2012.Sales.Orders
GROUP BY CustID

SELECT 
    c1.Item AS [Item Cart 1],
    c2.Item AS [Item Cart 2]
FROM 
    Cart1 c1
FULL OUTER JOIN 
    Cart2 c2 ON c1.Item = c2.Item
ORDER BY 
    ISNULL(c1.Item, c2.Item);


select c.Name as Customers from Customers c
left join orders o on c.id=o.CustomerID
where o.id is null

select s.student_id, s.student_name,su.subject_name,count(e.subject_name) as attended_exams from Students s
cross join subjects su 
left join examinations e on e.student_id=s.student_id
and su.subject_name=e.subject_name
order by s.student_id,su.subject_name


