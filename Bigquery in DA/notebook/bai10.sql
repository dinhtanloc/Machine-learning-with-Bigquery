CREATE OR REPLACE MODEL `Practice.natality_wide_deep_model`
OPTIONS
  (model_type='DNN_LINEAR_COMBINED_REGRESSOR',
   input_label_cols=['weight_pounds']) AS
SELECT
  is_male,
  gestation_weeks,
  mother_age,
  CAST(mother_race AS STRING) AS mother_race
FROM `bigquery-public-data.samples.natality`
WHERE weight_pounds IS NOT NULL AND RAND() < 0.801

SELECT *
FROM ML.PREDICT(MODEL "Practice.natality_wide_deep_model", (
    SELECT is_male, gestation_weeks, mother_age, CAST(mother_race AS STRING) AS mother_race
    FROM 'bigquery-public-data.samples.natality'
    WHERE state = "NY" AND RAND() < 0.00001
))


-------------------------------------

CREATE OR REPLACE MODEL Practice.breast_cancer_model
OPTIONS(model_type='DNN_LINEAR_COMBINED_CLASSIFIER', input_label_cols=['diagnosis'])
AS
SELECT *
EXCEPT(id)
FROM Practice.breast_cancer_new;


SELECT *
FROM ML.EVALUATE(MODEL Practice.breast_cancer_model, (
    SELECT *
    EXCEPT(id)
    FROM my-project-11012022.Practice.breast_cancer_new
))
