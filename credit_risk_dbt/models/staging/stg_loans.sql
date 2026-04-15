with source as (
    SELECT * FROM {{ source( 'credit_risk', 'loans')}}
),

renamed as (
    SELECT
        id,
        loan_amnt,
        term,
        int_rate,
        grade,
        sub_grade,
        emp_length,
        home_ownership,
        annual_inc,
        verification_status,
        issue_d,
        issue_m,
        issue_y,
        issue_year_month,
        loan_status,
        purpose,
        addr_state,
        dti,
        fico_range_low,
        fico_range_high,
        fico_score,
        credit_score_band,
        revol_util,
        pub_rec,
        delinq_2yrs,
        is_default
    from source
)

select * from renamed