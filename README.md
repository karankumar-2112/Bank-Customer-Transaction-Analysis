# 🏦 Bank Customer & Transaction Analysis

## 📌 Project Overview

This project analyzes bank transaction data using **MySQL and Python (Jupyter Notebook)** to explore transaction patterns, customer behavior, and transaction activity.

The project covers **data cleaning, validation, SQL analysis, and Python-based visualization**.

---

## 🛠️ Tools & Technologies

- Excel
- MySQL
- Python
- Jupyter Notebook
- Pandas
- Matplotlib
- Seaborn

---

## 📊 Dataset

**Source:** [Kaggle – Bank Transaction Dataset](https://www.kaggle.com/datasets/muhammaddhiyaulatha/bank-transaction-dataset)

The dataset contains transaction information including transaction amount, type, date, location, transaction channel, customer age, occupation, transaction duration, account balance, and other transaction-related details.

---

## 🧹 Data Cleaning & Validation

Data cleaning and validation were performed in **MySQL** before analysis.

- Identified and investigated NULL values across all columns.
- Missing values were recovered only when they could be determined reliably from the available data.
- Values that could not be reliably determined were **left as NULL rather than being guessed**.
- **347 NULL values** were retained after cleaning.
- Missing Transaction IDs were investigated using the dataset's sequential ID pattern and reliably recoverable IDs were filled.
- Exact duplicate records were identified and removed.
- Checked for invalid values such as negative transaction amounts, invalid ages, transaction durations, login attempts, and account balances.
- Validated transaction types, transaction channels, dates, and other categorical values.
- Identified a source-data inconsistency where **Transaction_Date values are from 2023 while Previous_Transaction_Date values are from 2024**. Since this issue was also present in the original source dataset, the dates were not modified or guessed.

---

## 🔍 SQL Analysis

After cleaning, MySQL was used to answer **15 business questions** covering:

- Transaction volume and total amount
- Debit vs Credit transactions
- Average transaction amounts
- Location and transaction activity
- Transaction channels
- Customer age groups and occupations
- Account balances
- Transaction duration
- Monthly transaction activity
- Above-average transaction amounts
- Transaction ranking using window functions
- Running transaction totals over time

---

## 📈 Python & Visualization

The cleaned data was loaded into **Jupyter Notebook** for further analysis and visualization using Pandas, Matplotlib, and Seaborn.

Visualizations were created to present transaction patterns across:

- Transaction types
- Transaction channels
- Locations
- Age groups
- Customer occupations
- Months
- Transaction amounts
- Account balances
- Transaction duration
- Running transaction totals

---

## 💡 Key Findings

- **2,512 transaction records** were analyzed.
- Total transaction amount recorded: **740,620.72**.
- Debit transactions: **1,920** | Credit transactions: **562**.
- Average transaction amount: **Credit – 308.12** | **Debit – 295.64**.
- Branch was the most frequently used transaction channel with **859 transactions**.
- The **18–30 age group** had the highest transaction activity.
- Students had the highest transaction activity among the listed occupations.
- Average account balance: **Debit – 5,077.86** | **Credit – 5,273.93**.

---

## 🎯 Overall Insight

The analysis provides an overall view of transaction patterns across different transaction types, channels, customer groups, and locations. The results highlight differences in transaction activity, transaction amounts, account balances, and transaction duration.

---

## 🏁 Conclusion

This project provided practical experience in **MySQL data cleaning and validation, SQL-based analysis, and Python visualization**, while working with real-world data quality issues such as missing values, duplicates, and source-data inconsistencies.

