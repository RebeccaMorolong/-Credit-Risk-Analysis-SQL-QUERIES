--Credit Risk Analysis (SQL Portfolio Project)
--Project Goal
-- identify patterns in loan default behavior, assess risk across customer segments, and extract actionable insights for lending decisions.

--1. Default Rate by Credit Score Bracket

SELECT 
  CASE 
    WHEN credit_score < 580 THEN 'Poor'
    WHEN credit_score BETWEEN 580 AND 669 THEN 'Fair'
    WHEN credit_score BETWEEN 670 AND 739 THEN 'Good'
    WHEN credit_score BETWEEN 740 AND 799 THEN 'Very Good'
    ELSE 'Excellent'
  END AS score_category,
  COUNT(*) AS total_loans,
  SUM(CASE WHEN l.status = 'Default' THEN 1 ELSE 0 END) AS defaulted,
  ROUND(SUM(CASE WHEN l.status = 'Default' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate_pct
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
GROUP BY score_category
ORDER BY default_rate_pct DESC;

--2. Loan Purpose Risk Comparison

SELECT 
  l.purpose,
  COUNT(*) AS total_loans,
  SUM(CASE WHEN l.status = 'Default' THEN 1 ELSE 0 END) AS defaults,
  ROUND(SUM(CASE WHEN l.status = 'Default' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS default_rate
FROM loans l
GROUP BY l.purpose
ORDER BY default_rate DESC;


--3. Missed Payments Trend Over Time

SELECT 
  DATE_TRUNC('month', p.payment_date) AS month,
  COUNT(*) AS total_payments,
  SUM(CASE WHEN missed_payment = 1 THEN 1 ELSE 0 END) AS missed_payments,
  ROUND(SUM(CASE WHEN missed_payment = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS missed_payment_pct
FROM payments p
GROUP BY month
ORDER BY month;

--4. Average Loan Amount by Employment Length

SELECT 
  employment_len,
  COUNT(*) AS total_borrowers,
  ROUND(AVG(amount), 2) AS avg_loan_amount
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
GROUP BY employment_len
ORDER BY avg_loan_amount DESC;



