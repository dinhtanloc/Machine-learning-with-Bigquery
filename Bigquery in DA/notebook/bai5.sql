CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.mushroom_model`
OPTIONS(model_type='RANDOM_FOREST_CLASSIFIER',
        NUM_PARALLEL_TREE = 50,
        TREE_METHOD = 'HIST',
        EARLY_STOP = TRUE,
        input_label_cols=['class']
        ) AS
SELECT * EXCEPT("veil-type")
FROM `da04-k291-423718.DA04_K294.mushrooms`

-- Đánh giá mô hình nấm
SELECT
  *
FROM
  ML.EVALUATE (MODEL `da04-k291-423718.DA04_K294.mushroom_model`, (
    SELECT *     EXCEPT(veil_type)
    FROM `da04-k291-423718.DA04_K294.mushrooms`
  ))





--Car data
CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.car_price_model`
OPTIONS(model_type='RANDOM_FOREST_REGRESSOR',
        NUM_PARALLEL_TREE = 50,
        TREE_METHOD = 'AUTO',
        EARLY_STOP = TRUE,
        input_label_cols=['Selling_Price']) AS
SELECT * EXCEPT(Car_Name)
FROM `da04-k291-423718.DA04_K294.car_data`

SELECT
  *
FROM
  ML.EVALUATE (MODEL `da04-k291-423718.DA04_K294.car_price_model`, (
    SELECT *     EXCEPT(int64_field_0, Car_Name)
    FROM `da04-k291-423718.DA04_K294.car_data`
  ))