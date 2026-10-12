-- Subscription Churn & Revenue Analysis: SQL queries
-- Database: SQLite (DB Browser for SQLite), table: subscription_churn_data
-- Data: synthetic dataset (2,500 records) generated with Claude (AI) to resemble real subscription behaviour
--
-- Definitions
--   Churn:  no payment within 30 days of the snapshot date (2023-06-30)
--   Tenure: New = joined 90 days or fewer before the snapshot date; Established = more than 90 days
--   Dates are stored as text (MM/DD/YYYY) and converted to YYYY-MM-DD with substr() so julianday() can read them

-- Find all Churn customer
SELECT Churn_Status, COUNT(*) AS customer_count
FROM (
    SELECT
        User_ID,
        CASE
            WHEN julianday('2023-06-30') - julianday(
                substr(Last_Payment_Date, 7, 4) || '-' ||
                substr(Last_Payment_Date, 1, 2) || '-' ||
                substr(Last_Payment_Date, 4, 2)
            ) > 30
            THEN 'Churned'
            ELSE 'Active'
        END AS Churn_Status
    FROM subscription_churn_data
)
GROUP BY Churn_Status;

-- Find Churn customer by Subscription Type
SELECT Subscription_Type, Churn_Status, COUNT(*) AS customer_count
FROM(
	SELECT User_ID, Subscription_Type,
        CASE
            WHEN julianday('2023-06-30') - julianday(
                substr(Last_Payment_Date, 7, 4) || '-' ||
                substr(Last_Payment_Date, 1, 2) || '-' ||
                substr(Last_Payment_Date, 4, 2)
            ) > 30
            THEN 'Churned'
            ELSE 'Active'
        END AS Churn_Status
    FROM subscription_churn_data
	)
GROUP BY Subscription_Type, Churn_Status
ORDER BY Subscription_Type;

-- Find Churn customer by Plan Duration
SELECT Plan_Duration, Churn_Status, COUNT(*) AS customer_count
FROM(
	SELECT User_ID, Plan_Duration,
        CASE
            WHEN julianday('2023-06-30') - julianday(
                substr(Last_Payment_Date, 7, 4) || '-' ||
                substr(Last_Payment_Date, 1, 2) || '-' ||
                substr(Last_Payment_Date, 4, 2)
            ) > 30
            THEN 'Churned'
            ELSE 'Active'
        END AS Churn_Status
    FROM subscription_churn_data
	)
GROUP BY Plan_Duration, Churn_Status
ORDER BY Plan_Duration;

-- Find Churn customer by Country
SELECT Country, Churn_Status, COUNT(*) AS customer_count
FROM(
	SELECT User_ID, Country,
        CASE
            WHEN julianday('2023-06-30') - julianday(
                substr(Last_Payment_Date, 7, 4) || '-' ||
                substr(Last_Payment_Date, 1, 2) || '-' ||
                substr(Last_Payment_Date, 4, 2)
            ) > 30
            THEN 'Churned'
            ELSE 'Active'
        END AS Churn_Status
    FROM subscription_churn_data
	)
GROUP BY Country, Churn_Status
ORDER BY Country;

-- Find Churn customer by Gender
SELECT Gender, Churn_Status, COUNT(*) AS customer_count
FROM(
	SELECT User_ID, Gender,
        CASE
            WHEN julianday('2023-06-30') - julianday(
                substr(Last_Payment_Date, 7, 4) || '-' ||
                substr(Last_Payment_Date, 1, 2) || '-' ||
                substr(Last_Payment_Date, 4, 2)
            ) > 30
            THEN 'Churned'
            ELSE 'Active'
        END AS Churn_Status
    FROM subscription_churn_data
	)
GROUP BY Gender, Churn_Status
ORDER BY Gender;

-- Find Churn customer by Tenure Segment
SELECT
    CASE
        WHEN julianday('2023-06-30') - julianday(
            substr(Join_Date, 7, 4) || '-' || substr(Join_Date, 1, 2) || '-' || substr(Join_Date, 4, 2)
        ) <= 90
        THEN 'New (<=90 days)'
        ELSE 'Established (>90 days)'
    END AS Tenure_Segment,
    Churn_Status,
    COUNT(*) AS customer_count
FROM (
    SELECT
        User_ID,
        Join_Date,
         CASE
            WHEN julianday('2023-06-30') - julianday(
                substr(Last_Payment_Date, 7, 4) || '-' ||
                substr(Last_Payment_Date, 1, 2) || '-' ||
                substr(Last_Payment_Date, 4, 2)
            ) > 30
            THEN 'Churned'
            ELSE 'Active'
        END AS Churn_Status
    FROM subscription_churn_data
)
GROUP BY Tenure_Segment, Churn_Status;

-- Find Churn customer by Device
SELECT Device, Churn_Status, COUNT(*) AS customer_count
FROM(
	SELECT User_ID, Device,
        CASE
            WHEN julianday('2023-06-30') - julianday(
                substr(Last_Payment_Date, 7, 4) || '-' ||
                substr(Last_Payment_Date, 1, 2) || '-' ||
                substr(Last_Payment_Date, 4, 2)
            ) > 30
            THEN 'Churned'
            ELSE 'Active'
        END AS Churn_Status
    FROM subscription_churn_data
	)
GROUP BY Device, Churn_Status
ORDER BY Device;

-- Find Churn customer by Age group
SELECT
	CASE
		WHEN Age BETWEEN 18 AND 24 THEN '18-24'
		WHEN Age BETWEEN 25 AND 34 THEN '25-34'
		WHEN Age BETWEEN 35 AND 44 THEN '35-44'
		WHEN Age BETWEEN 45 AND 54 THEN '45-54'
		WHEN Age BETWEEN 55 AND 64 THEN '55-64'
		WHEN Age >= 65 THEN '65+'
	END AS Age_Group,
	Churn_Status, COUNT(*) AS customer_count
FROM(
	SELECT User_ID, Age,
        CASE
            WHEN julianday('2023-06-30') - julianday(
                substr(Last_Payment_Date, 7, 4) || '-' ||
                substr(Last_Payment_Date, 1, 2) || '-' ||
                substr(Last_Payment_Date, 4, 2)
            ) > 30
            THEN 'Churned'
            ELSE 'Active'
        END AS Churn_Status
    FROM subscription_churn_data
	)
GROUP BY Age_Group, Churn_Status
ORDER BY Age_Group;

-- Calculate revenue exposure: active Basic + Monthly customers (count and monthly revenue)
SELECT
    COUNT(*) AS Risk_customers,
    SUM(Monthly_Revenue) AS Risk_MRR
FROM (
    SELECT
        User_ID,
        Monthly_Revenue,
		Subscription_Type,
		Plan_Duration,
        CASE
            WHEN julianday('2023-06-30') - julianday(
                substr(Last_Payment_Date, 7, 4) || '-' ||
                substr(Last_Payment_Date, 1, 2) || '-' ||
                substr(Last_Payment_Date, 4, 2)
            ) > 30
            THEN 'Churned'
            ELSE 'Active'
        END AS Churn_Status
    FROM subscription_churn_data
)
WHERE Churn_Status = 'Active'
AND Subscription_Type = 'Basic'
AND Plan_Duration = 'Monthly';

-- Select 3 variables associated with churn (Export this Data to Excel)
SELECT
	User_ID,
	Subscription_Type,
	Plan_Duration,
	Monthly_Revenue,
	CASE
		WHEN julianday('2023-06-30')-julianday(
			substr(Last_Payment_Date, 7, 4) || '-' ||
			substr(Last_Payment_Date, 1, 2) || '-' ||
			substr(Last_Payment_Date, 4, 2)
		) > 30
		THEN 'Churned'
		ELSE 'Active'
	END AS Churn_Status,
	CASE
        WHEN julianday('2023-06-30') - julianday(
            substr(Join_Date, 7, 4) || '-' || substr(Join_Date, 1, 2) || '-' || substr(Join_Date, 4, 2)
        ) <= 90
        THEN 'New (<=90 days)'
        ELSE 'Established (>90 days)'
    END AS Tenure_Segment
FROM subscription_churn_data;
