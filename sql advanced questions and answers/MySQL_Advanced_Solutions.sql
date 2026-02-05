#1
select customername,sum(quantityordered*priceeach) as ttlvalue,dense_rank() over
 ( order by sum(quantityordered*priceeach) desc)
 from customers inner join orders using(customernumber) inner join 
orderdetails using(ordernumber) group by 1;

#2. Generate a report that lists all employees along with their manager name using self join concept
select m.employeenumber , concat(m.firstname , " ",m.lastname) , concat (e.firstname," ", e.lastname) as " report to" , e.employeenumber
from employees e inner join employees m on m.reportsTo = e.employeeNumber;

#3. Retrieve month-wise sales totals for each year and show the percentage contribution of each
#month to its respective year.
select * from orderdetails;
select * from orders;
with cte as (select year(orderDate) as year , monthname(orderdate) as month ,sum(quantityOrdered*priceeach) as ttlvalue
from orders inner join orderdetails using(ordernumber) group by 1,2),
cte2 as  (
select *,sum(ttlvalue) over (partition by year) as total_year_sales from cte)
select * ,round((ttlvalue*100)/total_year_sales)as percent from cte2
;

#4. Display product details where the selling price is higher than the average selling price of all
#products using subqueries and aggregate functions.

with cte as (select  productcode , sum(priceeach) as ttl_price from orderdetails group by 1)
select productcode from cte where ttl_price > (with wth as (select  productcode , sum(priceeach) 
as ttl_priceeach from orderdetails group by 1)
select avg(ttl_priceeach) from wth);


#5. Create a query to show customers who have placed more than 5 orders along with their total
#order value.
select customername,count(ordernumber) as ccount,sum(quantityordered*priceeach) as ttlvalue from customers inner join orders using(customernumber)
inner join orderdetails using(ordernumber)  group by 1  having ccount>5;

#6. Using appropriate joins, generate a list of all customers and their corresponding payment
#amounts. Customers without payments must also be included.
select customername, sum(amount) from customers left join payments using (customernumber) group by 1;

#7. Write a query to find the top 3 highest selling products for each year using window functions such
#as DENSE_RANK.
with cte as (select productname ,sum(quantityOrdered*priceeach)as ttlvalue,year(orderdate),dense_rank() over
(partition by year(orderDate) order by sum(quantityordered*priceeach)desc) as rn from orders inner join orderdetails
 using(ordernumber) inner join products using(productcode) group by 1,3)
 select * from cte where rn <= 3;

#8. Display order details along with previous order amount for the same customer using LAG
#function.
 select customername ,orderdate, sum(quantityordered*priceeach) as ttlvalue, lag(sum(quantityordered*priceeach)) over
 (partition by customername order by orderdate asc) as previous_value from customers inner join orders using(customernumber)
 inner join orderdetails using(ordernumber) group by 1,2;
 
 
 #9.Retrieve the first and last payment amount made by each customer using FIRST_VALUE and
#LAST_VALUE window functions.

select customername,amount,paymentdate,first_value(amount)over (partition by customername order by paymentdate asc) as firstpayment,
last_value(amount) over (partition by customername )as lastpayment from customers inner join
 payments using(customernumber) ;
 

#10. Create a report that shows total sales by year, quarter and month in a single result set using
#date time functions
 select year(orderdate) as year,quarter(orderdate) as quarter ,monthname(orderdate) as month,sum(quantityordered*priceeach) as ttlvalue
 from orders inner join orderdetails using(ordernumber) group by 1,2,3;
 
#11. Find all customers whose total payment amount is greater than the average payment amount of
#all customers.
  with cte as (select customernumber , sum(amount) as tamount from payments group by 1)
  select customernumber from cte where tamount > (with cte2 as (select customernumber , sum(amount) as tamount from payments group by 1)
  select avg(tamount) from cte2);

  
#12. Generate a query that categorizes orders into High, Medium and Low value orders using CASE
#expression.
with cte as (select ordernumber , SUM(QUANTITYORDERED*PRICEEACH) AS TOTALORDERVALUE from orderdetails group by 1)
select * ,
case 
WHEN TOTALORDERVALUE <10000 THEN "SILVER"
WHEN TOTALORDERVALUE BETWEEN 10000 AND 50000 THEN "GOLD"
ELSE "PLATINUM"
END AS CUSTOMERTYPE FROM CTE;
 
 
#13. Display details of products that have never been ordered by any customer using appropriate
#join technique.
select productname from products left join orderdetails using (productcode) where ordernumber is null; 

#15. Write a query to find employees who handle customers from more than 3 different countries

with cte as 
(select distinct(country),employeenumber from employees
 e inner join customers c on e.employeeNumber=c.salesRepEmployeeNumber) 
 select employeenumber from cte  group by 1 having count(country)>3;

#17. Display customer details along with the difference in days between their first order and last
#order using date functions.

with cte as (select customernumber , orderdate,first_value(orderdate) over
(partition by customernumber order by orderdate asc) as first_order_date,last_value(orderdate) over
(partition by customernumber) as last_order_date  from customers inner join orders using (customernumber))
select * , datediff(last_order_date,first_order_date) as day_difference from cte;

#18. Write a query to find products whose total quantity ordered is greater than the overall average
#quantity ordered of all products
with cte as (select  productcode , sum(quantityOrdered) as ttl_quantity_ordered from orderdetails group by 1)
select productcode from cte where ttl_quantity_ordered > (with wth as (select  productcode , sum(quantityOrdered) 
as ttl_quantity_ordered from orderdetails group by 1)
select avg(ttl_quantity_ordered) from wth);



