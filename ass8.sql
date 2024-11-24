CREATE DATABASE IF NOT EXISTS viit;
USE viit;

CREATE TABLE IF NOT EXISTS Library (
    BookID INT PRIMARY KEY,
    Title VARCHAR(255),
    Author VARCHAR(255),
    PublishedDate DATE
);

CREATE TABLE IF NOT EXISTS Library_Audit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    Title VARCHAR(255),
    Author VARCHAR(255),
    PublishedDate DATE,
    ChangeType ENUM('UPDATE', 'DELETE'),
    ChangeDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SHOW TABLES;

DESCRIBE Library;
DESCRIBE Library_Audit;

DELIMITER $$

CREATE TRIGGER before_library_update
BEFORE UPDATE ON Library
FOR EACH ROW
BEGIN
    INSERT INTO Library_Audit (BookID, Title, Author, PublishedDate, ChangeType)
    VALUES (OLD.BookID, OLD.Title, OLD.Author, OLD.PublishedDate, 'UPDATE');
END$$

CREATE TRIGGER before_library_delete
BEFORE DELETE ON Library
FOR EACH ROW
BEGIN
    INSERT INTO Library_Audit (BookID, Title, Author, PublishedDate, ChangeType)
    VALUES (OLD.BookID, OLD.Title, OLD.Author, OLD.PublishedDate, 'DELETE');
END$$

DELIMITER ;

INSERT INTO Library (BookID, Title, Author, PublishedDate) VALUES
(1, 'Data Structures and Algorithms', 'John Doe', '2024-01-10'),
(2, 'Introduction to Machine Learning', 'Jane Smith', '2024-02-20'),
(3, 'Database Management Systems', 'Michael Brown', '2024-03-15'),
(4, 'Operating Systems', 'Emily Davis', '2024-04-05'),
(5, 'Computer Networks', 'Chris Wilson', '2024-05-10');

SELECT * FROM Library;
SELECT * FROM Library_Audit;

UPDATE Library
SET Title = 'Advanced Data Structures and Algorithms'
WHERE BookID = 1;

DELETE FROM Library
WHERE BookID = 2;

SELECT * FROM Library;
SELECT * FROM Library_Audit;

UPDATE Library
SET Author = 'Jane Austen'
WHERE BookID = 3;

DELETE FROM Library
WHERE BookID = 4;

SELECT * FROM Library;
SELECT * FROM Library_Audit;
