USE viit;

CREATE TABLE Stud_Marks (
    name VARCHAR(50),
    total_marks INT
);

CREATE TABLE Result (
    Roll INT,
    Name VARCHAR(50),
    Class VARCHAR(20)
);

DELIMITER //

CREATE FUNCTION categorize_marks(total_marks INT) RETURNS VARCHAR(20)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE grade VARCHAR(20);
    IF total_marks >= 990 AND total_marks <= 1500 THEN
        SET grade = 'Distinction';
    ELSEIF total_marks >= 900 AND total_marks < 990 THEN
        SET grade = 'First Class';
    ELSEIF total_marks >= 825 AND total_marks < 900 THEN
        SET grade = 'Higher Second Class';
    ELSE
        SET grade = 'No Category';
    END IF;
    RETURN grade;
END;
//

DELIMITER ;

DROP PROCEDURE IF EXISTS proc_Grade;

DELIMITER //

CREATE PROCEDURE proc_Grade()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE stud_name VARCHAR(50);
    DECLARE stud_total_marks INT;
    DECLARE max_roll INT;
    
    DECLARE cur CURSOR FOR SELECT name, total_marks FROM Stud_Marks;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    SELECT IFNULL(MAX(Roll), 0) INTO max_roll FROM Result;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO stud_name, stud_total_marks;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET max_roll = max_roll + 1;
        INSERT INTO Result (Roll, Name, Class)
        VALUES (max_roll, stud_name, categorize_marks(stud_total_marks));
    END LOOP;
    CLOSE cur;
END;
//

DELIMITER ;

INSERT INTO Stud_Marks (name, total_marks) VALUES ('Vaibhav', 1025);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Aryan', 980);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Sandesh', 825);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Abhijeet', 800);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Suyog', 1050);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Anirud', 930);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Vivek', 890);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Rushikesh', 920);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Aditya', 850);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Akanksha', 915);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Akshara', 885);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Priya', 865);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Zaara', 1010);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Deepak', 780);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Balaji', 905);
INSERT INTO Stud_Marks (name, total_marks) VALUES ('Atharva', 825);

CALL proc_Grade();

SELECT * FROM Result;
