USE taxiation;


-- PART A - TASK 1: TAX CALCULATION FUNCTION

DELIMITER //

CREATE FUNCTION calculate_tax(p_income DECIMAL(12,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE v_tax DECIMAL(12,2);

    IF p_income <= 500000 THEN
        SET v_tax = 0;
    ELSEIF p_income <= 1000000 THEN
        SET v_tax = (p_income - 500000) * 0.10;
    ELSEIF p_income <= 1500000 THEN
        SET v_tax = 50000 + (p_income - 1000000) * 0.20;
    ELSE
        SET v_tax = 150000 + (p_income - 1500000) * 0.30;
    END IF;

    RETURN v_tax;
END //

DELIMITER ;

SELECT calculate_tax(400000) AS tax_amount;
SELECT calculate_tax(850000) AS tax_amount;
SELECT calculate_tax(1800000) AS tax_amount;


-- PART B - TASK 2: INDIVIDUAL TAX ASSESSMENT

DELIMITER //

CREATE PROCEDURE generate_tax_assessment(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_pan VARCHAR(10);
    DECLARE v_occupation VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_net_income DECIMAL(12,2);
    DECLARE v_found INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_found = 0;

    SELECT full_name, pan_number, annual_income, occupation
    INTO v_name, v_pan, v_income, v_occupation
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_found = 0 THEN
        SELECT 'Taxpayer not found' AS message;
    ELSE
        SET v_tax = calculate_tax(v_income);
        SET v_net_income = v_income - v_tax;

        SELECT v_name AS taxpayer_name,
               v_pan AS pan_number,
               v_income AS annual_income,
               v_occupation AS occupation,
               v_tax AS tax_amount,
               v_net_income AS net_income;
    END IF;
END //

DELIMITER ;

CALL generate_tax_assessment(101);


-- PART C - TASK 3: INCOME CLASSIFICATION FUNCTION

DELIMITER //

CREATE FUNCTION income_category(p_income DECIMAL(12,2))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    IF p_income <= 500000 THEN
        RETURN 'Low Income';
    ELSEIF p_income <= 1000000 THEN
        RETURN 'Medium Income';
    ELSEIF p_income <= 1500000 THEN
        RETURN 'High Income';
    ELSE
        RETURN 'Very High Income';
    END IF;
END //

DELIMITER ;

SELECT full_name,
       annual_income,
       income_category(annual_income) AS income_category
FROM Taxpayer;


-- LEVEL 1 - QUESTION 1: TAXPAYER SUMMARY

DELIMITER //

CREATE PROCEDURE taxpayer_summary(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_category VARCHAR(30);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_net_income DECIMAL(12,2);
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
        SET v_category = income_category(v_income);
        SET v_tax = calculate_tax(v_income);
        SET v_net_income = v_income - v_tax;

        SELECT v_name AS taxpayer_name,
               v_income AS annual_income,
               v_category AS income_category,
               v_tax AS calculated_tax,
               v_net_income AS net_income;
    END IF;
END //

DELIMITER ;

CALL taxpayer_summary(101);


-- LEVEL 1 - QUESTION 2: INCOME RECORD PROCESSING

DELIMITER //

CREATE PROCEDURE process_income_records(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_annual_income DECIMAL(12,2);
    DECLARE v_total_income DECIMAL(12,2);
    DECLARE v_difference DECIMAL(12,2);
    DECLARE v_count INT DEFAULT 0;
    DECLARE v_found INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_found = 0;

    SELECT full_name, annual_income
    INTO v_name, v_annual_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_found = 0 THEN
        SELECT 'Taxpayer not found' AS message;
    ELSE
        SELECT COUNT(*), COALESCE(SUM(amount), 0)
        INTO v_count, v_total_income
        FROM Income_Record
        WHERE taxpayer_id = p_taxpayer_id;

        IF v_count = 0 THEN
            SELECT 'No income records found' AS message;
        ELSE
            SET v_difference = v_annual_income - v_total_income;

            SELECT v_name AS taxpayer_name,
                   v_total_income AS total_recorded_income,
                   v_annual_income AS annual_income,
                   v_difference AS difference;
        END IF;
    END IF;
END //

DELIMITER ;

CALL process_income_records(101);


-- LEVEL 1 - QUESTION 3: CONDITIONAL ASSESSMENT

DELIMITER //

CREATE PROCEDURE conditional_assessment(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_status VARCHAR(50);
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
        IF v_income <= 500000 THEN
            SET v_status = 'No Tax Assessment';
        ELSEIF v_income <= 1000000 THEN
            SET v_status = 'Standard Assessment';
        ELSE
            SET v_status = 'High Income Assessment';
        END IF;

        SELECT v_name AS taxpayer_name,
               v_income AS annual_income,
               v_status AS assessment_status;
    END IF;
END //

DELIMITER ;

CALL conditional_assessment(101);


-- LEVEL 2 - QUESTION 1: CURSOR-BASED TAX ASSESSMENT

DELIMITER //

CREATE PROCEDURE cursor_tax_assessment()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_category VARCHAR(30);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_net_income DECIMAL(12,2);

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

        SET v_category = income_category(v_income);
        SET v_tax = calculate_tax(v_income);
        SET v_net_income = v_income - v_tax;

        SELECT v_name AS taxpayer_name,
               v_income AS annual_income,
               v_category AS income_category,
               v_tax AS calculated_tax,
               v_net_income AS net_income;
    END LOOP;

    CLOSE taxpayer_cursor;
END //

DELIMITER ;

CALL cursor_tax_assessment();


-- LEVEL 2 - QUESTION 2: CURSOR WITH CONDITIONAL PROCESSING

DELIMITER //

CREATE PROCEDURE conditional_cursor_assessment()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_category VARCHAR(30);

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

        IF v_income <= 500000 THEN
            SET v_tax = 0;
            SET v_category = 'NO TAX';
        ELSEIF v_income <= 1000000 THEN
            SET v_tax = (v_income - 500000) * 0.10;
            SET v_category = 'Standard Assessment';
        ELSE
            SET v_tax = calculate_tax(v_income);
            SET v_category = income_category(v_income);
        END IF;

        SELECT v_name AS taxpayer_name,
               v_income AS annual_income,
               v_tax AS tax_amount,
               v_category AS assessment_category;
    END LOOP;

    CLOSE taxpayer_cursor;
END //

DELIMITER ;

CALL conditional_cursor_assessment();


-- LEVEL 2 - QUESTION 3: PROCEDURE WITH UPDATE

DELIMITER //

CREATE PROCEDURE update_taxpayer_income_lab10(
    IN p_taxpayer_id INT,
    IN p_new_income DECIMAL(12,2)
)
BEGIN
    DECLARE v_found INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_found = 0;

    IF p_new_income < 0 THEN
        SELECT 'Income must be greater than or equal to zero' AS message;
    ELSE
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

            SELECT taxpayer_id,
                   full_name,
                   annual_income
            FROM Taxpayer
            WHERE taxpayer_id = p_taxpayer_id;
        END IF;
    END IF;
END //

DELIMITER ;

CALL update_taxpayer_income_lab10(101, 950000);


-- LEVEL 2 - QUESTION 4: EXCEPTION HANDLING

DELIMITER //

CREATE PROCEDURE handle_tax_assessment(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_found INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_found = 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'An error occurred during tax assessment' AS message;
    END;

    SELECT annual_income
    INTO v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_found = 0 THEN
        SELECT 'Taxpayer not found' AS message;
    ELSE
        SET v_tax = calculate_tax(v_income);

        SELECT v_income AS annual_income,
               v_tax AS tax_amount;
    END IF;
END //

DELIMITER ;

CALL handle_tax_assessment(101);


-- LEVEL 3 - QUESTION 1: COMPLETE TAX ASSESSMENT SYSTEM

DELIMITER //

CREATE PROCEDURE complete_tax_assessment(IN p_taxpayer_id INT)
BEGIN
    DECLARE v_name VARCHAR(100);
    DECLARE v_pan VARCHAR(10);
    DECLARE v_occupation VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_category VARCHAR(30);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_net_income DECIMAL(12,2);
    DECLARE v_found INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_found = 0;

    SELECT full_name, pan_number, occupation, annual_income
    INTO v_name, v_pan, v_occupation, v_income
    FROM Taxpayer
    WHERE taxpayer_id = p_taxpayer_id;

    IF v_found = 0 THEN
        SELECT 'Taxpayer not found' AS message;
    ELSE
        SET v_category = income_category(v_income);
        SET v_tax = calculate_tax(v_income);
        SET v_net_income = v_income - v_tax;

        SELECT 'TAX ASSESSMENT REPORT' AS report;

        SELECT v_name AS taxpayer_name,
               v_pan AS pan_number,
               v_occupation AS occupation,
               v_income AS annual_income,
               v_category AS income_category,
               v_tax AS tax_amount,
               v_net_income AS net_income;
    END IF;
END //

DELIMITER ;

CALL complete_tax_assessment(101);


-- LEVEL 3 - QUESTION 2: INCOME RECORD CURSOR PROCESSING

DELIMITER //

CREATE PROCEDURE process_all_income_records()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_income_id INT;
    DECLARE v_taxpayer_id INT;
    DECLARE v_source VARCHAR(100);
    DECLARE v_category VARCHAR(50);
    DECLARE v_amount DECIMAL(12,2);
    DECLARE v_received_date DATE;
    DECLARE v_year VARCHAR(9);
    DECLARE v_record_category VARCHAR(30);

    DECLARE income_cursor CURSOR FOR
        SELECT ir.income_id,
               ir.taxpayer_id,
               ir.income_source,
               ic.category_name,
               ir.amount,
               ir.received_date,
               fy.year_label
        FROM Income_Record ir
        JOIN Income_Category ic
            ON ir.category_id = ic.category_id
        JOIN Financial_Year fy
            ON ir.year_id = fy.year_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET done = TRUE;

    OPEN income_cursor;

    read_loop: LOOP
        FETCH income_cursor
        INTO v_income_id,
             v_taxpayer_id,
             v_source,
             v_category,
             v_amount,
             v_received_date,
             v_year;

        IF done THEN
            LEAVE read_loop;
        END IF;

        IF v_amount <= 50000 THEN
            SET v_record_category = 'Small Income Record';
        ELSEIF v_amount <= 200000 THEN
            SET v_record_category = 'Medium Income Record';
        ELSE
            SET v_record_category = 'Large Income Record';
        END IF;

        SELECT v_income_id AS income_id,
               v_taxpayer_id AS taxpayer_id,
               v_source AS income_source,
               v_category AS category,
               v_amount AS amount,
               v_received_date AS received_date,
               v_year AS financial_year,
               v_record_category AS record_category;
    END LOOP;

    CLOSE income_cursor;
END //

DELIMITER ;

CALL process_all_income_records();


-- LEVEL 3 - QUESTION 3: COMBINED FUNCTION AND CURSOR

DELIMITER //

CREATE PROCEDURE process_active_taxpayers_with_functions()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_category VARCHAR(30);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_net_income DECIMAL(12,2);

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

        SET v_category = income_category(v_income);
        SET v_tax = calculate_tax(v_income);
        SET v_net_income = v_income - v_tax;

        SELECT v_name AS taxpayer_name,
               v_income AS annual_income,
               v_category AS income_category,
               v_tax AS tax_amount,
               v_net_income AS net_income;
    END LOOP;

    CLOSE taxpayer_cursor;
END //

DELIMITER ;

CALL process_active_taxpayers_with_functions();


-- CHALLENGE QUESTION: TAXPAYER ASSESSMENT SUMMARY

DELIMITER //

CREATE PROCEDURE taxpayer_assessment_summary()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_name VARCHAR(100);
    DECLARE v_income DECIMAL(12,2);
    DECLARE v_tax DECIMAL(12,2);
    DECLARE v_category VARCHAR(30);
    DECLARE v_status VARCHAR(30);

    DECLARE v_count INT DEFAULT 0;
    DECLARE v_total_income DECIMAL(14,2) DEFAULT 0;
    DECLARE v_total_tax DECIMAL(14,2) DEFAULT 0;

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

        SET v_tax = calculate_tax(v_income);
        SET v_category = income_category(v_income);

        IF v_tax = 0 THEN
            SET v_status = 'No Tax';
        ELSE
            SET v_status = 'Tax Applicable';
        END IF;

        SET v_count = v_count + 1;
        SET v_total_income = v_total_income + v_income;
        SET v_total_tax = v_total_tax + v_tax;

        SELECT v_name AS taxpayer_name,
               v_income AS annual_income,
               v_tax AS tax_amount,
               v_category AS income_category,
               v_status AS assessment_status;
    END LOOP;

    CLOSE taxpayer_cursor;

    SELECT v_count AS total_taxpayers_processed,
           v_total_income AS total_income,
           v_total_tax AS total_tax;
END //

DELIMITER ;

CALL taxpayer_assessment_summary();