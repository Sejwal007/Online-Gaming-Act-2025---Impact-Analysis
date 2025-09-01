use gaming_act_analysis; -- This ensures that all queries run on the gaming_act_analysis schema

-- This creates a table named 'PreBill_marketgrowth'
CREATE TABLE IF NOT EXISTS PreBill_marketgrowth (
   Year Int Primary Key,
   MarketSize_INR_Cr Int Default Null,
   MarketSize_USD_Bn Decimal(4,2) Default Null,
   YoY_Growth_Percent Int DEFAULT Null,
   CAGR Int Default Null
);

-- This creates a table named 'PostBill_marketgrowth'
CREATE TABLE IF NOT EXISTS PostBill_marketgrowth (
   Year Int Primary Key,
   MarketSize_INR_Cr Int Default Null,
   MarketSize_USD_Bn Decimal(4,2) Default Null,
   YoY_Growth_Percent Int DEFAULT Null,
   CAGR Int Default Null
);

-- This creates a table named 'Expected_revenuesegments_2025'
CREATE TABLE IF NOT EXISTS Expected_revenuesegments_2025 (
   Year int Primary Key,
   RMG_Revenue_INR_Cr Decimal(10,2) DEFAULT NULL,
   CasualGaming_Revenue_INR_Cr Decimal(10,2) DEFAULT NULL,
   RMG_Share_Percentage Decimal(5,2) CHECK (RMG_Share_Percentage BETWEEN 0 AND 100) DEFAULT NULL
);

-- This creates a table named 'Actual_revenuesegments_2025'
CREATE TABLE IF NOT EXISTS Actual_revenuesegments_2025 (
   Year int Primary Key,
   RMG_Revenue_INR_Cr Decimal(10,2) DEFAULT NULL,
   CasualGaming_Revenue_INR_Cr Decimal(10,2) DEFAULT NULL,
   RMG_Share_Percentage Decimal(5,2) CHECK (RMG_Share_Percentage BETWEEN 0 AND 100) DEFAULT NULL 
);

-- This creates a table named 'usermetrics'
CREATE TABLE IF NOT EXISTS Usermetrics (
   Year Int Primary Key,
   Total_Gamers_Mn Int DEFAULT NULL,
   Paid_Users_Mn Int DEFAULT NULL,
   Free_Users_Mn  Int DEFAULT NULL
) ;


-- This creates a table named 'PreBill_Revenue_Top5_RMG_Companies'
CREATE TABLE IF NOT EXISTS PreBill_Revenue_Top5_RMG_Companies (
	CompanyName varchar(40) Primary Key,
	Revenue_INR_Cr INT NOT NULL
) ;



-- End of Tables --


-- Start of data insertion --


-- This inserts the data in the PreBill_marketgrowth table.
INSERT INTO PreBill_marketgrowth (Year, MarketSize_INR_Cr, MarketSize_USD_Bn, YoY_Growth_Percent, CAGR) 
VALUES 
(2021,20700,2.76,default, default),
(2022,22875,3.05,10.51, 10.51),
(2023,28132,3.41,22.98,16.58),
(2024,31938,3.70,13.53, 15.55),
(2025,33666,4.04,5.41, 12.93),
(2026,38881,4.67,15.49,13.44);

-- This inserts the data in the PostBill_marketgrowth table.
INSERT INTO PostBill_marketgrowth (Year, MarketSize_INR_Cr, MarketSize_USD_Bn, YoY_Growth_Percent, CAGR) 
VALUES 
(2025,4703,0.57,default, default);


-- This inserts the data in the Expected_revenuesegments_2025 table.
INSERT INTO Expected_revenuesegments_2025 (Year, RMG_Revenue_INR_Cr, CasualGaming_Revenue_INR_Cr, RMG_Share_Percentage)
VALUES 
(2025,26667,4750,82.18);

-- This inserts the data in the Actual_revenuesegments_2025 table.
INSERT INTO Actual_revenuesegments_2025 (Year, RMG_Revenue_INR_Cr, CasualGaming_Revenue_INR_Cr, RMG_Share_Percentage)
VALUES 
(2025,0,4750,0);

-- This inserts the data in the usermetrics table.
INSERT INTO Usermetrics (Year, Total_Gamers_Mn, Paid_Users_Mn, Free_Users_Mn)
VALUES 
(2021,390,80,310),
(2022,421,110,311),
(2023,455,136,319),
(2024,488,155,333),
(2025,517,170,347),
(2026,545,196,349);

INSERT INTO PreBill_Revenue_Top5_RMG_Companies (CompanyName, Revenue_INR_Cr)
VALUES 
('Dream11', 6384),
('MPL', 1040),
('Gameskraft', 3475),
('My11Cirle', 2023),
('Zupee', 1123);


-- End of data insertion --




-- Start of Queries --


-- This stores the query that calculates the immediate impact of the bill on the market for the year 2025 in a view named as view_MarketImpact2025
CREATE OR REPLACE VIEW view_MarketImpact2025 AS
SELECT
    pre.Year,
    pre.MarketSize_INR_Cr AS Expected_Market_Size_Cr,
    post.MarketSize_INR_Cr AS Actual_Market_Size_Cr,
    (pre.MarketSize_INR_Cr - post.MarketSize_INR_Cr) AS Market_Value_Lost_Cr,
    ROUND(((pre.MarketSize_INR_Cr - post.MarketSize_INR_Cr) / pre.MarketSize_INR_Cr) * 100, 2) AS Market_Shrinkage_Percent
FROM PreBill_marketgrowth pre
JOIN PostBill_marketgrowth post 
ON pre.Year = post.Year
WHERE pre.Year = 2025;

-- This selects and shows all the data from the query which we saved as a view named view_MarketImpact2025
Select * from view_MarketImpact2025;


-- This query calculates the immediate impact of the bill on the Real Money Gaming sector for the year 2025
SELECT e.year ,
       e.RMG_Revenue_INR_Cr as expected_RMG_Revenue_Cr,
	   a.RMG_Revenue_INR_Cr as actual_RMG_Revenue_Cr, 
       (e.RMG_Revenue_INR_Cr-a.RMG_Revenue_INR_Cr) as loss_due_to_bill_cr,
	   ROUND(((e.RMG_Revenue_INR_Cr - a.RMG_Revenue_INR_Cr) / e.RMG_Revenue_INR_Cr) * 100, 2) AS loss_in_percentage,
       e.RMG_Share_Percentage as previous_RMG_MarketShare,
	   (a.RMG_Share_Percentage) as current_RMG_MarketShare
FROM Expected_revenuesegments_2025 as e
INNER JOIN Actual_revenuesegments_2025 as a
ON e.year = a.year;


-- This query calculates the immediate impact of the bill on the Casual Gaming sector for the year 2025
SELECT e.year,
       e.CasualGaming_Revenue_INR_Cr as expected_CasualGaming_Revenue_Cr,
       a.CasualGaming_Revenue_INR_Cr as actual_CasualGaming_Revenue_Cr,
       (e.CasualGaming_Revenue_INR_Cr - a.CasualGaming_Revenue_INR_Cr) as impact_due_to_bill,
       ROUND(((e.CasualGaming_Revenue_INR_Cr - a.CasualGaming_Revenue_INR_Cr)/ e.CasualGaming_Revenue_INR_Cr)*100 ,2) as impact_due_to_bill_percentage,
       (100 - e.RMG_Share_Percentage) as previous_CasualGaming_MarketShare,
       (100 - a.RMG_Share_Percentage) as current_CasualGaming_MarketShare
FROM Expected_revenuesegments_2025 as e
INNER JOIN Actual_revenuesegments_2025 as a
ON e.year = a.year;


-- This query lists the top RMG companies impacted by the bill and their revenues pre bill

SELECT CompanyName,
       Revenue_INR_Cr as Revenue_Cr,
       ROUND((Revenue_INR_Cr / (SELECT SUM(Revenue_INR_Cr) FROM PreBill_Revenue_Top5_RMG_Companies)) * 100,2) 
       AS Share_Percent
FROM PreBill_Revenue_Top5_RMG_Companies
ORDER BY Revenue_INR_Cr DESC;


-- End of Queries --



       





