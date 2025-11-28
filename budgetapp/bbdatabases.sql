DROP DATABASE IF EXISTS cs495_budget_bandits;
CREATE DATABASE cs495_budget_bandits;
USE cs495_budget_bandits;

CREATE TABLE login_info (
  username varchar(128) NOT NULL,
  pass varchar(128),
  PRIMARY KEY (username)
);

CREATE TABLE daily_spending (
  record_date TIMESTAMP NOT NULL,
  start_money FLOAT NOT NULL,
  spending FLOAT NOT NULL,
  PRIMARY KEY (record_date)
);

CREATE TABLE finances (
  bill_id INT AUTO_INCREMENT NOT NULL,
  bill_name varchar(128) NOT NULL,
  bill_size FLOAT NOT NULL,
  bill_date DATE,
  bill_freq varchar(10) NOT NULL,
  PRIMARY KEY (bill_id)
);

/*INSERT INTO login_info
VALUES ();

INSERT INTO daily_spending
VALUES ();

INSERT INTO finances
VALUES ();*/

/* CREATE INDEXES */
CREATE INDEX spending ON daily_spending(record_date, start_money, spending);
CREATE INDEX finan ON finances(bill_name, bill_size, bill_date, bill_freq);

/* CREATE VIEWS (how people will see the data) */

CREATE VIEW view_finances as SELECT f.bill_name, f.bill_size, f.bill_date, f.bill_freq FROM finances f; 

/* CREATE STORED PROCEDURES (common functions for the data) */

/* doesn't work
DELIMITER //
CREATE PROCEDURE add_day()
  BEGIN
    INSERT INTO daily_spending VALUES(DATE( NOW() ), SELECT d.start_money - d.spending 
           FROM record_date = INTERVAL(DATE( NOW() ), -1 DAY) WHERE daily_spending d, 0);
  END;
DELIMITER ;
*/

/* doesn't work
DELIMITER //
CREATE PROCEDURE update_day(change FLOAT)
  BEGIN
    UPDATE daily_spending SET (spending = spending + change) WHERE record_date = DATE(NOW());
  END;
DELIMITER ;
*/

















