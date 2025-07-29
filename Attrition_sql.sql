create database Attrition ;
use Attrition;
#How many total employees are there?
select count(EmployeeCount) as Total_Employee
from employee_attrition;
#How many employees have left the company?
select count(attrition) as Employee_Left
from employee_attrition
where attrition = 'Yes';
#How many employees are older than 40?
alter table employee_attrition
change column ï»¿Age Age int;
select count(Age) as Above_40
from employee_attrition
where age >40;

#Show the list of employees who have worked for more than 10 years
select TotalWorkingYears as Work_exp_overdecade
from employee_attrition
where TotalWorkingYears > 10; 

#Show attrition count by department.
select count(attrition) as Employee_Left,department
from employee_attrition
where attrition = 'Yes'
group by department;

#Show attrition count by job role.
select count(attrition) as Employee_Left,JobRole
from employee_attrition
where attrition ='Yes'
group by JobRole
order by Employee_Left;

#Show average monthly income by department.
select avg(MonthlyRate) as avg_income,Department
from employee_attrition
where attrition='Yes'
group by Department
order by avg_income;

#Show average total working years by education field.
select avg(TotalWorkingYears) avg_years,EducationField
from Employee_attrition
group by EducationField
order by avg_years;

#Show number of employees by marital status.
select count(EmployeeNumber)
from employee_attrition
where Maritalstatus='Married';
#Count how many employees with overtime left the company.
select count(overtime) as attrition_by_overtime
from employee_attrition
where overtime = 'Yes';



#Find the average income of employees who left vs. who stayed.
alter table employee_attrition
change column `MonthlyIncome(INR)` MonthlyIncome int;

select avg(MonthlyIncome) as Avg_Income,attrition
from employee_attrition
group by attrition;

#Classify employees into salary bands (low, medium, high) based on MonthlyIncome
select employeenumber,
monthlyincome, 
case 
when monthlyincome < 3000 then 'LOW'
when monthlyincome between 3000 and 8000 then 'MEDIUM'
else 'HIGH'
end	 as salary_band
from employee_attrition;

#Classify employees into Age Group (Young,Adult,Senior) based on Age.
select employeenumber,Age, 
case 
when Age < 21 then 'Young'
when Age between 21 and 45 then 'Adult'
else 'Elder'
end	 as Age_Group
from employee_attrition;


#Create a flag for "high risk" employees (low satisfaction + overtime + short tenure).
SELECT 
    EmployeeNumber,JobSatisfaction,OverTime,YearsAtCompany,
    CASE
        WHEN JobSatisfaction <= 2 
        AND OverTime = 'Yes' 
        AND YearsAtCompany <= 2 
        THEN 'High Risk'
        ELSE 'Normal'
    END AS Risk_Flag
FROM employee_attrition;


#Classify work-life balance as 'Poor', 'Average', 'Good', 'Excellent' using CASE.
select employeenumber,WorkLifeBalance, 
case 
when WorkLifeBalance < 2 then 'Poor'
when WorkLifeBalance between 2 and 3 then 'Good'
else 'Excellent'
end	 as Work_Balance
from employee_attrition;

#Is attrition higher for employees with no stock options?
SELECT StockOptionLevel,COUNT(EmployeeCount) AS total_employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(EmployeeCount)  AS attrition_rate_percent
FROM employee_attrition
GROUP BY StockOptionLevel
ORDER BY StockOptionLevel;


#Is attrition more common in employees with fewer training sessions
SELECT TrainingTimesLastYear,COUNT(EmployeeCount) AS total_employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attritions,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(EmployeeCount)  AS attrition_rate_percent
FROM employee_attrition
GROUP BY TrainingTimesLastYear
ORDER BY TrainingTimesLastYear;

#Which job role has the highest attrition rate?
select JobRole,count(EmployeeCount) as TotalEmployee,
Sum(case when Attrition='yes' then 1 else 0 end) as Attrition,
Round(sum(case when Attrition='yes' then 1 else 0 end)*100/ count(EmployeeCount),2) as Atttrition_rate_percent
from employee_attrition
group by JobRole
order by Jobrole;

#Which age group has the most attrition?
select count(EmployeeCount) as Total_Employee,
case when Age between 18 and 30 then 'Young' 
when age between 31 and 50 then 'Adult'
else 'Senior'
end as Age_Group,
sum(case when Attrition='Yes' then 1 else 0 end) as Attritions,
Round(sum(case when Attrition='yes' then 1 else 0 end)*100/Count(Employeecount),2) as Attrition_Percent
from employee_attrition
group by Age_Group
order by attrition_Percent;

#Is attrition rate different by gender?
select Gender,count(EmployeeCount) as TotalEmployee,
Sum(case when Attrition='yes' then 1 else 0 end) as Attrition,
Round(sum(case when Attrition='yes' then 1 else 0 end)*100/ count(EmployeeCount),2) as Atttrition_rate_percent
from employee_attrition
group by Gender
order by Gender;

#Rank employees by monthly income within each department.
SELECT MonthlyIncome, Department, EmployeeNumber,
RANK() OVER (PARTITION BY Department ORDER BY MonthlyIncome DESC) AS IncomeRank
FROM employee_attrition;

#Rank employees by age within each department.
SELECT Age, Department, EmployeeNumber,
RANK() OVER(PARTITION BY Department ORDER BY Age DESC) AS Age_Rank
FROM employee_attrition;

#Rank employees by DailyRate within each department.

SELECT DailyRate, Department, EmployeeNumber,
RANK() OVER(PARTITION BY Department ORDER BY DailyRate DESC) AS DailyRate_Rank
FROM employee_attrition;

#Is attrition more common in employees with fewer Salary Hike?
select count(EmployeeCount) as Total_Employee,
case when PercentSalaryHike between 11 and 15 then 'Low' 
when PercentSalaryHike between 16 and 21 then 'Average'
else 'High'
end as Hike_Range,
sum(case when Attrition='Yes' then 1 else 0 end) as Attritions,
Round(sum(case when Attrition='yes' then 1 else 0 end)*100/Count(Employeecount),2) as Attrition_Percent
from employee_attrition
group by Hike_Range
order by attrition_Percent;