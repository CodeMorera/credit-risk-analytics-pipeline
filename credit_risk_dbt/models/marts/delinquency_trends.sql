with source as (
    SELECT * from {{ref('stg_loans')}}
),
delinquency_totals as (
    SELECT
        issue_year_month,
        COUNT(*) AS total_loans,
        SUM(is_default) as delinquent_loans,
        ROUND(CAST(SUM(is_default) AS DOUBLE) / COUNT(*),4) AS delinquency_rate
    FROM 
        source
    GROUP BY
        issue_year_month
),

with_running_total AS(
    SELECT
        issue_year_month,
        total_loans,
        delinquent_loans,
        delinquency_rate,
        SUM(delinquent_loans) OVER (ORDER BY issue_year_month) AS running_delinquency
    FROM delinquency_totals
)
SELECT * FROM with_running_total
Order BY issue_year_month
