drop database comics_database;
create database comics_database;
use comics_database;


CREATE TABLE graphic_novel_series (
  series_id INT PRIMARY KEY,
  series_name VARCHAR(255) NOT NULL,
  start_year INT,
  end_year INT
);

CREATE TABLE conditions (
    condition_id VARCHAR(10) PRIMARY KEY,
    condition_name VARCHAR(20),
    scale_range_start FLOAT,
    scale_range_end FLOAT,
    description VARCHAR(255)
);

CREATE TABLE publishers (
    publisher_id INT PRIMARY KEY,
    publisher_name VARCHAR(255) UNIQUE
);

CREATE TABLE writers (
	writer_id INT PRIMARY KEY,
    writer_name VARCHAR(255) UNIQUE
    );

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    mobile VARCHAR(15),
    email VARCHAR(255),
    user_type VARCHAR(10)
);

CREATE TABLE comic_info (
	info_id INT PRIMARY KEY,
    writer_id INT,
    characters VARCHAR(500),
    synopsis VARCHAR(5000),
    CONSTRAINT FK_Comics_Writers FOREIGN KEY (writer_id) REFERENCES writers(writer_id) ON DELETE CASCADE
    );

CREATE TABLE comics (
    comic_id INT PRIMARY KEY,
    title VARCHAR(255),
    issue_no INT NOT NULL,
    publisher_id INT,
    series_id INT,
    publication_date DATE,
    sale_price FLOAT,
    condition_id VARCHAR(10),
    stock INT,
    info_id INT,
    CONSTRAINT FK_Comics_Publishers FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE CASCADE,
    CONSTRAINT FK_Comics_Conditions FOREIGN KEY (condition_id) REFERENCES conditions(condition_id) ON DELETE CASCADE,
    CONSTRAINT FK_Comics_Series FOREIGN KEY (series_id) REFERENCES graphic_novel_series(series_id) ON DELETE CASCADE,
    CONSTRAINT FK_Comics_Info FOREIGN KEY (info_id) REFERENCES comic_info(info_id) ON DELETE CASCADE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);


CREATE TABLE order_details (
    id INT PRIMARY KEY auto_increment,
    order_id INT,
    comic_id INT,
    quantity INT,
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    CONSTRAINT FK_OrderDetails_Comics FOREIGN KEY (comic_id) REFERENCES comics(comic_id) ON DELETE CASCADE
);



