USE taxiation;

SHOW TABLES;

-- CONCEPT 5.1 - VARIABLES

DELIMITER //

CREATE PROCEDURE show_income()
BEGIN
    DECLARE v_income DECIMAL(12,2);
    SET v_income = 750000;
    SELECT v_income AS annual_income;
END //

DELIMITER ;

CALL show_income();


-- CONCEPT 5.2 - READING A VALUE FROM A TABLE

DELIMITER //

CREATE PROCEDURE get_taxpayer_income(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_income DECIMAL(12,2);

    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    SELECT v_income AS annual_income;
END //

DELIMITER ;

CALL get_taxpayer_income(101);


-- CONCEPT 5.3 - IF ELSE

DELIMITER //

CREATE PROCEDURE classify_income(IN p_income DECIMAL(12,2))
BEGIN
    IF p_income > 1000000 THEN
        SELECT 'High Income' AS category;
    ELSEIF p_income >= 500000 THEN
        SELECT 'Medium Income' AS category;
    ELSE
        SELECT 'Low Income' AS category;
    END IF;
END //

DELIMITER ;

CALL classify_income(850000);


-- CONCEPT 5.4 - CASE STATEMENT

DELIMITER //

CREATE PROCEDURE classify_income_case(IN p_income DECIMAL(12,2))
BEGIN
    CASE
        WHEN p_income > 1000000 THEN
            SELECT 'High Income' AS category;
        WHEN p_income >= 500000 THEN
            SELECT 'Medium Income' AS category;
        ELSE
            SELECT 'Low Income' AS category;
    END CASE;
END //

DELIMITER ;

CALL classify_income_case(850000);


-- CONCEPT 5.5 - LOOP

DELIMITER //

CREATE PROCEDURE count_numbers()
BEGIN
    DECLARE v_count INT DEFAULT 1;

    count_loop: LOOP
        SELECT v_count AS count_number;

        SET v_count = v_count + 1;

        IF v_count > 5 THEN
            LEAVE count_loop;
        END IF;
    END LOOP;
END //

DELIMITER ;

CALL count_numbers();


-- CONCEPT 5.6 - STORED PROCEDURE

DELIMITER //

CREATE PROCEDURE show_taxpayer(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_name VARCHAR(100);

    SELECT full_name
    INTO v_name
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    SELECT v_name AS taxpayer_name;
END //

DELIMITER ;

CALL show_taxpayer(101);


-- CONCEPT 5.7 - PROCEDURE WITH OUT PARAMETER

DELIMITER //

CREATE PROCEDURE get_income(
    IN p_taxpayer_id INT,
    OUT p_income DECIMAL(12,2)
)
BEGIN
    SELECT annual_income
    INTO p_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;
END //

DELIMITER ;

CALL get_income(101, @income);

SELECT @income AS annual_income;


-- CONCEPT 5.8 - STORED FUNCTION

DELIMITER //

CREATE FUNCTION get_annual_income(p_taxpayer_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_income DECIMAL(12,2);

    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    RETURN v_income;
END //

DELIMITER ;

SELECT get_annual_income(101) AS annual_income;


-- CONCEPT 5.9 - CURSOR

DELIMITER //

CREATE PROCEDURE display_taxpayers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);

    DECLARE taxpayer_cursor CURSOR FOR
        SELECT full_name, annual_income
        FROM Taxpayer
        WHERE is_active = 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN taxpayer_cursor;

    read_loop: LOOP
        FETCH taxpayer_cursor INTO v_name, v_income;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_name AS taxpayer_name,
               v_income AS annual_income;
    END LOOP;

    CLOSE taxpayer_cursor;
END //

DELIMITER ;

CALL display_taxpayers();


-- CONCEPT 5.10 - ERROR HANDLING

DELIMITER //

CREATE PROCEDURE find_taxpayer(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_found INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_found = 0;

    SELECT full_name
    INTO v_name
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_found = 0 THEN
        SELECT 'Taxpayer not found' AS message;
    ELSE
        SELECT v_name AS taxpayer_name;
    END IF;
END //

DELIMITER ;

CALL find_taxpayer(101);


-- PART A - TASK 2

DELIMITER //

CREATE PROCEDURE welcome_taxation()
BEGIN
    SELECT 'Welcome to TaxationDB' AS message;
END //

DELIMITER ;

CALL welcome_taxation();


-- PART A - TASK 4

DELIMITER //

CREATE PROCEDURE task4_taxpayer_income(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);

    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    SELECT v_name AS taxpayer_name,
           v_income AS annual_income;
END //

DELIMITER ;

CALL task4_taxpayer_income(101);


-- PART A - TASK 5

DELIMITER //

CREATE PROCEDURE task5_taxpayer_income(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);

    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    SELECT v_name AS taxpayer_name,
           v_income AS annual_income;
END //

DELIMITER ;

CALL task5_taxpayer_income(101);


-- LEVEL 0 - TASK 1

DELIMITER //

CREATE PROCEDURE calculate_tax(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_tax DECIMAL(12,2);

    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    SET v_tax = v_income * 0.10;

    SELECT v_tax AS ten_percent_income;
END //

DELIMITER ;

CALL calculate_tax(101);


-- LEVEL 0 - TASK 2

DELIMITER //

CREATE PROCEDURE display_taxpayer(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_pan VARCHAR(10);
    DECLARE v_occupation VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);

    SELECT full_name, pan_number, occupation, annual_income
    INTO v_name, v_pan, v_occupation, v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    SELECT v_name AS taxpayer_name,
           v_pan AS pan_number,
           v_occupation AS occupation,
           v_income AS annual_income;
END //

DELIMITER ;

CALL display_taxpayer(101);


-- LEVEL 0 - TASK 3

DELIMITER //

CREATE PROCEDURE check_taxpayer_status(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_status BOOLEAN;

    SELECT is_active
    INTO v_status
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_status = 1 THEN
        SELECT 'Active' AS taxpayer_status;
    ELSE
        SELECT 'Inactive' AS taxpayer_status;
    END IF;
END //

DELIMITER ;

CALL check_taxpayer_status(101);


-- LEVEL 0 - TASK 4

DELIMITER //

CREATE FUNCTION check_taxable(p_amount DECIMAL(12,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF p_amount > 0 THEN
        RETURN 'Taxable';
    ELSE
        RETURN 'Non-Taxable';
    END IF;
END //

DELIMITER ;

SELECT check_taxable(500000) AS tax_status;


-- LEVEL 0 - TASK 5

DELIMITER //

CREATE PROCEDURE display_numbers()
BEGIN
    DECLARE v_num INT DEFAULT 1;

    number_loop: LOOP
        SELECT v_num AS number;

        SET v_num = v_num + 1;

        IF v_num > 10 THEN
            LEAVE number_loop;
        END IF;
    END LOOP;
END //

DELIMITER ;

CALL display_numbers();


-- LEVEL 1 - TASK 1

DELIMITER //

CREATE PROCEDURE classify_taxpayer_income(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_income DECIMAL(12,2);

    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_income > 1000000 THEN
        SELECT 'High Income' AS income_category;
    ELSEIF v_income >= 500000 THEN
        SELECT 'Medium Income' AS income_category;
    ELSE
        SELECT 'Low Income' AS income_category;
    END IF;
END //

DELIMITER ;

CALL classify_taxpayer_income(101);


-- LEVEL 1 - TASK 2

SELECT full_name,
       get_annual_income(taxpayer_id) AS annual_income
FROM Taxpayer;


-- LEVEL 2 - TASK 1

DELIMITER //

CREATE PROCEDURE display_active_taxpayers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_occupation VARCHAR(100);

    DECLARE taxpayer_cursor CURSOR FOR
        SELECT full_name, annual_income, occupation
        FROM Taxpayer
        WHERE is_active = 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN taxpayer_cursor;

    read_loop: LOOP
        FETCH taxpayer_cursor
        INTO v_name, v_income, v_occupation;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_name AS taxpayer_name,
               v_income AS annual_income,
               v_occupation AS occupation;
    END LOOP;

    CLOSE taxpayer_cursor;
END //

DELIMITER ;

CALL display_active_taxpayers();


-- LEVEL 2 - TASK 2

DELIMITER //

CREATE PROCEDURE find_taxpayer_details(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_found INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_found = 0;

    SELECT full_name, annual_income
    INTO v_name, v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_found = 0 THEN
        SELECT 'Taxpayer not found' AS message;
    ELSE
        SELECT v_name AS taxpayer_name,
               v_income AS annual_income;
    END IF;
END //

DELIMITER ;

CALL find_taxpayer_details(101);


-- OPTIONAL - TASK 1

DELIMITER //

CREATE PROCEDURE update_taxpayer_income(
    IN p_taxpayer_id INT,
    IN p_new_income DECIMAL(12,2)
)
BEGIN
    DECLARE v_found INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_found = 0;

    SELECT taxpayer_id
    INTO v_found
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_found = 0 THEN
        SELECT 'Taxpayer not found' AS message;
    ELSE
        UPDATE Taxpayer
        SET annual_income = p_new_income
        WHERE taxpayer_id = p_taxpayer_id;

        SELECT 'Income updated successfully' AS message;
    END IF;
END //

DELIMITER ;

CALL update_taxpayer_income(101, 950000);


-- OPTIONAL - TASK 2

DELIMITER //

CREATE PROCEDURE classify_income_using_case(IN p_income DECIMAL(12,2))
BEGIN
    CASE
        WHEN p_income > 1000000 THEN
            SELECT 'High' AS income_category;
        WHEN p_income >= 500000 THEN
            SELECT 'Medium' AS income_category;
        ELSE
            SELECT 'Low' AS income_category;
    END CASE;
END //

DELIMITER ;

CALL classify_income_using_case(850000);


-- OPTIONAL - TASK 3

DELIMITER //

CREATE PROCEDURE display_income_records(IN p_taxpayer_id INT)
BEGIN
    SELECT ir.income_source,
           ic.category_name AS category,
           ir.amount,
           ir.received_date,
           fy.year_label AS financial_year
    FROM Income_Record ir
    JOIN Income_Category ic
        ON ir.category_id = ic.category_id
    JOIN Financial_Year fy
        ON ir.year_id = fy.year_id
    WHERE ir.taxpayer_id = p_taxpayer_id;
END //

DELIMITER ;

CALL display_income_records(101);


-- OPTIONAL - TASK 4

DELIMITER //

CREATE PROCEDURE display_all_income_records()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_income_id INT;
    DECLARE v_source VARCHAR(100);
    DECLARE v_amount DECIMAL(12,2);
    DECLARE v_year VARCHAR(9);

    DECLARE income_cursor CURSOR FOR
        SELECT ir.income_id,
               ir.income_source,
               ir.amount,
               fy.year_label
        FROM Income_Record ir
        JOIN Financial_Year fy
            ON ir.year_id = fy.year_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN income_cursor;

    read_loop: LOOP
        FETCH income_cursor
        INTO v_income_id, v_source, v_amount, v_year;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_income_id AS income_id,
               v_source AS income_source,
               v_amount AS amount,
               v_year AS financial_year;
    END LOOP;

    CLOSE income_cursor;
END //

DELIMITER ;

CALL display_all_income_records();


-- OPTIONAL - TASK 5

DELIMITER //

CREATE FUNCTION income_classification(p_amount DECIMAL(12,2))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    IF p_amount <= 500000 THEN
        RETURN 'No Tax Category';
    ELSEIF p_amount <= 1000000 THEN
        RETURN 'Moderate Income';
    ELSE
        RETURN 'High Income';
    END IF;
END //

DELIMITER ;

SELECT full_name,
       annual_income,
       income_classification(annual_income) AS income_category
FROM Taxpayer;