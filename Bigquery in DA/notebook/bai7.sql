CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.point2D_clustering`
OPTIONS(model_type='kmeans', num_clusters=3)
AS
SELECT *
FROM `da04-k291-423718.DA04_K294.xclara`


SELECT * FROM ML.EVALUATE(MODEL, `da04-k291-423718.DA04_K294.point2D_clustering`)


SELECT *
FROM ML.PREDICT(MODEL  `da04-k291-423718.DA04_K294.point2D_clustering`,
    (
        SELECT 10 AS V1, 10 AS V2
        UNION ALL
        SELECT 30, 60
        UNION ALL
        SELECT 60, -20
    )
)

---------------------------------------------------------------------
CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.ageinc_clustering`
OPTIONS(model_type='kmeans', num_clusters=4)
AS
SELECT income_K, age
FROM `da04-k291-423718.DA04_K294.ageinc_g`


SELECT * FROM ML.EVALUATE(MODEL, `da04-k291-423718.DA04_K294.ageinc_clustering`)

SELECT *
FROM ML.PREDICT(MODEL  `da04-k291-423718.DA04_K294.point2D_clustering`,
    (
        SELECT income_K, age
        FROM `da04-k291-423718.DA04_K294.ageinc_g`
    )
);

-- Áp dụng ML_MIN_MAX_SCALER và xây dựng mô hình k-means clustering
CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.ageinc_clustering_mm`
OPTIONS(model_type='kmeans', num_clusters=4) AS
SELECT 
  ML.MIN_MAX_SCALER(income) OVER() AS income_mm,
  ML.MIN_MAX_SCALER(age) OVER() AS age_mm
FROM 
  `da04-k291-423718.DA04_K294.ageinc_g`;


-- Sử dụng mô hình k-means clustering để phân cụm khách hàng
SELECT * FROM ML.PREDICT(
  MODEL `da04-k291-423718.DA04_K294.ageinc_clustering_mm`,
  (
    SELECT 
      ML.MIN_MAX_SCALER(income) OVER() AS income_mm,
      ML.MIN_MAX_SCALER(age) OVER() AS age_mm,
      age, 
      income
    FROM  `da04-k291-423718.DA04_K294.ageinc_g`
  )
);

-- Dự đoán cụm khách hàng dựa trên thu nhập và tuổi
SELECT * FROM ML.PREDICT(
  MODEL 'da04-k291-423718.DA04_K294.ageinc_clustering',
  (
    SELECT 100.0 AS income_K, 40 AS age
    UNION ALL
    SELECT 80.0, 27
    UNION ALL
    SELECT 55.0, 50
  )
);

-- Dựa vào hình ảnh bạn đã gửi, hai chỉ số được đề cập là **Davies-Bouldin index** và **Mean squared distance**. Đây là hai chỉ số quan trọng để đánh giá chất lượng của thuật toán phân cụm:

-- - **Davies-Bouldin index**: Chỉ số này càng **thấp** thì chất lượng phân cụm càng **tốt**, vì nó cho thấy sự phân tách rõ ràng giữa các cụm.
-- - **Mean squared distance**: Chỉ số này càng **thấp** thì chất lượng phân cụm càng **tốt**, vì nó cho thấy các điểm dữ liệu trong mỗi cụm được nhóm chặt chẽ với nhau.

-- Khi các chỉ số này đạt giá trị thấp, bạn có thể tự tin rằng mô hình phân cụm của mình đang hoạt động hiệu quả. Đối với Davies-Bouldin index, giá trị **0.4785** và Mean squared distance là **0.255** là những kết quả khá tốt, cho thấy mô hình phân cụm của bạn có chất lượng cao.

