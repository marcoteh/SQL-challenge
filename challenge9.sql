
CREATE TABLE "employees" (
    "emp_no" integer   NOT NULL,
    "emp_title" varchar   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(30)   NOT NULL,
    "last_name" varchar(30)   NOT NULL,
    "sex" varchar(1)   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" integer   NOT NULL,
    "salary" money   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);
CREATE TABLE "departments" (
    "dept_no" varchar(30)   NOT NULL,
    "dept_name" varchar   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar(30)   NOT NULL,
    "emp_no" integer   NOT NULL,
    PRIMARY KEY ("dept_no", "emp_no"),
    FOREIGN KEY("dept_no") REFERENCES "departments" ("dept_no"),
    FOREIGN KEY("emp_no") REFERENCES "employees" ("emp_no")
);

CREATE TABLE "dept_emp" (
    "emp_no" integer   NOT NULL,
    "dept_no" varchar(30)   NOT NULL,
    PRIMARY KEY ("emp_no", "dept_no"),
    FOREIGN KEY("emp_no") REFERENCES "employees" ("emp_no"),
    FOREIGN KEY("dept_no") REFERENCES "departments" ("dept_no")
);




ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_title_id" FOREIGN KEY("title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_no" FOREIGN KEY("emp_no")
REFERENCES "dept_emp" ("emp_no");

ALTER TABLE "departments" ADD CONSTRAINT "fk_departments_dept_no" FOREIGN KEY("dept_no")
REFERENCES "dept_emp" ("dept_no");

-- 1. List the employee number, last name, first name, sex, and salary of each employee.
select e.emp_no, e.last_name, e.first_name, e.sex, s.salary
from employees as e
join salaries as s
ON (e.emp_no = s.emp_no);

--2. List the first name, last name, and hire date for the employees who were hired in 1986
select e.first_name, e.last_name, e.hire_date
from employees as e
where DATE_PART('year', hire_date) = 1986;

--3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
select dm.emp_no, dm.dept_no,d.dept_name,e.last_name,e.first_name
from dept_manager as dm
join departments as d
on (dm.dept_no=d.dept_no)
join employees as e
on (dm.emp_no = e.emp_no);

--4.List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
select de.dept_no, de.emp_no, e.last_name, e.first_name, d.dept_name
from dept_emp as de
join departments as d
on (de.dept_no=d.dept_no)
join employees as e
on (de.emp_no=e.emp_no);

--5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
select first_name,last_name,sex
from employees
where first_name = 'Hercules'and last_name like 'B%';

--6. List each employee in the Sales department, including their employee number, last name, and first name.
select de.emp_no, e.last_name, e.first_name
from dept_emp as de
join departments as d
on (de.dept_no = d.dept_no)
join employees as e
on (de.emp_no = e.emp_no)
where d.dept_name = 'Sales';

--7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
select de.emp_no, e.last_name, e.first_name,d.dept_name
from dept_emp as de
join departments as d
on (de.dept_no = d.dept_no)
join employees as e
on (de.emp_no = e.emp_no)
WHERE d.dept_name IN ('Sales', 'Development');

--8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, count(last_name) AS "Last Name Totals"
FROM employees
GROUP BY last_name
ORDER BY "Last Name Totals" DESC;
