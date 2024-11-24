DROP DATABASE LibraryManagement;
CREATE DATABASE LibraryManagement;
USE LibraryManagement;

CREATE TABLE Borrower (
    RollNo      INT PRIMARY KEY,
    Name        VARCHAR(100),
    DateofIssue DATE,
    NameofBook  VARCHAR(255),
    Status      CHAR(1)
);

CREATE TABLE Fine (
    Roll_no     INT,
    Date        DATE,
    Amt         NUMERIC(10,2),
    CONSTRAINT fk_rollno FOREIGN KEY (Roll_no) REFERENCES Borrower(RollNo)
);

INSERT INTO Borrower (RollNo, Name, DateofIssue, NameofBook, Status) VALUES 
(101, 'Aryan', '2024-07-01', 'Data Structures and Algorithms', 'I'),
(102, 'Vaibhav', '2024-07-05', 'Introduction to Machine Learning', 'I'),
(103, 'Sandesh', '2024-07-10', 'Database Management Systems', 'I'),
(104, 'Abhijeet', '2024-07-15', 'Operating Systems', 'I'),
(105, 'Suyog', '2024-07-20', 'Computer Networks', 'I'),
(106, 'Anirud', '2024-07-25', 'Artificial Intelligence', 'I'),
(107, 'Vivek', '2024-08-01', 'Software Engineering', 'I'),
(108, 'Rushikesh', '2024-08-05', 'Cybersecurity Essentials', 'I'),
(109, 'Aditya', '2024-08-10', 'Web Development', 'I'),
(110, 'Akanksha', '2024-08-15', 'Big Data Analytics', 'I'),
(111, 'Akshara', '2024-07-02', 'Digital Marketing', 'I'),
(112, 'Zaara', '2024-07-12', 'Blockchain Basics', 'I'),
(113, 'Deepak', '2024-07-18', 'IoT Fundamentals', 'I'),
(114, 'Balaji', '2024-07-22', 'Quantum Computing', 'I'),
(115, 'Atharva', '2024-07-28', 'Natural Language Processing', 'I');

DELIMITER $$

CREATE PROCEDURE ReturnBook(IN p_roll_no INT, IN p_nameofbook VARCHAR(255))
BEGIN
    DECLARE v_dateofissue DATE;
    DECLARE v_status CHAR(1);
    DECLARE v_fine_amt DECIMAL(10,2);
    DECLARE v_days INT;

	SELECT Status 
    INTO v_status
    FROM Borrower
    WHERE RollNo = p_roll_no AND NameofBook = p_nameofbook;

    IF v_status = 'R' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: The book has already been returned.';
    END IF;

    SELECT DateofIssue, Status 
    INTO v_dateofissue, v_status
    FROM Borrower
    WHERE RollNo = p_roll_no AND NameofBook = p_nameofbook;

    SET v_days = DATEDIFF(CURDATE(), v_dateofissue);

    SET v_fine_amt = 0;

    IF v_days > 30 THEN
        SET v_fine_amt = (v_days - 30) * 50 + 15 * 5;
    ELSEIF v_days > 15 THEN
        SET v_fine_amt = (v_days - 15) * 5;
    END IF;

    UPDATE Borrower
    SET Status = 'R'
    WHERE RollNo = p_roll_no AND NameofBook = p_nameofbook;

    IF v_fine_amt > 0 THEN
        INSERT INTO Fine (Roll_no, Date, Amt)
        VALUES (p_roll_no, CURDATE(), v_fine_amt);
    END IF;

    SELECT 'Book returned successfully.' AS Message;
    IF v_fine_amt > 0 THEN
        SELECT CONCAT('Fine Amount: Rs.', v_fine_amt) AS Message;
    END IF;

END$$

DELIMITER ;

SELECT * FROM Borrower;

CALL ReturnBook(107, 'Software Engineering');
CALL ReturnBook(104, 'Operating Systems');
CALL ReturnBook(113, 'IoT Fundamentals');
CALL ReturnBook(115, 'Natural Language Processing');

SELECT * FROM Fine;

CALL ReturnBook(107, 'Software Engineering');