with source as (
    SELECT * FROM {{ ref('stg_loans')}}
),
borrower_risk_summary AS (
    SELECT
    credit_score_band,
    grade,
    COUNT(*) AS total_loans,
    SUM(is_default) AS total_defaults,
    ROUND(CAST(SUM(is_default)AS double) / COUNT(*), 4) AS default_rate,
    ROUND(AVG(int_rate),2) AS avg_interest_rate,
    ROUND(AVG(loan_amnt),2) AS avg_loan_amount
    FROM source
    GROUP BY credit_score_band, grade
)
SELECT * FROM borrower_risk_summary