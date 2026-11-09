# Home Credit Default Risk Analysis

## Project Overview

This project analyzes the **Home Credit Default Risk** dataset to predict which loan applicants are more likely to experience repayment difficulty.

The business challenge is to improve credit-risk decisions without unnecessarily rejecting applicants who may be able to repay successfully. I developed an end-to-end analytics workflow that includes exploratory analysis, feature engineering, predictive modeling, model explainability, fairness analysis, and deployment recommendations.

The final recommendation is to use the model as a **risk-ranking and decision-support tool**, rather than as a fully automated approval or denial system.

---

## Key Results

The final **XGBoost classification model** provided the strongest predictive performance among the models evaluated.

| Metric | Result |
|---|---:|
| Training AUC | 0.751 |
| 3-Fold Cross-Validated AUC | **0.748** |
| Kaggle Public AUC | 0.746 |
| Kaggle Private AUC | 0.738 |
| Business-Cost Decision Threshold | **0.23** |
| Precision at Selected Threshold | 0.340 |
| Recall at Selected Threshold | 0.174 |

The similarity between training, cross-validation, and Kaggle performance suggests that the model's risk-ranking ability generalizes reasonably well to unseen data.

---

## Business Problem

Home Credit serves borrowers who may have limited traditional credit histories. This creates a tradeoff between:

- reducing losses from applicants who may experience repayment difficulty, and
- maintaining access to credit for applicants who are likely to repay successfully.

Approximately **8.1% of applicants in the training data experienced repayment difficulty**, making the target highly imbalanced.

Because of this imbalance, overall accuracy alone would be misleading. The analysis therefore emphasizes **AUC and business-cost tradeoffs** when evaluating model performance.

---

## Data Preparation and Feature Engineering

The project includes a reusable preparation script that applies the same transformations to both training and test datasets.

Key engineered features include:

- Applicant age in years
- Employment history in years
- Age groups
- Credit-to-income ratio
- Annuity-to-income ratio
- Credit-to-annuity ratio
- Missing-value indicators for external credit variables
- Total missing-value count

The preparation process also converts the special `DAYS_EMPLOYED = 365243` value to missing data and validates that training and test datasets contain consistent predictor columns.

**Script:** [`data_preparation.R`](data_preparation.R)

---

## Modeling

Several classification approaches were evaluated:

- Majority-class benchmark
- Logistic regression
- Random forest
- XGBoost
- Class-weighted XGBoost

Model selection focused on **3-fold cross-validated AUC** because of the highly imbalanced outcome.

| Model | Cross-Validated AUC |
|---|---:|
| Majority-Class Benchmark | 0.500 |
| Logistic Regression | 0.724 |
| Random Forest | 0.723 |
| XGBoost | **0.748** |
| Class-Weighted XGBoost | 0.747 |

XGBoost produced the strongest performance. Class weighting did not improve discrimination, so the standard XGBoost model was selected.

Hyperparameters were tuned using randomized search on a 5,000-row sample with 3-fold cross-validation before training the final model on the full dataset.

**Notebook:** [`Modeling.qmd`](Modeling.qmd)

---

## Model Explainability

SHAP analysis was used to identify which predictors had the greatest influence on the final model.

The most influential features were:

1. `EXT_SOURCE_2`
2. `EXT_SOURCE_3`
3. `CREDIT_ANNUITY_RATIO`
4. `EXT_SOURCE_1`
5. `EMPLOYMENT_YEARS`

The results show that external credit-risk information is the strongest source of predictive signal, while affordability and employment history provide additional information.

SHAP was also used to translate individual predictions into understandable explanations that could support underwriting review and adverse-action communication.

---

## Decision Threshold and Business Use

Instead of automatically using a 0.50 classification cutoff, I evaluated thresholds using estimated consumer-lending business costs.

The resulting **business-cost threshold was 0.23**.

At this threshold:

- Precision = **34.0%**
- Recall = **17.4%**

The model is therefore better suited for **risk ranking and prioritizing enhanced review** than for automatically rejecting applicants.

A recommended workflow would use higher model scores to trigger additional underwriting attention while keeping human judgment and existing lending policies in the decision process.

---

## Fairness Analysis

Approval outcomes were evaluated across gender and education groups at the selected threshold.

### Gender

- Female approval rate: **96.5%**
- Male approval rate: **94.7%**
- Difference: approximately **1.8 percentage points**

### Education

Approval rates ranged from approximately **94.5% to 97.3%** across education groups.

These results are an initial fairness diagnostic rather than proof that the model is fair. A production system would require additional monitoring of error rates, calibration, proxy effects, and demographic outcomes.

---

## Model Card and Deployment Recommendation

A full model card documents:

- Intended use
- Predictive performance
- Decision-threshold analysis
- SHAP explainability
- Adverse-action mapping
- Fairness analysis
- Limitations and risks
- Deployment recommendations

The final recommendation is to **pilot the model with human oversight** before broader deployment.

The pilot should measure whether model-assisted underwriting:

- reduces credit losses,
- improves review efficiency,
- maintains acceptable approval outcomes,
- remains accurate across applicant groups, and
- provides understandable reasons for higher-risk predictions.

**Model Card:** [`model_card.qmd`](model_card.qmd)

---

## Exploratory Data Analysis

The exploratory analysis was used to understand repayment difficulty, missing data, applicant characteristics, and financial relationships before modeling.

The EDA informed several of the engineered variables later used during model development.

**Notebook:** [`eda.qmd`](eda.qmd)

---

## Repository Contents

| File | Purpose |
|---|---|
| `eda.qmd` | Exploratory data analysis |
| `data_preparation.R` | Reusable feature engineering and preparation |
| `Modeling.qmd` | Model comparison, tuning, validation, and Kaggle results |
| `model_card.qmd` | Explainability, threshold analysis, fairness, risks, and deployment guidance |
| `HomeCredit_columns_description.csv` | Dataset variable descriptions |
| `.gitignore` | Prevents large datasets and generated artifacts from being committed |

Large source datasets, prepared datasets, generated HTML files, and submission files are maintained locally rather than committed to the repository.

---

## Skills Demonstrated

This project demonstrates experience with:

- R
- Data cleaning and feature engineering
- Exploratory data analysis
- Logistic regression
- Random forest
- XGBoost
- Cross-validation
- Hyperparameter tuning
- Classification under class imbalance
- ROC AUC evaluation
- SHAP explainability
- Fairness analysis
- Business-oriented decision thresholds
- Git and GitHub
- Quarto
- Translating technical results into business recommendations

---

## Business Takeaway

The strongest model improved risk discrimination from a **0.50 benchmark AUC to approximately 0.748 cross-validated AUC** while maintaining similar performance on unseen Kaggle data.

The most appropriate business use is not broader rejection of applicants. Instead, the model can help lenders **rank risk more effectively and focus underwriting attention where it is most valuable**.

That combination of predictive performance, explainability, fairness monitoring, and human oversight provides a practical path toward responsible model deployment.

---

## Author

**Joey Cheek**  
MSBA — IS 6812 Practice Project