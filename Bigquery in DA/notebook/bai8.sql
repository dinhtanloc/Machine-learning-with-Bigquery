CREATE OR REPLACE MODEL practice.airline_passengers_arima_model
OPTIONS
  (model_type = 'ARIMA_PLUS',
   time_series_timestamp_col = 'Month',
   time_series_data_col = 'passengers_in_thousands',
   data_frequency = 'MONTHLY',
   auto_arima = TRUE,
   decompose_time_series = TRUE
  ) AS
SELECT 
  CAST(Month AS DATE FORMAT 'YYYY-MM') AS Month,
  passengers_in_thousands
FROM 
  `Practice.international_airline_passengers`
ORDER BY Month;

-- Để nhận đề xuất mô hình, sử dụng câu lệnh sau:
SELECT 
  *
FROM 
  ML.ARIMA_EVALUATE(MODEL `practice.airline_passengers_arima_model`);

-- Kiểm tra hệ số ARIMA
SELECT
  *
FROM
  ML.ARIMA_COEFFICIENTS(MODEL `prjct.arima_model`);

-- Dự đoán lượng hành khách cho 6 tháng tiếp theo
SELECT
  *
FROM
  ML.FORECAST(MODEL `prjct.arima_model`,
    STRUCT(6 AS horizon, 0.8 AS confidence_level));

-- Giải thích và trực quan kết quả dự đoán
SELECT
  *
FROM
  ML.EXPLAIN_FORECAST(MODEL `prjct.arima_model`,
    STRUCT(6 AS horizon, 0.8 AS confidence_level));

-------------------------------------------------------------------


CREATE OR REPLACE MODEL Practice.daily_min_temperatures_arima_model
OPTIONS
  (model_type = 'ARIMA_PLUS',
   time_series_timestamp_col = 'Date',
   time_series_data_col = 'Temp',
   auto_arima = TRUE,
   data_frequency = 'DAILY',
   decompose_time_series = TRUE
  ) AS
SELECT *
FROM `Practice.daily_min_temperatures`
ORDER BY Date;

-- Để đánh giá mô hình, sử dụng câu lệnh sau:
SELECT *
FROM ML.ARIMA_EVALUATE(MODEL `Practice.daily_min_temperatures_arima_model`);


SELECT *
FROM ML.ARIMA_COEFFICIENTS(MODEL `Practice.daily_min_temperatures_arima_model`);


SELECT *
FROM ML.FORECAST(MODEL `Practice.daily_min_temperatures_arima_model`,
  STRUCT(365 AS horizon, 0.8 AS confidence_level));

SELECT *
FROM ML.EXPLAIN_FORECAST(MODEL `Practice.daily_min_temperatures_arima_model`,
  STRUCT(365 AS horizon, 0.8 AS confidence_level));
