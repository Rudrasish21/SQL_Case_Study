CREATE database Credit_card_Approval_Prediction;
USE Credit_card_Approval_Prediction;
CREATE TABLE application_record ( 
	ID int, 
    Gender char(10),
    Own_Car char (10),
    Own_Realty char (10),
    Total_Children int,
    Total_Income bigint,
    Income_Type Char(100), 
    Education_Level Char(100),
    Marital_Status Char(100),
    Housing_Type Char (100),
    Age Int, 
    Occupation Char(100) );

CREATE TABLE credit_record ( 
	ID int,
    Month int, 
    Due_Month int) ;
    
/*INTRODUCTION*/

SELECT * FROM application_record LIMIT 10;

/*GENDER COMPOSITION OF THE DATABASES*/

SELECT DISTINCT COUNT(ID), Gender
FROM application_record 
GROUP BY GENDER;

/*Inference - WE CAN CONCLUDE THAT THERE ARE TWICE THE AMOUNT OF FEMALES IN THE DATABASES COMPARED TO THE MALE POPULATION*/

/* STUDY THE FEMALE GENDER DATABASE*/

/*EDUCATION LEVEL OF THE FEMALE GENDER */

SELECT DISTINCT COUNT(ID) as Total , Gender, Education_level
FROM application_record 
Where Gender = "F"
GROUP BY Education_Level;

/* HOW MANY OF THE HAS EDUCATIONAL QUALIFICATION EQUAL TO OR GREATER THAN HIGHER EDUCATION*/

with temptable as 
(
SELECT DISTINCT COUNT(ID) as Total , Gender, Education_level
FROM application_record 
Where Gender = "F"
GROUP BY Education_Level)

SELECT Sum(Total) as Total_Females_Higher_Education 
FROM temptable
WHERE Education_level IN ("Academic degree", "Higher education");


/*PERCENTAGE OF FEMALES IN EACH EDUCATION SECTOR*/ 

SET @variable1:=
(with temptable as 
(
SELECT DISTINCT COUNT(ID) as Total , Gender, Education_level
FROM application_record 
Where Gender = "F"
GROUP BY Education_Level) 

SELECT SUM(Total) 
From Temptable );


SELECT DISTINCT (COUNT(ID)/@variable1)*100 as Percentage , Gender, Education_level
FROM application_record 
Where Gender = "F"
GROUP BY Education_Level
ORDER BY Percentage DESC;

/*How many Percentage of the Females have eduation level equal to higher than Higher Education*/

Select SUM(Percentage) 
FROM ( SELECT DISTINCT (COUNT(ID)/@variable1)*100 as Percentage , Gender, Education_level
FROM application_record 
Where Gender = "F"
GROUP BY Education_Level
ORDER BY Percentage DESC) as temptable

WHERE Education_level IN ("Higher Education", "Academic degree" );


/* INFERENCE 
1) MOST OF THE FEMALE GENDERS HAVE SECONDARY/SECONDARY SPECIAL EDUCATION 
2) 27.28% HAVE HIGHER EDUCATION OR ACADEMIC DEGREE */


/*INCOME STATUS OF THE FEMALE GENDER */

Select * From application_record Limit 10;

SELECT Income_Type, SUM(Total_Income) As Total_IncomeSectors
FROM application_record
GROUP BY 1
ORDER BY 2 DESC;

/* INFERENCE - WORKING CLASS HAS THE MOST SHARE OF THE MARKET*/

/*AGE DEMOGRAPHIC OF THE FEMALE GENDER */
SELECT CASE 
			WHEN Age>= 60 THEN "Senior_Citizen"
            WHEN Age BETWEEN 40 and 59 THEN "Senior_Adults"
            WHEN Age BETWEEN 18 and 39 THEN "Adults"
            When Age < 18 THEN "CHILDREN"
            End as Age_Demo, Count(ID) as Total_Females
FROM application_record 
WHERE GENDER = "F"
GROUP BY Age_Demo
ORDER BY Total_Females DESC;


/*INCOME BY AGE GROUP*/

/*TOTAL INCOME OF AGE GROUP*/

(SELECT SUM(Total_Income)
FROM application_record 
WHERE GENDER = "F");

/*INCOME COMPOSITION BY AGE GROUP*/
SELECT CASE 
			WHEN Age>= 60 THEN "Senior_Citizen"
            WHEN Age BETWEEN 40 and 59 THEN "Senior_Adults"
            WHEN Age BETWEEN 18 and 39 THEN "Adults"
            When Age < 18 THEN "CHILDREN"
            End as Age_Demo, Sum(Total_Income) As Group_Income
FROM application_record 
WHERE GENDER = "F"
GROUP BY Age_Demo
ORDER BY Group_Income DESC ;

/*PERCENTAGE OF INCOME BY AGE GROUP*/

SELECT CASE 
			WHEN Age>= 60 THEN "Senior_Citizen"
            WHEN Age BETWEEN 40 and 59 THEN "Senior_Adults"
            WHEN Age BETWEEN 18 and 39 THEN "Adults"
            When Age < 18 THEN "CHILDREN"
            End as Age_Demo, (Sum(Total_Income)/(SELECT SUM(Total_Income)
							  FROM application_record 
							  WHERE GENDER = "F"))* 100 as Percentage_Income
FROM application_record 
WHERE GENDER = "F"
GROUP BY Age_Demo
ORDER BY Percentage_Income DESC ;

/*INFERENCE - More than 50% of TOTAL INCOME are of Senior Adults*/

/*Family Composition*/

Select * From Application_record Limit 10;

/*Marital Status of the Female Gender*/

/*Total Females */

(Select Count(ID)
From application_record 
WHERE Gender = "F");

/*Marital Status and Income Compositon*/

SELECT Marital_status, (Count(ID)/(Select Count(ID)
From application_record 
WHERE Gender = "F")*100) as Percentage_population, (Sum(Total_Income)/(SELECT SUM(Total_Income)
							  FROM application_record 
							  WHERE GENDER = "F"))* 100 as Percentage_Income
FROM application_record 
WHERE Gender = "F"
GROUP BY Marital_status;

/* INFERENCES - THERE ARE 64.78% MARRIED PEOPLE IN THE DATABASE AND 62.82% ARE EARNED BY THEM 

/* PEOPLE WHO ARE PRONE TO INCURR MORE EXPENSES ARE PEOPLE WHO HAVE CHILDREN, OWN_CAR, OWN_REALTy */

SELECT  Marital_Status, COUNT(*) As TOTAL
FROM application_record 
WHERE Gender = "F" AND Total_Children <> 0  AND Own_Car = "Y" AND Own_Realty = "Y"
GROUP BY Marital_Status 
ORDER BY TOTAL DESC;

SELECT Count(*)
FROM application_record 
WHERE Gender = "F" AND Total_Children <> 0  AND Own_Car = "Y" AND Own_Realty = "Y"
LIMIT 10;

SELECT ID
FROM application_record 
WHERE Gender = "F" AND Total_Children <> 0  AND Own_Car = "Y" AND Own_Realty = "Y"
LIMIT 10;

/*CONDITION BASED FILTERING*/

SELECT Count(ID)
FROM application_record 
WHERE gender = "F" AND Education_level IN ("Higher Education", "Academic degree" ) AND age BETWEEN 40 and 59 
AND Total_Children = 0  AND Own_Car = "N" AND Own_Realty = "N" AND Marital_Status = "Married";

/*MICRO ANALYSIS*/

SELECT * 
FROM credit_record 
LIMIT 10;

SELECT COUNT(DISTINCT(ID))
FROM credit_record 
Where Due_Month <= 3 
LIMIT 10;

/* TOTAL WOMAN WHO FALLS UNDER THE CRITERIA*/

SELECT DISTINCT(c.ID), a.Total_Income, a.gender
FROM application_record as a
INNER JOIN 
credit_record as c ON a.ID = c.ID
WHERE a.gender = "F" AND Education_level IN ("Higher Education", "Academic degree" ) AND age BETWEEN 40 and 59 
AND Total_Children = 0  AND Own_Car = "N" AND Own_Realty = "N" AND Marital_Status = "Married" AND c.Due_Month <= 3 
LIMIT 10 ;

SELECT Count(DISTINCT(c.ID)) as Total
FROM application_record as a
INNER JOIN 
credit_record as c ON a.ID = c.ID
WHERE a.gender = "F" AND Education_level IN ("Higher Education", "Academic degree" ) AND age BETWEEN 40 and 59 
AND Total_Children = 0  AND Own_Car = "N" AND Own_Realty = "N" AND Marital_Status = "Married" AND c.Due_Month <= 3 
;


/* MAX, MIN, MEAN INCOME OF WOMAN WHO FALLS UNDER THE CRITERIEA*/

SELECT MAX(a.Total_Income) as Maximum_Income, MIN(a.Total_Income) as Minimum_Income, Round(AVG(a.Total_Income),0) as Average_Income
FROM application_record as a
INNER JOIN 
credit_record as c ON a.ID = c.ID
WHERE a.gender = "F" AND Education_level IN ("Higher Education", "Academic degree" ) AND age BETWEEN 40 and 59 
AND Total_Children = 0  AND Own_Car = "N" AND Own_Realty = "N" AND Marital_Status = "Married" AND c.Due_Month <= 3 ;


/*TOTAL WOMAN WHO HAS AN INCOME OF MORE THAN 182496*/ 

SELECT COUNT(DISTINCT(a.ID))
FROM application_record as a
INNER JOIN 
credit_record as c ON a.ID = c.ID
WHERE a.gender = "F" AND Education_level IN ("Higher Education", "Academic degree" ) AND age BETWEEN 40 and 59 
AND Total_Children = 0  AND Own_Car = "N" AND Own_Realty = "N" AND Marital_Status = "Married" AND c.Due_Month <= 3 
AND Total_Income > 182496;

CREATE VIEW  Approved_customers AS
(SELECT DISTINCT(a.ID), a.Total_Income, a.Gender
FROM application_record as a
INNER JOIN 
credit_record as c ON a.ID = c.ID
WHERE a.gender = "F" AND Education_level IN ("Higher Education", "Academic degree" ) AND age BETWEEN 40 and 59 
AND Total_Children = 0  AND Own_Car = "N" AND Own_Realty = "N" AND Marital_Status = "Married" AND c.Due_Month <= 3 
AND Total_Income > 182496
);

/* Check wheather an ID can be approved or Not*/
 SELECT * FROM Approved_customers
 WHERE ID = 5009192;
 


