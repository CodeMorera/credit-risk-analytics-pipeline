CREATE EXTERNAL TABLE IF NOT EXISTS loans (
  id                  STRING,
  loan_amnt           DOUBLE,
  term                STRING,
  int_rate            DOUBLE,
  grade               STRING,
  sub_grade           STRING,
  emp_length          STRING,
  home_ownership      STRING,
  annual_inc          DOUBLE,
  verification_status STRING,
  issue_d             STRING,
  loan_status         STRING,
  purpose             STRING,
  addr_state          STRING,
  dti                 DOUBLE,
  fico_range_low      DOUBLE,
  fico_range_high     DOUBLE,
  revol_util          DOUBLE,
  pub_rec             DOUBLE,
  delinq_2yrs         DOUBLE,
  is_default          INT,
  issue_m             INT,
  issue_y             INT,
  issue_year_month    STRING,
  fico_score          DOUBLE,
  credit_score_band   STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 's3://credit-risk-pipeline-cmorera/cleaned/'
TBLPROPERTIES ('skip.header.line.count'='1');