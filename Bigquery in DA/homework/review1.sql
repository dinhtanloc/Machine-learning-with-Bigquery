CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.height_model`
OPTIONS (
  MODEL_TYPE='LINEAR_REG',
  INPUT_LABEL_COLS=['height'],
  DATA_SPLIT_METHOD='AUTO_SPLIT',
  CATEGORY_ENCODING_METHOD='ONE_HOT_ENCODING') AS
SELECT
  height,
  weight,
  age,
  bmi,
  CASE WHEN gender = 'M' THEN 1 ELSE 0 END AS gender
FROM
  `da04-k291-423718.DA04_K294.Obesity_data_500MF - Obesity_data_500MF`;

SELECT
  *
FROM
  ML.EVALUATE(MODEL `da04-k291-423718.DA04_K294.height_model`);


SELECT
  predicted_height
FROM
  ML.PREDICT(MODEL `da04-k291-423718.DA04_K294.height_model`,
    (
      SELECT
        58 AS weight,
        30 AS age,
        23.2 AS bmi,
        1 AS gender -- gender = 'M' is represented as 1
    ));
