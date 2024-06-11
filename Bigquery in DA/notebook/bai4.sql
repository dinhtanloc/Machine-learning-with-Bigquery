--Understanding data
SELECT COUNT(year)
FROM bigquery-public-data.samples.natality
LIMIT 1000

SELECT COUNT(weight_pounds)
FROM bigquery-public-data.samples.natality
WHERE RAND() < 0.001
LIMIT 1000

-- Tạo mô hình

CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.natality_boosted_model`
OPTIONS
(model_type='BOOSTED_TREE_REGRESSOR',
input_label_cols=['weight_pounds' ]) AS
SELECT weight_pounds,
is_male,
gestation_weeks,
mother_age,
CAST(mother_race AS string) AS mother_race
FROM `bigquery-public-data.samples.natality`
WHERE weight_pounds IS NOT NULL AND RAND() < 0.001

--Evaluate
SELECT
*
FROM
ML.EVALUATE (MODEL `da04-k291-423718.DA04_K294.natality_boosted_model`, (
SELECT weight_pounds,
is_male,
gestation_weeks,
mother_age,
CAST(mother_race AS string) AS mother_race
FROM `bigquery-public-data.samples.natality`
WHERE weight_pounds IS NOT NULL AND RAND() < 0.001
))



-- Churn customer data
-- Create model Boosted Tree instead Logistic regression
CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.churn_boostedtree_model`
OPTIONS(model_type='BOOSTED_TREE_CLASSIFIER',
        auto_class_weights = TRUE,
        EARLY_STOP = TRUE,
        input_label_cols=['Exited']) AS
SELECT * EXCEPT(RowNumber, CustomerId, Surname)
FROM `da04-k291-423718.DA04_K294.customer_churn`


-- Đánh giá mô hình
SELECT
*
FROM
ML.EVALUATE (MODEL `da04-k291-423718.DA04_K294.churn_boostedtree_model`, (
SELECT * EXCEPT (RowNumber, CustomerId, Surname)
FROM `da04-k291-423718.DA04_K294.customer_churn`

))

SELECT
*
FROM ML.PREDICT(MODEL `da04-k291-423718.DA04_K294.churn_boostedtree_model`, (
  SELECT
    "France" AS Geography,
    600 AS CreditScore,
    "Male" AS Gender,
    40 AS Age,
    3 AS Tenure,
    60000 AS Balance,
    2 AS NumOfProducts,
    "Yes" AS HasCrCard,
    "Yes" AS IsActiveMember,
    50000 AS EstimatedSalary
  )
);
