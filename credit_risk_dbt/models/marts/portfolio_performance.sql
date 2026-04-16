WITH source AS (
    SELECT * from {{ref('stg_loans')}}
    ),
portfolio_performance AS (
    SELECT
        issue_year_month,
        COUNT(*) AS total_loans,
        ROUND(SUM(loan_amnt),2) AS total_portfolio_balance,
        ROUND(AVG(int_rate), 2) AS avg_interest_rate,
        ROUND(AVG(loan_amnt),2) AS avg_loan_amount
    FROM
        source
    GROUP BY
        issue_year_month
),
portfolio_balance AS (
    SELECT
        issue_year_month,
        total_loans,
        total_portfolio_balance,
        avg_interest_rate,
        avg_loan_amount,
        SUM(total_portfolio_balance) OVER (ORDER BY issue_year_month) AS running_portfolio_balance
    FROM
        portfolio_performance
)
SELECT * FROM portfolio_balance
ORDER BY issue_year_month