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

