--Deliverable 1

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
ORDER BY emp_no ASC;

-- Use Dictinct with Orderby to remove duplicate rows for part 2/Deliverable 1
SELECT DISTINCT ON (ret.emp_no) ret.emp_no,
ret.first_name,
ret.last_name,
ret.title

INTO unique_titles
FROM retirement_titles AS ret
ORDER BY emp_no ASC, to_date DESC;

--part 3SELECT 
COUNT(unq.emp_no),unq.title
--INTO retiring_titles
FROM unique_titles as unq
GROUP BY title 
ORDER BY COUNT(title) DESC;

--Deliverable part 2
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
INNER JOIN dept_emp AS depm
ON (emp.emp_no = dept.emp_no)
INNER JOIN titles AS t
ON (emp.emp_no = t.emp_no)
WHERE (emp.birth_date BETWEEN '1962-01-01' AND '1965-12-31')
AND (dept.to_date = '9999-01-01')
ORDER BY emp_no;