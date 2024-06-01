-- Check data
SELECT * FROM `da04-k291-423718.DA04_K294.weather` LIMIT 5
SELECT COUNT(*) FROM `da04-k291-423718.DA04_K294.weather` LIMIT 5

-- 10000 sample, => Split sample 80 (train/valid)/20 test
--B1: Mix data into random sample, 0.8 is random_state
CREATE OR REPLACE TABLE `da04-k291-423718.DA04_K294.weather_new`
AS
SELECT *,
 CASE
  WHEN split_field < 0.8 THEN 'training'
  WHEN split_field >= 0.8 THEN 'evaluation'
 END AS split_dataframe
FROM (
    -- Create split_ field (0.1->1) to choose condition data
  SELECT * , ROUND(ABS(RAND()),1) AS split_field
  FROM `da04-k291-423718.DA04_K294.weather`
);

-- CHECK DATA
SELECT * FROM `da04-k291-423718.DA04_K294`

SELECT split_dataframe, COUNT(split_field) AS num_rows
FROM `da04-k291-423718.DA04_K294.weather_new`
GROUP BY split_dataframe


--Create model
CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.weather_linear_model`
OPTIONS(
    MODEL_TYPE='LINEAR_REG', 
    INPUT_LABEL_COLS = ['Temperature_c']
    ) AS
SELECT * --------------------Preprocessing------------
  EXCEPT (split_dataframe, split_field)
FROM 
  `da04-k291-423718.DA04_K294.weather_new`
WHERE 
  Temperature_c IS NOT NULL AND split_dataframe like 'training'



--Evaluation test sample
SELECT * FROM ML.EVALUATE(MODEL `da04-k291-423718.DA04_K294.weather_linear_model` ),
(SELECT * --------------------Preprocessing------------
  EXCEPT (split_dataframe, split_field)
FROM 
  `da04-k291-423718.DA04_K294.weather_new`
WHERE 
  Temperature_c IS NOT NULL AND split_dataframe like 'evaluation')


--Neu phan phoi chuan thi xem MAE (mean), neu phan phoi ko chuan thi se dung median
SELECT
    AVG(Temperature_c) AS mean,
    STDDEV(Temperature_c) AS std_dev_sample,
FROM 
`da04-k291-423718.DA04_K294.weather_new`
WHERE 
  Temperature_c IS NOT NULL AND split_dataframe like 'evaluation'
--Chung ta ky vong MAE se nam trong khoang (AVG/MEDIAN, STD)

SELECT
*
FROM ML.PREDICT(MODEL DA04_k286.weather_linear_model, (
  SELECT 0.79 as Humidity,
  14.3 as Wind_Speed_kmh,
  131 as Wind_Bearing_degrees,
  10.3 as Visibility_km,
  1010.15 as Pressure_millibars ,
  1 as Rain,
  'Normal' as Description
  )
);

--In ra he so
SELECT 
*
FROM 
    ML.WEIGHTS(MODEL `da04-k291-423718.DA04_K294.weather_linear_model`)

----------------------------------------------
-- Case study GemStone EDA
SELECT COUNT(*) FROM `da04-k291-423718.DA04_K294.cubic_zircona`

SELECT * FROM `da04-k291-423718.DA04_K294.cubic_zircona` LIMIT 5

--Create model
CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.cubic_zircona_model`
OPTIONS(
    MODEL_TYPE='LINEAR_REG', 
    INPUT_LABEL_COLS = ['price']
    ) AS
SELECT * --------------------Preprocessing------------
  EXCEPT (depth, int64_field_0)
FROM 
  `da04-k291-423718.DA04_K294.cubic_zircona`
WHERE 
  price IS NOT NULL AND price <=6000


--Evaluation test sample
SELECT * FROM ML.EVALUATE(MODEL `da04-k291-423718.DA04_K294.cubic_zircona_model` )

-- Minh se dung mo hinh nay de du doan 21000 vien da
SELECT AVG(price) AS mean_price, STDDEV(price) AS std_price
FROM 
  `da04-k291-423718.DA04_K294.cubic_zircona`
WHERE 
  price IS NOT NULL AND price <=6000


  --Predict
SELECT
*
FROM ML.PREDICT(MODEL `da04-k291-423718.DA04_K294.cubic_zircona_model`, (
  SELECT 1.5 as carat,
  "Fair" as cut,
  "G" as color,
  "VS2" as clarity,
  54 as table ,
  7.2 as x,
  7.1 as y,
  4.7 as z,
  )
);