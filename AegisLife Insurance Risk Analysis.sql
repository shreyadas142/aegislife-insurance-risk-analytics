SHOW VARIABLES LIKE 'local_infile';

USE aegislife_insurance;

SELECT DATABASE();
SHOW TABLES;

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Desktop/Customer_Master_Cleaned A.csv'
INTO TABLE customer_master
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    customer_id,
    full_name,
    age,
    gender,
    marital_status,
    occupation,
    region,
    smoking_status,
    pre_existing_illness,
    risk_score,
    date_joined
);

SELECT COUNT(*) AS total_customers

SELECT *
FROM customer_master
LIMIT 10;
FROM customer_master;

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Desktop/agent info.csv'
INTO TABLE agent_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    agent_id,
    region,
    join_date,
    total_policies_sold,
    lapsed_policies,
    avg_premium_sold,
    fraud_association
);

SELECT COUNT(*) AS total_agents
FROM agent_info;

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Desktop/Policy details.csv'
INTO TABLE policy_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    policy_id,
    customer_id,
    product_type,
    coverage_amount,
    annual_premium,
    policy_start_date,
    policy_end_date,
    agent_id
);

SELECT COUNT(*) AS invalid_customer_ids
FROM policy_details p
LEFT JOIN customer_master c
    ON p.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS invalid_agent_ids
FROM policy_details p
LEFT JOIN agent_info a
    ON p.agent_id = a.agent_id
WHERE a.agent_id IS NULL;


USE aegislife_insurance;

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Desktop/Claim history.csv'
INTO TABLE claim_history
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    claim_id,
    policy_id,
    claim_date,
    claim_amount,
    claim_status,
    claim_type,
    fraud_flag,
    days_to_process
);

SELECT COUNT(*) AS total_claims
FROM claim_history;

SELECT COUNT(*) AS invalid_policy_ids
FROM claim_history ch
LEFT JOIN policy_details p
    ON ch.policy_id = p.policy_id
WHERE p.policy_id IS NULL;

USE aegislife_insurance;

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Desktop/Customer feedback.csv'
INTO TABLE customer_feedback_surveys
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    feedback_id,
    customer_id,
    date_submitted,
    feedback_text,
    satisfaction_score,
    contacted_agent,
    referred_claim
);

SELECT COUNT(*) AS total_feedback
FROM customer_feedback_surveys;

SHOW WARNINGS;

SELECT COUNT(*) AS feedback_count
FROM customer_feedback_surveys;

USE aegislife_insurance;

USE aegislife_insurance;

TRUNCATE TABLE customer_feedback_surveys;

SELECT COUNT(*) AS total_feedback
FROM customer_feedback_surveys;

USE aegislife_insurance;

CREATE TABLE feedback_staging (
    feedback_id VARCHAR(20),
    customer_id VARCHAR(20),
    date_submitted DATE,
    feedback_text TEXT,
    satisfaction_score INT,
    contacted_agent VARCHAR(10),
    referred_claim VARCHAR(10)
);

USE aegislife_insurance;

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Desktop/Customer feedback.csv'
INTO TABLE feedback_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    feedback_id,
    customer_id,
    date_submitted,
    feedback_text,
    satisfaction_score,
    contacted_agent,
    referred_claim
);

SELECT COUNT(*) AS total_feedback
FROM feedback_staging;

INSERT INTO customer_feedback_surveys
(
    feedback_id,
    customer_id,
    date_submitted,
    feedback_text,
    satisfaction_score,
    contacted_agent,
    referred_claim
)
SELECT
    s.feedback_id,
    CASE
        WHEN c.customer_id IS NOT NULL THEN s.customer_id
        ELSE NULL
    END AS customer_id,
    s.date_submitted,
    s.feedback_text,
    s.satisfaction_score,
    s.contacted_agent,
    s.referred_claim
FROM feedback_staging s
LEFT JOIN customer_master c
    ON s.customer_id = c.customer_id;
    
    SHOW CREATE TABLE customer_feedback_surveys;
    
    SELECT COUNT(*) AS staging_count
FROM feedback_staging;

ALTER TABLE feedback_staging
MODIFY date_submitted VARCHAR(20);

SHOW CREATE TABLE customer_feedback_surveys;

SELECT feedback_id, date_submitted
FROM feedback_staging
LIMIT 10;

TRUNCATE TABLE feedback_staging;

SELECT COUNT(*) AS staging_count
FROM feedback_staging;

LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Desktop/Customer feedback.csv'
INTO TABLE feedback_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    feedback_id,
    customer_id,
    date_submitted,
    feedback_text,
    satisfaction_score,
    contacted_agent,
    referred_claim
);

SELECT COUNT(*) AS staging_count
FROM feedback_staging;

SELECT feedback_id, date_submitted
FROM feedback_staging
LIMIT 10;

INSERT INTO customer_feedback_surveys
(
    feedback_id,
    customer_id,
    date_submitted,
    feedback_text,
    satisfaction_score,
    contacted_agent,
    referred_claim
)
SELECT
    s.feedback_id,

    CASE
        WHEN c.customer_id IS NOT NULL THEN s.customer_id
        ELSE NULL
    END AS customer_id,

    STR_TO_DATE(
        REPLACE(s.date_submitted, '-', '/'),
        '%m/%d/%Y'
    ) AS date_submitted,

    s.feedback_text,
    s.satisfaction_score,
    s.contacted_agent,
    s.referred_claim

FROM feedback_staging s

LEFT JOIN customer_master c
    ON s.customer_id = c.customer_id;
    
    SELECT COUNT(*) AS anonymous_feedback
FROM customer_feedback_surveys
WHERE customer_id IS NULL;

SELECT COUNT(*) AS total_feedback
FROM customer_feedback_surveys;

SELECT
    (SELECT COUNT(*) FROM customer_master) AS customers,
    (SELECT COUNT(*) FROM agent_info) AS agents,
    (SELECT COUNT(*) FROM policy_details) AS policies,
    (SELECT COUNT(*) FROM claim_history) AS claims,
    (SELECT COUNT(*) FROM customer_feedback_surveys) AS feedback;
    
    USE aegislife_insurance;

SELECT
    COUNT(*) AS total_customers,
    ROUND(AVG(age),2) AS avg_customer_age,
    ROUND(AVG(risk_score),3) AS avg_risk_score
FROM customer_master;

SELECT
    COUNT(*) AS total_policies,
    ROUND(SUM(coverage_amount),2) AS total_coverage,
    ROUND(SUM(annual_premium),2) AS total_annual_premium,
    ROUND(AVG(annual_premium),2) AS avg_annual_premium
FROM policy_details;

SELECT
    COUNT(*) AS total_claims,
    ROUND(SUM(claim_amount),2) AS total_claim_amount,
    ROUND(AVG(claim_amount),2) AS avg_claim_amount
FROM claim_history;

SELECT
    CASE
        WHEN risk_score < 0.30 THEN 'Low Risk'
        WHEN risk_score < 0.70 THEN 'Medium Risk'
        ELSE 'High Risk'
    END AS risk_category,
    COUNT(*) AS customers,
    ROUND(AVG(risk_score),3) AS avg_risk_score
FROM customer_master
GROUP BY
    CASE
        WHEN risk_score < 0.30 THEN 'Low Risk'
        WHEN risk_score < 0.70 THEN 'Medium Risk'
        ELSE 'High Risk'
    END
ORDER BY avg_risk_score;

SELECT
    region,
    COUNT(*) AS customers,
    ROUND(AVG(risk_score),3) AS avg_risk_score,
    ROUND(AVG(age),1) AS avg_age
FROM customer_master
GROUP BY region
ORDER BY avg_risk_score DESC;


#Risk and smoking
SELECT
    smoking_status,
    COUNT(*) AS customers,
    ROUND(AVG(risk_score),3) AS avg_risk_score
FROM customer_master
GROUP BY smoking_status
ORDER BY avg_risk_score DESC;

#Risk and pre-existing illness
SELECT
    pre_existing_illness,
    COUNT(*) AS customers,
    ROUND(AVG(risk_score),3) AS avg_risk_score
FROM customer_master
GROUP BY pre_existing_illness
ORDER BY avg_risk_score DESC;

#Claims by status
SELECT
    claim_status,
    COUNT(*) AS claim_count,
    ROUND(SUM(claim_amount),2) AS total_claim_amount,
    ROUND(AVG(claim_amount),2) AS avg_claim_amount
FROM claim_history
GROUP BY claim_status
ORDER BY claim_count DESC;

#Claims by product
SELECT
    p.product_type,
    COUNT(DISTINCT p.policy_id) AS policies,
    COUNT(ch.claim_id) AS claims,
    ROUND(SUM(ch.claim_amount),2) AS total_claim_amount
FROM policy_details p
LEFT JOIN claim_history ch
    ON p.policy_id = ch.policy_id
GROUP BY p.product_type
ORDER BY total_claim_amount DESC;

#Claims by region
SELECT
    c.region,
    COUNT(ch.claim_id) AS claims,
    ROUND(SUM(ch.claim_amount),2) AS total_claim_amount,
    ROUND(AVG(ch.claim_amount),2) AS avg_claim_amount
FROM claim_history ch
JOIN policy_details p
    ON ch.policy_id = p.policy_id
JOIN customer_master c
    ON p.customer_id = c.customer_id
GROUP BY c.region
ORDER BY total_claim_amount DESC;

#Fraud analysis
SELECT
    fraud_flag,
    COUNT(*) AS claim_count,
    ROUND(SUM(claim_amount),2) AS total_claim_amount
FROM claim_history
GROUP BY fraud_flag;

SELECT
    fraud_flag,
    COUNT(*) AS claim_count,
    ROUND(AVG(claim_amount),2) AS avg_claim_amount
FROM claim_history
GROUP BY fraud_flag;

#Product profitability / premium analysis
SELECT
    product_type,
    COUNT(*) AS policies,
    ROUND(SUM(coverage_amount),2) AS total_coverage,
    ROUND(SUM(annual_premium),2) AS total_premium,
    ROUND(AVG(annual_premium),2) AS avg_premium
FROM policy_details
GROUP BY product_type
ORDER BY total_premium DESC;

#Lapsed policies
SELECT
    a.region,
    COUNT(*) AS total_policies,
    SUM(CASE WHEN p.policy_end_date < CURDATE() THEN 1 ELSE 0 END) AS ended_policies
FROM policy_details p
JOIN agent_info a
    ON p.agent_id = a.agent_id
GROUP BY a.region
ORDER BY ended_policies DESC;


#Customer satisfaction
SELECT
    ROUND(AVG(satisfaction_score),2) AS avg_satisfaction,
    COUNT(*) AS total_feedback,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS anonymous_feedback
FROM customer_feedback_surveys;

#Satisfaction by region
SELECT
    c.region,
    COUNT(f.feedback_id) AS feedback_count,
    ROUND(AVG(f.satisfaction_score),2) AS avg_satisfaction
FROM customer_feedback_surveys f
JOIN customer_master c
    ON f.customer_id = c.customer_id
GROUP BY c.region
ORDER BY avg_satisfaction DESC;

CREATE OR REPLACE VIEW aegislife_risk_analysis AS
SELECT
    c.customer_id,
    c.age,
    c.gender,
    c.marital_status,
    c.occupation,
    c.region,
    c.smoking_status,
    c.pre_existing_illness,
    c.risk_score,

    p.policy_id,
    p.product_type,
    p.coverage_amount,
    p.annual_premium,
    p.policy_start_date,
    p.policy_end_date,
    p.agent_id,

    cl.claim_id,
    cl.claim_date,
    cl.claim_amount,
    cl.claim_status,
    cl.claim_type,
    cl.fraud_flag,
    cl.days_to_process

FROM customer_master c
LEFT JOIN policy_details p
    ON c.customer_id = p.customer_id
LEFT JOIN claim_history cl
    ON p.policy_id = cl.policy_id;


SELECT *
FROM aegislife_risk_analysis
LIMIT 20;

