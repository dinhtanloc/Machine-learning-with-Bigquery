CREATE OR REPLACE MODEL Practice.stroke_dnn_model
OPTIONS(model_type='DNN_CLASSIFIER',
        auto_class_weights=TRUE,
        ACTIVATION_FN = 'SIGMOID',
        input_label_cols=['stroke'])
AS
SELECT *
FROM Practice.heart_stroke
EXCEPT(int64_field_0, id, Residence_type);



-- Đánh giá mô hình
SELECT 
    * 
FROM
ML.EVALUATE( MODEL Practice.stroke_dnn_model,(
    SELECT *
    EXCEPT(int64_field_0,id,Residence_type)
     FROM Practice.heart_stroke
))

SELECT *
FROM ML.PREDICT(MODEL 'Practice.stroke_dnn_model', (
    SELECT "Male" as gender,
           26 as age,
           0 as hypertension,
           0 as heart_disease,
           False as ever_married,
           "Private" as work_type,
           143.33 as avg_glucose_level,
           22.4 as bmi,
           "formerly smoked" as smoking_status
))




------------------------------------------------------------------------------------------
CREATE OR REPLACE MODEL Practice.mobile_dnn_model
OPTIONS(model_type='DNN_CLASSIFIER', input_label_cols=['price_range'])
AS
SELECT *
EXCEPT(id)
FROM Practice.mobile_train;


-- Đánh giá mô hình
SELECT *
FROM ML.EVALUATE(MODEL 'Practice.mobile_dnn_model', (
    SELECT *
    EXCEPT(id)
    FROM Practice.mobile_train
))


-- New prediction
SELECT *
FROM ML.PREDICT(MODEL 'Practice.mobile_dnn_model', (
    SELECT * EXCEPT(id)
    FROM my-project-11012022.Practice.mobile_test
))
