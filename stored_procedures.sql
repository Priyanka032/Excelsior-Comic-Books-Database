#Trigger to check condition and issue number before insertion into comics table
DROP TRIGGER IF EXISTS condition_issue_no_check;
DELIMITER $$
CREATE TRIGGER condition_issue_no_check 
BEFORE INSERT ON comics
FOR EACH ROW
BEGIN
	IF (NEW.condition_id NOT IN ('M','NM', 'VF', 'FN', 'VG', 'GD', 'FR', 'GD')) THEN
	SIGNAL SQLSTATE '42000'
    SET MESSAGE_TEXT =  'Invalid Comic Condition Entered. Please read about the comic conditions and their abbreviations 
						carefully!';
    END IF;
    IF (NEW.issue_no <= 0) THEN
	SIGNAL SQLSTATE '42000'
    SET MESSAGE_TEXT = 'Issue Number cannot be zero or a negative number';
    END IF;
END$$
DELIMITER ;


INSERT INTO comics (comic_id, issue_no) VALUES
(35, 0);
INSERT INTO comics (comic_id, condition_id) VALUES
(35, 'F');

#Calculate the total sales for the mentioned publisher
DROP PROCEDURE IF EXISTS total_sales_by_publisher;
DELIMITER $$
CREATE PROCEDURE total_sales_by_publisher(
    IN publisher_name VARCHAR(100), 
    OUT total_sales FLOAT
)
BEGIN
    SELECT SUM(od.quantity * c.sale_price) INTO total_sales
    FROM order_details od
    JOIN comics c 
    ON od.comic_id = c.comic_id
    JOIN publishers p 
    ON c.publisher_id = p.publisher_id
    WHERE p.publisher_name = publisher_name;
END$$
DELIMITER ;

call total_sales_by_publisher('Dark Horse Comics',@total_sales);
select @total_sales;

call total_sales_by_publisher('Marvel Comics',@total_sales);
select @total_sales;


#Trigger to check user information before insertion into users table
DELIMITER $$
CREATE TRIGGER user_information_check BEFORE INSERT ON users
FOR EACH ROW
BEGIN
	IF (NEW.user_type NOT IN ('power', 'standard')) THEN
    SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'User type not found! It should be of type power or standard.';
    END IF;
    IF (NEW.email NOT REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Email format is invalid. Please verify what you have entered';
    END IF;
    IF NEW.mobile NOT REGEXP '^\+\d{10}$' THEN
    SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Mobile number format is invalid. Please verify as it should hold only 10 digits.';
  END IF;
END $$
DELIMITER ;

INSERT INTO users(user_id, user_type) VALUES
(50, 'normal');
INSERT INTO users(user_id, mobile) VALUES
(50, '268239239790');
INSERT INTO users(user_id, email) VALUES
(50, 'natasha_hotmail');

#Trigger to check if the comic is in stock before insertion into orders and orders_details tables
DROP TRIGGER IF EXISTS stock_check;
DELIMITER $$
CREATE TRIGGER stock_check
BEFORE INSERT ON order_details
FOR EACH ROW
BEGIN
	IF (SELECT stock FROM comics WHERE comic_id = NEW.comic_id) = 0 
	OR (SELECT stock FROM comics WHERE comic_id = NEW.comic_id) < NEW.quantity
    THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Sorry! No stock or lesser quantity available for this comic issue';
    END IF;
END$$
DELIMITER ;

INSERT INTO order_details(order_id, comic_id, quantity) VALUES
(10, 1, 3);