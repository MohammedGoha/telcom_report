WITH customer_features AS (
    SELECT 
        customerID,
        Contract,
        tenure,
        MonthlyCharges,
        TotalCharges,
        -- Create segment logic here using CASE WHEN
        CASE 
            WHEN tenure <= 12 THEN 'New'
            WHEN tenure <= 48 THEN 'Established'
            ELSE 'Veteran'
        END as tenure_segment,
        CASE 
            WHEN MonthlyCharges > 80 THEN 'High'
            ELSE 'Low'
        END as spend_tier,
        CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END as churn_flag
    FROM telco_churn
    WHERE TotalCharges IS NOT NULL  
)
SELECT 
    Contract,
    tenure_segment,
    spend_tier,
    SUM(churn_flag) as churned_customers,
    COUNT(*) as total_customers,
    ROUND(100.0 * SUM(churn_flag) / COUNT(*), 2) as churn_rate_pct
FROM customer_features
GROUP BY 1, 2, 3
ORDER BY churn_rate_pct DESC;