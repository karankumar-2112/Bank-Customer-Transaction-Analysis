###BANK CUSTOMER & TRANSACTION ANALYSIS

##OBJECTIVES

#1. What is the total number of transactions?
#2. What is the total transaction amount?
#3. How are transactions distributed between Debit and Credit?
#4. Which transaction type has the higher average transaction amount?
#5. Which locations have the highest transaction activity?
#6. Which transaction channel is most frequently used by customers?
#7. Which age group has the highest transaction activity?
#8. Which customer occupations have the highest transaction activity?
#9. How does the average account balance differ between Debit and Credit transactions?
#10. How does transaction duration vary across different transaction channels?
#11. Which month had the highest number of transactions?
#12. Which locations had a total transaction amount higher than the overall average transaction amount?
#13. Which transactions had an amount greater than the average transaction amount?
#14. What is the transaction rank of each transaction within its transaction type based on transaction amount?
#15. What is the running total of transaction amounts over time?


CREATE DATABASE Bank_Transaction_Analysis;
USE Bank_Transaction_Analysis;

CREATE TABLE bank_transactions(
Transaction_ID VARCHAR(50),
Account_ID VARCHAR(50),
Transaction_Amount DECIMAL(8,2),
Transaction_Date DATETIME,
Transaction_Type VARCHAR(20),
Location VARCHAR(100),
Device_ID VARCHAR(50), 
IP_Address VARCHAR(50),
Merchant_ID VARCHAR(50),
Transaction_Channel VARCHAR(30),
Customer_Age INT,
Customer_Occupation VARCHAR(50),
Transaction_Duration INT,
Login_Attempts INT,
Account_Balance Decimal(12,2),
Previous_Transaction_Date DATETIME
);

DESCRIBE bank_transactions;



##Transforming and Cleaning

SELECT COUNT(*) AS Total_Rows
FROM bank_transactions;

SELECT COUNT(*) AS NULL_TRANSACTION_ID
FROM bank_transactions
WHERE Transaction_ID IS NULL ;

#Checking Duplicates
SELECT Transaction_ID,COUNT(*) AS Duplicate_Count
FROM bank_transactions GROUP BY Transaction_ID
HAVING COUNT(*)>1;


SELECT *
FROM bank_transactions
WHERE Transaction_ID IN (
    SELECT Transaction_ID
    FROM bank_transactions
    GROUP BY Transaction_ID
    HAVING COUNT(*) > 1
)
ORDER BY Transaction_ID,Row_ID;


ALTER TABLE bank_transactions
ADD COLUMN Row_ID INT PRIMARY KEY AUTO_INCREMENT;



#Removing Duplicate Rows From The Dataset
DELETE FROM bank_transactions WHERE
Row_ID IN(2398,2231,2258,2421,
2400,2388,2409,2425,2404,
2402,2394,2424,2396,2417,
2419,2406,2428,2423,2413,
2426,2392,2430,2411,2415
);



#Dealing With NULL Values.
SELECT * FROM bank_transactions
WHERE Transaction_ID='TX000076';

UPDATE bank_transactions
SET Location='Omaha'
WHERE Transaction_ID='TX000076';
SET SQL_SAFE_UPDATES = 0;


SELECT * FROM bank_transactions
WHERE Account_ID='AC00495';


UPDATE bank_transactions
SET Transaction_ID='TX000299'
WHERE Row_ID=164;


DELETE FROM bank_transactions
WHERE Row_ID=2390;



# Checking Remaining Null Values In Transaction_ID Column.
SELECT SUM(
(Account_ID IS NULL)+
(Transaction_Amount IS NULL)+
(Transaction_Date IS NULL)+
(Transaction_Type IS NULL)+
(Location IS NULL)+
(Device_ID IS NULL)+
(IP_Address IS NULL)+
(Merchant_ID IS NULL)+
(Transaction_Channel IS NULL)+
(Customer_Age IS NULL)+
(Customer_Occupation IS NULL)+
(Transaction_Duration IS NULL)+
(Login_Attempts IS NULL)+
(Previous_Transaction_Date IS NULL)
)
AS Total_Nulls
FROM bank_transactions;
## 347 Null Values Remained 



#Transforming- Finding Negative,Unrealistic,Impossible Values 
SELECT * FROM bank_transactions
WHERE transaction_amount < 0;


SELECT count(*) FROM bank_transactions
WHERE Customer_Age > 80;

SELECT count(*) FROM bank_transactions
WHERE Customer_Age < 18;


SELECT * FROM bank_transactions
WHERE Transaction_Duration > 300;

SELECT * FROM bank_transactions
WHERE Transaction_Duration < 10;


SELECT * FROM bank_transactions
WHERE Login_Attempts = 0;

SELECT * FROM bank_transactions
WHERE Login_Attempts < 0;


SELECT * FROM bank_transactions
WHERE Account_Balance > 101;



SELECT Transaction_Type,COUNT(*)
FROM bank_transactions
GROUP BY Transaction_Type;


# Are values only the expected channels (ATM, Online, Branch)?
SELECT Transaction_Channel,COUNT(*)
FROM bank_transactions
GROUP BY Transaction_Channel;

# Checking whether dates are valid and withinthe dataset's expected period.
SELECT Transaction_Date,COUNT(*)
FROM bank_transactions
GROUP BY Transaction_Date;



# No Extra Spaces and Unformatted Data 
SELECT Transaction_Duration, TRIM(Transaction_Duration)
FROM bank_transactions
WHERE Transaction_Duration <> TRIM(Transaction_Duration);


--  ---    ---  --


#1. What is the total number of transactions?
SELECT COUNT(*) AS Total_Transactions
FROM bank_transactions; 



#2. What is the total transaction amount?
SELECT SUM(Transaction_Amount) AS Total_Transactions_Amount
FROM bank_transactions;


#3. How are transactions distributed between Debit and Credit?
SELECT Transaction_Type,COUNT(Transaction_ID)
FROM bank_transactions
GROUP BY Transaction_Type;



#4. Which transaction type has the higher average transaction amount?
SELECT Transaction_Type,AVG(Transaction_Amount)
FROM bank_transactions
GROUP BY Transaction_Type;



#5. Which locations have the highest transaction activity?
SELECT Location,COUNT(*) AS Transaction_Activity
FROM bank_transactions
GROUP BY Location ORDER BY
Transaction_Activity DESC;



#6. Which transaction channel is most frequently used by customers?
SELECT Transaction_Channel,COUNT(*) AS Transaction_Count
FROM bank_transactions
GROUP BY Transaction_Channel;



#7. Which age group has the highest transaction activity?
SELECT CASE
	WHEN Customer_Age BETWEEN 18 AND 30 THEN '18-30'
    WHEN Customer_Age BETWEEN 31 AND 50 THEN '31-50'
    WHEN Customer_Age BETWEEN 51 AND 60 THEN '51-60'
    WHEN Customer_Age BETWEEN 61 AND 70 THEN '61-70'
    WHEN Customer_Age BETWEEN 71 AND 80 THEN '71-80'
END AS Age_Group,
COUNT(*) AS Transaction_Activity
FROM bank_transactions
GROUP BY Age_Group;



#8. Which customer occupations have the highest transaction activity?
SELECT * FROM bank_transactions;
SELECT Customer_Occupation,COUNT(*) AS Transaction_Activity
FROM bank_transactions
GROUP BY Customer_Occupation;



#9. How does the average account balance differ between Debit and Credit transactions?
SELECT Transaction_Type,AVG(Account_Balance)
FROM bank_transactions
GROUP BY Transaction_Type;



#10. How does transaction duration vary across different transaction channels?
SELECT Transaction_Channel,AVG(Transaction_Duration)
FROM bank_transactions
GROUP BY Transaction_Channel;



#11. Which month had the highest number of transactions?
SELECT MONTHNAME(Transaction_Date),COUNT(*) AS Transaction_Activity
FROM bank_transactions
GROUP BY MONTHNAME(Transaction_Date)
ORDER BY Transaction_Activity DESC LIMIT 5;



#12. Which locations had an average transaction amount higher than the overall average transaction amount?
WITH Location_avg_tm AS (
SELECT Location,AVG(Transaction_amount) AS Average_transaction_amount FROM bank_transactions
GROUP BY Location
)
SELECT * FROM Location_avg_tm
WHERE Average_transaction_amount > (SELECT AVG(Transaction_Amount) FROM bank_transactions)
ORDER BY Average_transaction_amount DESC
LIMIT 5;



#13. Which transactions had an amount greater than the average transaction amount?
SELECT Transaction_ID,Account_ID,Transaction_Amount
FROM bank_transactions WHERE Transaction_Amount > (SELECT AVG(Transaction_Amount) FROM bank_transactions)
ORDER BY Transaction_Amount DESC LIMIT 5;



#14. What is the transaction rank of each transaction within its transaction type based on transaction amount?
SELECT Transaction_ID,Transaction_type,Transaction_Amount,
		RANK() OVER(
			PARTITION BY Transaction_type
            ORDER BY Transaction_Amount DESC
		) AS Transaction_Rank
FROM bank_transactions
WHERE Transaction_type IS NOT NULL
	AND Transaction_Amount IS NOT NULL;



#15. What is the running total of transaction amounts over time?
SELECT Transaction_ID,Transaction_Date,Transaction_Amount,SUM(Transaction_Amount) OVER(
			ORDER BY Transaction_Date,Transaction_ID
            ) AS Running_Total
FROM bank_transactions
WHERE Transaction_Date IS NOT NULL;

