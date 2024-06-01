CREATE OR REPLACE MODEL `da04-k291-423718.DA04_K294.titanic_logistic_model`
OPTIONS(
    MODEL_TYPE= 'LOGISTIC_REG',
    AUTO_CLASS_WEIGHTS =TRUE,
    INPUT_LABEL_COLS = ['Survived']
) AS
SELECT 
    Pclass, Sex, Age, SibSp, Parch, Fare, Embarked, Survived
FROM
`da04-k291-423718.DA04_K294.titanic_train`


--Check if Imbalanced
SELECT Survived ,COUNT(*)
FROM `da04-k291-423718.DA04_K294.titanic_train`
GROUP BY Survived