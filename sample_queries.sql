#Retrieve writers and their comic information for those who have written more than one comic book
WITH writer_count AS
(SELECT writer_name, COUNT(writer_name) Number_Of_Books
 FROM comic_details
 GROUP BY writer_name
 HAVING Number_Of_Books > 1)
SELECT DISTINCT(comic_details.writer_name),
comic_details.title AS comic_name, comic_details.issue_no, comic_details.publisher_name,
comic_details.publication_date, writer_count.Number_Of_Books
FROM comic_details
INNER JOIN writer_count
ON writer_count.writer_name = comic_details.writer_name
ORDER BY writer_count.Number_Of_Books DESC;


#Retrieve comics which have had more than one publisher and belong to different graphic novel series
SELECT c1.title AS comic_name, p1.publisher_name, c1.publication_date, s.series_name,
c1.sale_price AS sale_price_$, w.writer_name
FROM comics c1
JOIN comics c2
ON c1.title = c2.title
AND c1.publisher_id <> c2.publisher_id
AND c1.series_id <> c2.series_id
JOIN publishers p1
ON c1.publisher_id = p1.publisher_id
JOIN graphic_novel_series s
ON c1.series_id = s.series_id
JOIN comic_info ci
ON c1.info_id = ci.info_id
JOIN writers w
ON w.writer_id = ci.writer_id
ORDER BY publication_date DESC;

#Retrieve comics which featured debuts of prominent characters like Spider-Man, Superman, Batman
SELECT comics.title, comic_info.characters, comic_info.synopsis,
publishers.publisher_name, comics.publication_date,
conditions.condition_name AS comic_condition,
comics.sale_price AS sales_price_$
FROM comics
JOIN comic_info
ON comics.info_id = comic_info.info_id
JOIN conditions
ON conditions.condition_id = comics.condition_id
JOIN publishers
ON publishers.publisher_id = comics.publisher_id
WHERE comic_info.synopsis LIKE '%debut%'
OR comic_info.synopsis LIKE '%origin%'
OR comic_info.synopsis LIKE '%first%'
OR comic_info.synopsis LIKE '%intro%';
 
#Retrieve comics with grade "very fine or higher" and published between the years 1935 and 2020
SELECT c.title, c.publication_date, p.publisher_name, ci.characters, 
co.condition_name as comic_condition, c.sale_price as sale_price_$
FROM comics c
INNER JOIN conditions co
ON c.condition_id = co.condition_id 
INNER JOIN publishers p
ON p.publisher_id = c.publisher_id
INNER JOIN comic_info ci
ON c.info_id = ci.info_id
WHERE co.scale_range_start >= 7.5
AND YEAR(c.publication_date) BETWEEN 1935 AND 2020
ORDER BY co.scale_range_start DESC ;

#Calculate the total number of comics purchased and the total price for the all the customers who have placed orders.
SELECT u.user_id, u.first_name, u.last_name,
COUNT(DISTINCT o.order_id) AS number_of_orders,
SUM(od.quantity) AS total_comics_purchased,
SUM(od.quantity * c.sale_price) AS total_price_$
FROM users u
JOIN orders o 
ON u.user_id = o.user_id
JOIN order_details od 
ON o.order_id = od.order_id
JOIN comics c
ON c.comic_id = od.comic_id
GROUP BY u.user_id;



