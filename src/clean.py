import pandas as pd

def clean():
    df = pd.read_csv('../data/raw/loans_sample.csv', low_memory=False)

    keep_cols = [
        'id',
        'loan_amnt',
        'term',
        'int_rate',
        'grade',
        'sub_grade',
        'emp_length',
        'home_ownership',
        'annual_inc',
        'verification_status',
        'issue_d',
        'loan_status',
        'purpose',
        'addr_state',
        'dti',
        'fico_range_low',
        'fico_range_high',
        'revol_util',
        'pub_rec',
        'delinq_2yrs',
    ]
    df = df[keep_cols]

    # fill in the gaps with 'unknown'
    df['emp_length'] = df['emp_length'].fillna('Unknown')
    # fill debt to income ratio with the median
    df['dti'] = df['dti'].fillna(df['dti'].median())
    # fill revol_util gaps with the median
    df['revol_util'] = df['revol_util'].fillna(df['revol_util'].median())

    default_statuses = ['Charged Off', 'Default', 'Late (31-120 days)', 
                    'Late (16-30 days)', 'In Grace Period']
    df['is_default'] = df['loan_status'].isin(default_statuses).astype(int)

    df['issue_d'] = pd.to_datetime(df['issue_d'])
    df['issue_m'] = df['issue_d'].dt.month
    df['issue_y'] = df['issue_d'].dt.year
    df['issue_year_month'] = df['issue_d'].dt.to_period('M')
    df['issue_year_month'] = df['issue_year_month'].astype(str)

    df['home_ownership'] = df['home_ownership'].str.lower()
    df['verification_status'] = df['verification_status'].str.lower()
    df['loan_status'] = df['loan_status'].str.lower()
    df['purpose'] = df['purpose'].str.lower()
    df['addr_state'] = df['addr_state'].str.lower()

    df['term'] = df['term'].str.strip()
    df['fico_score'] = (df['fico_range_high'] + df['fico_range_low']) / 2 

    def get_band(score):
        if score < 580: return 'poor'
        elif score < 670: return 'fair'
        elif score < 740: return 'good'
        elif score < 800: return 'very good'
        else: return 'exceptional'
    df['credit_score_band'] = df['fico_score'].apply(get_band)

    float_cols = df.select_dtypes(include='float64').columns
    df[float_cols] = df[float_cols].round(2)

    assert df['is_default'].isin([0,1]).all(), "is_default has unexpected values"
    assert df['loan_amnt'].isnull().sum() == 0, "nulls in loan_amnt"
    assert df['fico_score'].isnull().sum() == 0, "nulls in fico_score"
    assert len(df) > 0, "DataFrame is empty"
    print(f"Clean complete. Rows: {len(df)}, Defaults: {df['is_default'].sum()}")

    df.to_csv('../data/clean/loans_clean.csv', index=False)

clean()
