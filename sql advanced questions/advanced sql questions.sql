

#1. Write a query to display customer-wise total purchase amount along with the ranking of
#customers based on their total purchase in descending order using appropriate window functions.

#15. Write a query to find employees who handle customers from more than 3 different countries.

#select concat(lastname," ",firstname) as fullname,count(customernumber) as c_count from employees e inner join customers c
#on e.employeeNumber=c.salesRepEmployeeNumber having

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

# Retrieve the first and last payment amount made by each customer using FIRST_VALUE and
#LAST_VALUE window functions.

select customername,amount,paymentdate,first_value(amount)over (partition by customername order by paymentdate asc) as firstpayment,
last_value(amount) over (partition by customername order by paymentdate asc)as lastpayment from customers inner join
 payments using(customernumber) ;
 
 #11. Find all customers whose total payment amount is greater than the average payment amount of
#all customers.
 select * from payments;

with cte as (select  customernumber ,sum(amount)as tamount from payments group by 1),
cte2 as (select  avg(tamount) as a_amnt from cte  )
select * from cte2 where amount> a_amnt;

