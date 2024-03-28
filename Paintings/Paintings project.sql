create database paintings_db;

use paintings_db;

/*1) Are there museuems without any paintings?*/
select *
from museum m
LEFT JOIN work w
ON m.museum_id = w.museum_id
Where w.museum_id is NULL;

/*2) Identify the paintings whose asking price is less than 50% of its regular price*/
select w.name, p.sale_price, p.regular_price
from product_size p
left join work w
on p.work_id = w.work_id
where p.sale_price < (0.5*p.regular_price);

/*3) Which canva size costs the most?*/
select c.label, p.sale_price
from
product_size p
JOIN canvas_size c
ON p.size_id = c.size_id
Group by c.label,p.sale_price
HAVING max(p.sale_price)
order by p.sale_price desc
limit 1;

/*4) Identify the museums with invalid city information in the given dataset*/
SELECT *
FROM museum
WHERE city REGEXP '^[0-9]';

/*5) Fetch the top 10 most famous painting subject*/
select distinct subject, count(*)
from subject s
join work w on s.work_id=w.work_id
group by subject
order by count(*) desc
limit 10;

/*6) Identify the museums which are open on both Sunday and Monday. 
Display museum name, city.*/
SELECT m.name, m.city, m.state, m.country
FROM museum_hours mh
JOIN museum m ON mh.museum_id = m.museum_id
WHERE day IN ('Sunday', 'Monday')
GROUP BY m.name, m.city, m.state, m.country
HAVING COUNT( day) = 2
ORDER BY m.name;

/*7) How many museums are open every single day?*/
select count(*) from
(SELECT museum_id,COUNT(museum_id)
FROM museum_hours
GROUP BY museum_id
HAVING COUNT(day) =7) as a;

/*8)A Which are the top 5 most popular museum? 
(Popularity is defined based on most no of paintings in a museum)*/
select m.museum_id, m.name,
count(*) as no_of_painting
FROM museum m
JOIN work w
ON m.museum_id = w.museum_id
group by m.museum_id, m.name
order by count(*) desc
Limit 5;

/*9) Who are the top 5 most popular artist? 
(Popularity is defined based on most no of paintings done by an artist)*/
select a.full_name, a.nationality, count(*) as no_of_painting
FROM artist a
JOIN work w
ON a.artist_id = w.artist_id
group by a.full_name, a.nationality
order by count(*) desc
limit 5;

/*10) Which museum is open for the longest during a day. 
Dispay museum name, state and hours open and which day?*/
select m.name,m.state, mh.day, mh.open-mh.close as long_e
from museum_hours mh
JOIN museum m
ON mh.museum_id = m.museum_id
order by (mh.open-mh.close) desc
limit 1;

/*11)A Which museum has the most no of most popular painting style?*/
select m.name, w.style, count(*) as no_of_paintings
from museum m
JOIN work w
on m.museum_id = w.museum_id
group by m.name, w.style
order by count(*) desc
limit 1;

/*12) Identify the artists whose paintings are displayed in multiple countries*/
select a.full_name, a.style, count(*) as no_of_paintings
from artist a
JOIN work w ON a.artist_id= w.artist_id
JOIN museum m ON m.museum_id = w.museum_id
group by a.full_name, a.style
order by count(*) desc
limit 5;

/*13) A Which country has the 5th highest no of paintings?*/
select m.country, count(*) as no_of_paintings
from artist a
JOIN work w ON a.artist_id= w.artist_id
JOIN museum m ON m.museum_id = w.museum_id
group by m.country
order by count(*) desc
LIMIT 1
OFFSET 4;

/*14) A Which are the 3 most popular and 3 least popular painting styles?*/
(select style, count(*) as no_of_paintings, 'Most Popular' as remarks
from work
group by style
order by count(*) desc
limit 3)
UNION
(select style, count(*) as no_of_paintings, 'Least Popular' as remarks
from work
group by style
order by count(*) asc
limit 3);

/*15)A Which artist has the most no of Portraits paintings outside USA?. 
Display artist name, no of paintings and the artist nationality.*/
select a.full_name, a.nationality, count(*) as no_of_paintings
from work w
join artist a on a.artist_id=w.artist_id
join subject s on s.work_id=w.work_id
join museum m on m.museum_id=w.museum_id
where m.country <> 'USA' AND s.subject = 'Portraits'
group by a.full_name, a.nationality
order by count(*) desc
limit 1;
