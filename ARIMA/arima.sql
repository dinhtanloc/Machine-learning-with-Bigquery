CREATE OR REPLACE TABLE `bq-ml-332311.arima.istanbul_clean` AS SELECT
  PARSE_TIMESTAMP("%d.%m.%Y", DateTime) AS parsed_date, AvgHumidity
  FROM
   `bq-ml-332311.arima.istanbul`
   
-------------------------------- CHECK MISSING VALUES----------------------------------------
  
SELECT
  AvgHumidity
 
FROM
   `bq-ml-332311.arima.istanbul_clean`
ORDER BY AvgHumidity ASC

----------------------------------- CHECK DATE MISSING--------------------------------------

WITH Date_Range AS 
-- anchor for date range 
(
SELECT MIN(parsed_date) as starting_date,
MAX(parsed_date) AS ending_date
FROM `bq-ml-332311.arima.istanbul_clean`
),
day_series AS 
-- anchor to get all the dates within the range
(
SELECT *
FROM Date_Range
,UNNEST(GENERATE_TIMESTAMP_ARRAY(starting_date, ending_date, INTERVAL 1 DAY)) AS days
-- GENERATE all the dates between starting_date and ending_date
)
SELECT  
day_series.days,
original_table.AvgHumidity
FROM day_series
-- do a left join on the source table 
LEFT JOIN `bq-ml-332311.arima.istanbul_clean` AS original_table ON (original_table.parsed_date)= day_series.days
-- only want the records where data is not available or in other words empty/missing 
WHERE original_table.AvgHumidity IS NULL

--------------------------------MODEL CREATION--------------------------------

CREATE OR REPLACE MODEL arima.weather_forecast
OPTIONS
  (model_type = 'ARIMA_PLUS',
   time_series_timestamp_col = 'parsed_date',
   time_series_data_col = 'AvgHumidity'
  ) AS
SELECT
  *
FROM
  `bq-ml-332311.arima.istanbul_clean` ORDER BY parsed_date LIMIT 3531
  
--------------------------------MODEL EVALUATION--------------------------------

select * from (SELECT
  *
FROM
  ml.evaluate(MODEL `arima.weather_forecast`,
    TABLE `bq-ml-332311.arima.istanbul_clean` ,
    STRUCT(FALSE AS PERFORM_AGGREGATION,
      0.9 AS CONFIDENCE_LEVEL,
     365 AS HORIZON
      ) )) 
      where forecasted_AvgHumidity is not null order by parsed_date
	  
-- 	  arima_evaluate
SELECT
  *
FROM
  ml.arima_evaluate(MODEL `arima.weather_forecast`,
    STRUCT( FALSE AS show_all_candidate_models ) )
	  
-------------------------------- ML.FORECAST--------------------------------

SELECT
 *
FROM
 ML.FORECAST(MODEL arima.weather_forecast,
             STRUCT(10 AS horizon, 0.9 AS confidence_level))
	  

--------------------------------DETECT ANOMALIES--------------------------------

SELECT
  *
FROM
  ML.DETECT_ANOMALIES(MODEL arima.weather_forecast,
    STRUCT(0.9 AS anomaly_prob_threshold) )

-------------------------------- ARIMA_COEFFICIENTS--------------------------------

SELECT
 *
FROM
 ML.ARIMA_COEFFICIENTS(MODEL arima.weather_forecast)	
 
SELECT
 *
FROM
 ML.EXPLAIN_FORECAST(MODEL arima.weather_forecast)	