-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE titles(
  emp_no INT NOT NULL,
  title INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp(
  dept_no VARCHAR(4) NOT NULL,
  emp_no INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM employees;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- exporting the data we found above into a file

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

SELECT* FROM departments;

DROP TABLE  dept_emp;

CREATE TABLE dept_emp(
  emp_no INT NOT NULL,
  dept_no VARCHAR(4) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

DROP TABLE dept_manager;

CREATE TABLE dept_manager (
    dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- shortened less clustered method of the code executed above

SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;	 

-- Use Left Join for retirement_info and dept_emp tables

SELECT ret.emp_no,
    ret.first_name,
    ret.last_name,
dept.to_date
INTO current_emp
FROM retirement_info as ret
LEFT JOIN dept_emp as dept
ON ret.emp_no = dept.emp_no
WHERE dept.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(curr.emp_no), dept.dept_no
FROM current_emp as curr
LEFT JOIN dept_emp as dept
ON curr.emp_no = dept.emp_no
GROUP BY dept.dept_no;

-- Employee count by department number, in order of dept_no
SELECT COUNT(curr.emp_no), dept.dept_no
FROM current_emp as curr
LEFT JOIN dept_emp as dept
ON curr.emp_no = dept.emp_no
GROUP BY dept.dept_no
ORDER BY dept.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

--combining tables to get info for boss

SELECT emp_no,
    first_name,
last_name,
    gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--- shortened version of the code above

DROP TABLE emp_info

SELECT emp.emp_no,
    emp.first_name,
emp.last_name,
    emp.gender,
    sal.salary,
    dept.to_date
INTO emp_info
FROM employees as emp
INNER JOIN salaries as sal
ON (emp.emp_no = sal.emp_no)
INNER JOIN dept_emp as dept
ON (emp.emp_no = dept.emp_no)
WHERE (emp.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (emp.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (dept.to_date = '9999-01-01');

-- List of managers per department
SELECT  dm.dept_no,
        dept.dept_name,
        dm.emp_no,
        curr.last_name,
        curr.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS dept
        ON (dm.dept_no = dept.dept_no)
    INNER JOIN current_emp AS curr
        ON (dm.emp_no = curr.emp_no);

DROP TABLE titles;

--department retirees

SELECT curr.emp_no,
curr.first_name,
curr.last_name,
dept.dept_name
-- INTO dept_info
FROM current_emp as curr
INNER JOIN dept_emp AS de
ON (curr.emp_no = de.emp_no)
INNER JOIN departments AS dept
ON (de.dept_no = dept.dept_no);

DROP TABLE titles;

CREATE TABLE titles(
  emp_no INT NOT NULL,
  title VARCHAR(50) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

--PART 1

SELECT emp.emp_no,
emp.first_name,
emp.last_name,
t.title,
t.from_date,
t.to_date
INTO retirement_titles
FROM employees as emp
INNER JOIN titles AS t
ON (emp.emp_no = t.emp_no)
WHERE (emp.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC

SELECT * FROM retirement_titles;
-----
DROP TABLE unique_titles;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (ret.emp_no) ret.emp_no,
ret.first_name,
ret.last_name,
ret.title

INTO unique_titles
FROM retirement_titles AS ret
ORDER BY emp_no ASC, to_date DESC;

--deliverable 1 part 3, getting count of each title in desc order

SELECT COUNT(unq.emp_no),unq.title
--INTO retiring_titles
FROM unique_titles as unq
GROUP BY title 
ORDER BY COUNT(title) DESC;

--DELIVERABLE 2
SELECT * FROM dept_emp;

SELECT DISTINCT ON(emp.emp_no)emp.emp_no,
emp.first_name,
emp.last_name,
emp.birth_date,
dept.from_date,
dept.to_date,
t.title
--DISTINCT ON(emp_no)
--INTO mentor_eligibility
FROM employees AS emp
INNER JOIN dept_emp AS dept
ON (emp.emp_no = dept.emp_no)
INNER JOIN titles AS t
ON (emp.emp_no = t.emp_no)
WHERE (emp.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (dept.to_date = '9999-01-01')
ORDER BY emp_no;