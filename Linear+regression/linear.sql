CREATE OR REPLACE MODEL  --khởi tạo hoặc thay đổi mô hình, `bigquery-demo-418213.Linear_regression.house_prices` là vị trí mô hình mình muốn khởi tạo
  `bigquery-demo-418213.Linear_regression.house_prices` OPTIONS(model_type='linear_reg',
    input_label_cols = ['price'], l2_reg = 1, early_stop = false, max_iterations = 12, optimize_strategy = 'batch_gradient_descent', enable_global_explain = true) AS
SELECT
  avg_house_age,
  avg_rooms,
  avg_bedrooms, avg_income, population,
  price/100000 AS price
FROM
  `bigquery-demo-418213.Linear_regression.USA_Housing_train`

#option: phần này chứa các tùy chọn cho mô hình bao gồm:
-- model_type='linear_reg': Xác định loại mô hình, trong trường hợp này là hồi quy tuyến tính.
-- input_label_cols = ['price']: Xác định cột mục tiêu (label) mà mô hình sẽ dự đoán, trong trường hợp này là cột price.
-- l2_reg = 1: Hệ số regularization cho mô hình, ở đây là 1.
-- early_stop = false: Cho phép sớm dừng huấn luyện nếu cần.
-- max_iterations = 12: Số lượng vòng lặp tối đa để huấn luyện mô hình.
-- optimize_strategy = 'batch_gradient_descent': Chiến lược tối ưu hóa, trong trường hợp này là descent dựa trên gradient theo phương pháp batch.
-- enable_global_explain = true: Bật chức năng giải thích toàn cầu cho mô hình.
-- SELECT Phần này chỉ định cột dữ liệu từ bảng dữ liệu nguồn (bigquery-demo-418213.Linear_regression.USA_Housing_train) sẽ được sử dụng để huấn luyện mô hình. Các cột bao gồm avg_house_age, avg_rooms, avg_bedrooms, avg_income, population và price. Điều chỉnh dữ liệu cột price để chia cho 100000 (price/100000) giúp tăng độ chính xác cho việc huấn luyện mô hình


SELECT * FROM ML.TRAINING_INFO(MODEL `bigquery-demo-418213.Linear_regression.house_prices`);
xem thông tin đào tạo

SELECT * FROM ML.EVALUATE (MODEL `bigquery-demo-418213.Linear_regression.house_prices`)
xem kết quả training

SELECT * FROM ML.EVALUATE (MODEL `bigquery-demo-418213.Linear_regression.house_prices`,TABLE `bigquery-demo-418213.Linear_regression.usa_housing_eval_final`)
so sánh kết quả evaluate

SELECT * FROM ML.EVALUATE (MODEL `regression.house_prices`, (select * from `regression.usa_housing_evaluate` limit 3000))
so sánh 3000 hàng kết quả evaluate