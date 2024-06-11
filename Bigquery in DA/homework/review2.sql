SELECT Species, COUNT(*) FROM `da04-k291-423718.DA04_K294.iris` GROUP BY Species

CREATE OR REPLACE TABLE `da04-k291-423718.DA04_K294.iris_new`
AS
SELECT *,
 CASE
  WHEN split_field < 0.9 THEN 'training'
  WHEN split_field >= 0.9 THEN 'evaluation'
 END AS split_dataframe
FROM (
    -- Create split_ field (0.1->1) to choose condition data
  SELECT * , ROUND(ABS(RAND()),1) AS split_field
  FROM `da04-k291-423718.DA04_K294.iris`
);

CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.model_logistic_iris`
OPTIONS(
  model_type='logistic_reg', 
  input_label_cols=['Species'],
  DATA_SPLIT_METHOD='AUTO_SPLIT',
  CATEGORY_ENCODING_METHOD='ONE_HOT_ENCODING'
  ) AS
SELECT
  SepalLengthCm,
  SepalWidthCm,
  PetalLengthCm,
  PetalWidthCm,
  Species
FROM
  `da04-k291-423718.DA04_K294.iris_new`
WHERE split_dataframe like 'training'

CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.model_boostedtree_iris`
OPTIONS(
  model_type='boosted_tree_classifier', 
  input_label_cols=['Species'],
  CATEGORY_ENCODING_METHOD='ONE_HOT_ENCODING'
  ) AS
SELECT
  SepalLengthCm,
  SepalWidthCm,
  PetalLengthCm,
  PetalWidthCm,
  Species
FROM
  `da04-k291-423718.DA04_K294.iris_new`
WHERE split_dataframe like 'training'


---------------------------------------
SELECT * FROM ML.EVALUATE(MODEL `da04-k291-423718.DA04_K294.model_logistic_iris` ),
(SELECT * --------------------Preprocessing------------
  EXCEPT (split_dataframe, split_field)
FROM 
  `da04-k291-423718.DA04_K294.iris_new`
WHERE 
  split_dataframe like 'evaluation')

SELECT * FROM ML.EVALUATE(MODEL `da04-k291-423718.DA04_K294.model_boostedtree_iris` ),
(SELECT * --------------------Preprocessing------------
  EXCEPT (split_dataframe, split_field)
FROM 
  `da04-k291-423718.DA04_K294.iris_new`
WHERE 
  split_dataframe like 'evaluation')