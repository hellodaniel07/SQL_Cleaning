

SELECT *
FROM heart.health


/* Upon reviewing the data, it appears there are potential duplicate records. Despite each record having a unique ID,
suggesting its distinctiveness, they appear identical. This may warrant a further investigation to verify these records. 

For this project, I will address this issue by treating the data accordingly and attempting to clean the dataset. 
Additionally, I will create views and include them in a supplemental document.
*/    


-- COUNT records
-- CREATE VIEW original AS (image 1.2)
    SELECT
        COUNT(*)
    FROM heart.health


-- CREATE TEMP Table without ID column
CREATE TEMPORARY TABLE patient
    SELECT 
        Name,
        Age,
        Gender,
        `Height(cm)`,
        `Weight(kg)`,
        `Blood Pressure(mmHg)`,
        `Cholesterol(mg/dl)`,
        `Glucose(mg/dl)`,
        Smoker,
        `Exercise(hours/week)`,
        `Heart Attack`
    FROM heart.health


-- Check for duplicated records
SELECT 
    Name,
    Age,
    Gender,
    `Height(cm)`,
    `Weight(kg)`,
    `Blood Pressure(mmHg)`,
    `Cholesterol(mg/dl)`,
    `Glucose(mg/dl)`,
    Smoker,
    `Exercise(hours/week)`,
    `Heart Attack`,
    COUNT(Name) AS duplicate
FROM heart.patient
GROUP BY
    Name,
    Age,
    Gender,
    `Height(cm)`,
    `Weight(kg)`,
    `Blood Pressure(mmHg)`,
    `Cholesterol(mg/dl)`,
    `Glucose(mg/dl)`,
    Smoker,
    `Exercise(hours/week)`,
    `Heart Attack`
HAVING
    COUNT(Name) > 1


-- Results were significant. Create table "patients" from temporary table.
CREATE TABLE patients
    SELECT 
        Name,
        Age,
        Gender,
        `Height(cm)`,
        `Weight(kg)`,
        `Blood Pressure(mmHg)`,
        `Cholesterol(mg/dl)`,
        `Glucose(mg/dl)`,
        Smoker,
        `Exercise(hours/week)`,
        `Heart Attack`
    FROM heart.health


-- Re-run duplicate query to CREATE VIEW; changing table name to "patients".
-- CREATE VIEW duplicated AS (image 1.3) 
SELECT 
    Name,
    Age,
    Gender,
    `Height(cm)`,
    `Weight(kg)`,
    `Blood Pressure(mmHg)`,
    `Cholesterol(mg/dl)`,
    `Glucose(mg/dl)`,
    Smoker,
    `Exercise(hours/week)`,
    `Heart Attack`,
    COUNT(Name) AS duplicate
FROM heart.patients
GROUP BY
    Name,
    Age,
    Gender,
    `Height(cm)`,
    `Weight(kg)`,
    `Blood Pressure(mmHg)`,
    `Cholesterol(mg/dl)`,
    `Glucose(mg/dl)`,
    Smoker,
    `Exercise(hours/week)`,
    `Heart Attack`
HAVING
    COUNT(Name) > 1;


-- CTE to SUM line of duplicates
-- CREATE VIEW sum_duplicate AS (image 1.4)
WITH cte_duplicate AS(
    SELECT 
        Name,
        Age,
        Gender,
        `Height(cm)`,
        `Weight(kg)`,
        `Blood Pressure(mmHg)`,
        `Cholesterol(mg/dl)`,
        `Glucose(mg/dl)`,
        Smoker,
        `Exercise(hours/week)`,
        `Heart Attack`,
        COUNT(Name) AS duplicate
    FROM heart.patients
    GROUP BY
        Name,
        Age,
        Gender,
        `Height(cm)`,
        `Weight(kg)`,
        `Blood Pressure(mmHg)`,
        `Cholesterol(mg/dl)`,
        `Glucose(mg/dl)`,
        Smoker,
        `Exercise(hours/week)`,
        `Heart Attack`
    HAVING
        COUNT(Name) > 1
)
    SELECT
        SUM(duplicate) AS duplicates
    FROM
        cte_duplicate;


-- USE window function to rank identical record
-- CREATE VIEW windows AS (image 1.5)
    SELECT 
        Name,
        Age,
        Gender,
        `Height(cm)`,
        `Weight(kg)`,
        `Blood Pressure(mmHg)`,
        `Cholesterol(mg/dl)`,
        `Glucose(mg/dl)`,
        Smoker,
        `Exercise(hours/week)`,
        `Heart Attack`,
        ROW_NUMBER() OVER(partition by Name, Age, Gender, `Height(cm)`,`Weight(kg)`,`Blood Pressure(mmHg)`, `Cholesterol(mg/dl)`, `Glucose(mg/dl)`, Smoker, `Exercise(hours/week)`, `Heart Attack` order by Name) AS number
    FROM heart.patients;


-- USE CTE to remove duplicates
-- CREATE VIEW removed AS (Image 1.6)
-- CREATE TABLE final
WITH cte_remove AS (
    SELECT 
        Name,
        Age,
        Gender,
        `Height(cm)`,
        `Weight(kg)`,
        `Blood Pressure(mmHg)`,
        `Cholesterol(mg/dl)`,
        `Glucose(mg/dl)`,
        Smoker,
        `Exercise(hours/week)`,
        `Heart Attack`,
        ROW_NUMBER() OVER(partition by Name, Age, Gender, `Height(cm)`,`Weight(kg)`,`Blood Pressure(mmHg)`, `Cholesterol(mg/dl)`, `Glucose(mg/dl)`, Smoker, `Exercise(hours/week)`, `Heart Attack` order by Name) AS number
    FROM heart.patients
)
    SELECT
        *
    FROM cte_remove
    WHERE 
        number = 1 ;


-- CREATE VIEW final_count AS (image 1.7)
SELECT 
    COUNT(*) AS final_count
FROM heart.final






