#Top 5 selling comics
CREATE OR REPLACE VIEW top_selling_comics AS
SELECT c.title as hot_selling_comics, ci.synopsis, 
SUM(od.quantity) AS quantity_sold
FROM comics c
JOIN order_details od 
ON c.comic_id = od.comic_id
JOIN comic_info ci 
ON ci.info_id = c.info_id
GROUP BY c.comic_id, ci.synopsis
ORDER BY quantity_sold DESC
LIMIT 5;

select * from top_selling_comics;

#Graphic novels which are no longer running
CREATE OR REPLACE VIEW terminated_series AS
SELECT series_name AS Graphic_Novels,
start_year, end_year FROM graphic_novel_series
WHERE end_year IS NOT NULL;

SELECT * FROM terminated_series;

#Comics that are a part of graphic novels
CREATE OR REPLACE VIEW comics_graphic_novels AS
SELECT c.title as comic_name, c.issue_no, c.publication_date, 
s.series_name AS graphic_novel, p.publisher_name
FROM comics c
JOIN graphic_novel_series s 
ON c.series_id = s.series_id
JOIN publishers p 
ON p.publisher_id = c.publisher_id;

SELECT * FROM comics_graphic_novels;

#In detail Information of all the comics present
CREATE OR REPLACE VIEW comic_details AS
SELECT  c.title, c.issue_no, ci.synopsis, ci.characters,
p.publisher_name, c.publication_date, w.writer_name
FROM writers w
INNER JOIN comic_info ci 
ON w.writer_id = ci.writer_id
INNER JOIN comics c 
ON ci.info_id = c.info_id
INNER JOIN publishers p 
ON c.publisher_id = p.publisher_id
ORDER BY writer_name DESC;

SELECT * FROM comic_details;

#View comics with in stock filter
CREATE OR REPLACE VIEW comics_instock AS
SELECT c.title as comic_name, c.issue_no, p.publisher_name, 
c.publication_date, co.condition_name, c.stock as stock_quantity
FROM comics c
JOIN publishers p 
ON c.publisher_id = p.publisher_id
JOIN conditions co 
ON co.condition_id = c.condition_id
where c.stock != 0
ORDER BY stock_quantity DESC;

SELECT * FROM comics_instock;

#View with Marvel and DC Comics filter
CREATE OR REPLACE VIEW explore_marvel_dc_Comics AS
SELECT c.title, c.issue_no, p.publisher_name, 
c.publication_date, co.condition_name, c.stock as stock_quantity
FROM comics c
JOIN publishers p
ON c.publisher_id = p.publisher_id
JOIN conditions co 
ON co.condition_id = c.condition_id
where p.publisher_name IN ('Marvel Comics', 'DC Comics')
ORDER BY p.publisher_name;

SELECT * FROM explore_marvel_dc_comics;

#Understanding comic conditions view with a novel suggestion
CREATE OR REPLACE VIEW understanding_comic_conditions AS
SELECT condition_id AS condition_abbreviation, condition_name,
description AS condition_description, comic_suggestion, sale_price_$
FROM (
  SELECT co.condition_id, co.condition_name, co.description, 
         c.title AS comic_suggestion, c.sale_price AS sale_price_$,
         ROW_NUMBER() OVER (PARTITION BY co.condition_id ORDER BY c.sale_price) AS limit_row
  FROM conditions co
  JOIN comics c 
  ON co.condition_id = c.condition_id
  ORDER BY co.scale_range_start DESC
) AS condition_suggestion
WHERE limit_row = 1;

SELECT * FROM understanding_comic_conditions;

