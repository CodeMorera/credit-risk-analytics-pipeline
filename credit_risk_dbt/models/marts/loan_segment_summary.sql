WITH source AS (
    SELECT * FROM {{ref('stg_loans')}}
),
loan_segment_summary AS (
    SELECT
        purpose,
        grade,
        COUNT(*) AS total_loans,
        ROUND(SUM(loan_amnt),2) AS total_balance,
        SUM(is_default) AS total_defaults,
        ROUND(CAST(SUM(is_default) AS DOUBLE)/COUNT(*),4) AS default_rate,
        ROUND(AVG(int_rate), 2) AS avg_interest_rate
    FROM 
        source
    GROUP BY 
            purpose, grade
)
SELECT * FROM loan_segment_summary
ORDER BY default_rate DESC

    