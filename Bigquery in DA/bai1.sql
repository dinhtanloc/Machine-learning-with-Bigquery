SELECT count(*)
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
LIMIT 1000


SELECT
  totals.transactions,
  device.operatingSystem,
  device.isMobile,
  geoNetwork.country,
  totals.pageviews
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20160801' AND '20170630' AND RAND()<0.01 -- chon cac bang gas_station*'...' vand '..., bien nay chua phan cuoi cua ten bang
LIMIT 10
--------------------------- CREATE MODEL ---------------------------
-- CREATE MODEL statement: neu chung ta da co model voi ten da ton tai thi se tra ve loi
-- CREATE OR REPLACE MODEL: neu chung ta da co thi ghi de model len
-- CREATE MODEL IF NOT EXISTS: neu chua co thi tao, neu co roi thi dung cai cu

--------------------------- standardSQL ---------------------------
-- {CREATE MODEL | CREATE MODEL IF NOT EXISTS | CREATE OR REPLACE MODEL} `project.dataset.model_name` [OPTIONS(model_option_list)]
--[AS query_statement]

--model_optuin_list:
--MODEL_TYPE= {'LINEAR_REG', 'LOGISTIC_REG',...}
--INPUT_LABEL_COLS = y train
--MAX_ITERATIONS = epochs default 20
--EARLY_STOP={TRUE|FALSE} default TRUE
--DATA_SPLIT_METHOD ={'AUTO_SPLIT'|'RANDOM'| 'CUSTOM'| 'SEQ'|'NO_SPLIT'} 
-- CATEGORY_ENCODING_METHOD={'ONE_HOT_ENCODING','DUMMY_ENCODING'}

--------------------------- ML.PREDICT ---------------------------
-- ML.PREDICT (MODEL model_name, {TABLE table_name | (query_statement)})


------------------USECASE project--------------------------
CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.trans_model`
OPTIONS(MODEL_TYPE='LOGISTIC_REG', INPUT_LABEL_COLS = ['label']) AS
SELECT  --------------------Preprocessing------------
  IF(totals.transactions is NULL, 0, 1) as label,
  IFNULL(device.operatingSystem, "") as os,
  device.isMobile as isMobile,
  IFNULL(geoNetwork.country,"") as country,
  IFNULL(totals.pageviews,0) as pageviews
FROM 
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE 
  _TABLE_SUFFIX BETWEEN '20160801' AND '20170630'


----------------EVALUATE.VALUE---------------------------
SELECT
     *
FROM
 ML.EVALUATE(MODEL `bqml_tutorial.sample_model`, (
SELECT
    IF(totals.transactions is NULL, 0, 1) as label,
  IFNULL(device.operatingSystem, "") as os,
  device.isMobile as isMobile,
  IFNULL(geoNetwork.country,"") as country,
  IFNULL(totals.pageviews,0) as pageviews
FROM 
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE 
  _TABLE_SUFFIX BETWEEN '20160801' AND '20170630'
    )
 )

 ---------------ML.PREDICT------------------------
 SELECT
    country,
    SUM(predicted_label) as total_predicted_purchases
FROM
    ML.PREDICT(MODEL `bqml_tutorial.sample_model`,(
        SELECT
            IF(totals.transactions is NULL, 0, 1) as label,
            IFNULL(device.operatingSystem, "") as os,
            device.isMobile as isMobile,
            IFNULL(geoNetwork.country,"") as country,
            IFNULL(totals.pageviews,0) as pageviews
        FROM 
        `bigquery-public-data.google_analytics_sample.ga_sessions_*`
        WHERE 
        _TABLE_SUFFIX BETWEEN '20160801' AND '20170630'
    ))
GROUP BY country
ORDER BY total_predicted_purchases DESC 
LIMIT 10