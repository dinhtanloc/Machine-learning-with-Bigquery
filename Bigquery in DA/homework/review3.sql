--B1 Check data
SELECT * FROM `da04-k291-423718.DA04_K294.hack_data` LIMIT 5;

SELECT COUNT(*) FROM `da04-k291-423718.DA04_K294.hack_data` LIMIT 5;

--B2 Tạo model, mục tiêu dò xem K=2, K=3 nào tối uue hoen
CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.hacker_clustering_model`
OPTIONS(model_type='kmeans', num_clusters=2) AS

SELECT
  Session_Connection_Time,
  Bytes_Transferred,
  Kali_Trace_Used,
  Servers_Corrupted,
  Pages_Corrupted,
  WPM_Typing_Speed
FROM
  `da04-k291-423718.DA04_K294.hack_data`;


CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.hacker_clustering_model`
OPTIONS(model_type='kmeans', num_clusters=3) AS

SELECT
  Session_Connection_Time,
  Bytes_Transferred,
  Kali_Trace_Used,
  Servers_Corrupted,
  Pages_Corrupted,
  WPM_Typing_Speed
FROM
  `da04-k291-423718.DA04_K294.hack_data`;

--  Check xem Error nào nhỏ hơn thì ăn, còn index Double thì nào nhỏ hơn thì càng phân biệt ( nó ko có ý nghĩa trog lựa chọn mô hình có K nào sẽ tốt hơn)
SELECT * FROM ML.EVALUATE(MODEL `da04-k291-423718.DA04_K294.hacker_clustering_model`);

SELECT CENTROID_ID, * FROM ML.PREDICT(MODEL `da04-k291-423718.DA04_K294.hacker_clustering_model`,(
  SELECT * FROM `da04-k291-423718.DA04_K294.hack_data`
));