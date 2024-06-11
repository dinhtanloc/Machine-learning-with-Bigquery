-- Tạo mô hình logistic regression cho nhận dạng chữ số viết tay
CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.digits_logistic_model`
OPTIONS(model_type='LOGISTIC_REG',
        auto_class_weights=TRUE,
        input_label_cols=['int64_field_16']) AS
SELECT * EXCEPT(int64_field_0)
FROM `da04-k291-423718.DA04_K294.penbased-5an-nn`

-- Đánh giá mô hình logistic regression cho nhận dạng chữ số viết tay
SELECT
  *
FROM
  ML.EVALUATE (MODEL `da04-k291-423718.DA04_K294.digits_logistic_model`, (
    SELECT * EXCEPT(int64_field_0)
    FROM `da04-k291-423718.DA04_K294.penbased-5an-nn`
  ))


-- Tạo mô hình PCA cho nhận dạng chữ số viết tay
CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.digits_PCA`
OPTIONS(MODEL_TYPE='PCA',
        PCA_EXPLAINED_VARIANCE_RATIO=0.95) AS
SELECT * EXCEPT(int64_field_16, int64_field_0) -- Ko đưa biến mục tiêu vào dữ liệu giảm chiều vì mô hình có thể học cách cheat và bị overfitting
FROM `da04-k291-423718.DA04_K294.penbased-5an-nn`

--Dùng Logistic trên tập dữ liệu đã được giảm chiều
CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.digits_PCA_logistic`
OPTIONS(MODEL_TYPE='LOGISTIC_REG',
        AUTO_CLASS_WEIGHTS = TRUE,
        INPUT_LABEL_COLS=['int64_field_16']) AS
SELECT
  *
FROM 
    ML.PREDICT(
      MODEL `da04-k291-423718.DA04_K294.digits_PCA`,
      (
      SELECT * EXCEPT(int64_field_0)
      FROM `da04-k291-423718.DA04_K294.penbased-5an-nn`
      )
);

-- Đánh giá mô hình logistic regression sau PCA
SELECT
  *
FROM
  ML.EVALUATE (MODEL `da04-k291-423718.DA04_K294.digits_PCA_logistic`, (
    SELECT *
    FROM `da04-k291-423718.DA04_K294.penbased-5an-nn`
    EXCEPT(int64_field_0)
  ))

