# Home Credit Data Preparation
# Load packages needed for data preparation.

library(readr)
library(dplyr)

# Load the application training and test datasets.

train <- read_csv("application_train.csv")
test <- read_csv("application_test.csv")


# Create demographic features based on EDA findings.
# DAYS_BIRTH and DAYS_EMPLOYED are stored as day counts.
# DAYS_EMPLOYED = 365243 is a special placeholder value, so convert it to NA first.

prepare_demographic_features <- function(data) {

  data <- data %>%
    mutate(
      AGE_YEARS = -DAYS_BIRTH / 365.25,

      AGE_GROUP = cut(
        AGE_YEARS,
        breaks = c(20, 30, 40, 50, 60, 70),
        labels = c("20-29", "30-39", "40-49", "50-59", "60-69"),
        include.lowest = TRUE,
        right = FALSE
      ),

      DAYS_EMPLOYED = if_else(
        DAYS_EMPLOYED == 365243,
        NA_real_,
        DAYS_EMPLOYED
      ),

      EMPLOYMENT_YEARS = -DAYS_EMPLOYED / 365.25
    )

  return(data)
}

train_test <- prepare_demographic_features(train)

train_test %>%
  select(AGE_YEARS, AGE_GROUP) %>%
  head()

# Create financial features based on the EDA.
# Ratios can be more informative than raw dollar amounts alone.

prepare_financial_features <- function(data) {
  
  data <- data %>%
    mutate(
      CREDIT_INCOME_RATIO = AMT_CREDIT / AMT_INCOME_TOTAL,
      ANNUITY_INCOME_RATIO = AMT_ANNUITY / AMT_INCOME_TOTAL,
      CREDIT_ANNUITY_RATIO = AMT_CREDIT / AMT_ANNUITY
    )
  
  return(data)
}

train_test2 <- prepare_financial_features(train_test)

train_test2 %>%
  select(
    AMT_INCOME_TOTAL,
    AMT_CREDIT,
    AMT_ANNUITY,
    CREDIT_INCOME_RATIO,
    ANNUITY_INCOME_RATIO,
    CREDIT_ANNUITY_RATIO
  ) %>%
  head()



# Create missing-value indicators based on EDA findings.
# Missingness was associated with default risk, so preserve that information.

prepare_missing_features <- function(data) {

  data <- data %>%
    mutate(
      TOTAL_MISSING = rowSums(is.na(.)),
      EXT_SOURCE_1_MISSING = if_else(is.na(EXT_SOURCE_1), 1, 0),
      EXT_SOURCE_2_MISSING = if_else(is.na(EXT_SOURCE_2), 1, 0),
      EXT_SOURCE_3_MISSING = if_else(is.na(EXT_SOURCE_3), 1, 0)
    )

  return(data)
}

train_test3 <- prepare_missing_features(train_test2)

train_test3 %>%
  select(
    EXT_SOURCE_1,
    EXT_SOURCE_1_MISSING,
    EXT_SOURCE_2,
    EXT_SOURCE_2_MISSING,
    EXT_SOURCE_3,
    EXT_SOURCE_3_MISSING,
    TOTAL_MISSING
  ) %>%
  head()


# Apply all data preparation steps in the same order.

prepare_application_data <- function(data) {

  data <- prepare_demographic_features(data)
  data <- prepare_financial_features(data)
  data <- prepare_missing_features(data)

  return(data)
}

train_prepared <- prepare_application_data(train)
test_prepared <- prepare_application_data(test)

dim(train_prepared)
dim(test_prepared)

# Confirm train and test have identical predictor columns.

train_predictors <- setdiff(names(train_prepared), "TARGET")
test_predictors <- names(test_prepared)

identical(train_predictors, test_predictors)


# Save prepared datasets.

write_csv(train_prepared, "application_train_prepared.csv")
write_csv(test_prepared, "application_test_prepared.csv")

# Final validation checks.

stopifnot(identical(
  setdiff(names(train_prepared), "TARGET"),
  names(test_prepared)
))

stopifnot(nrow(train_prepared) == nrow(train))
stopifnot(nrow(test_prepared) == nrow(test))

# Confirm each applicant remains represented by one row.

stopifnot(!anyDuplicated(train_prepared$SK_ID_CURR))
stopifnot(!anyDuplicated(test_prepared$SK_ID_CURR))