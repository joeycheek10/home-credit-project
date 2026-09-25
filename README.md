# home-credit-project
Home Credit Default Risk Analysis – MSBA Practice Project

# Home Credit Default Risk Analysis

## Project Overview

This repository contains my work for the IS 6812 MSBA Practice Project course. The project focuses on analyzing Home Credit data to better understand credit default risk and explore how business analytics can support lending decisions.

## Project Goals

- Explore and understand the Home Credit dataset.
- Identify factors that may be associated with credit default risk.
- Apply data analysis and modeling techniques learned throughout the course.
- Communicate findings and business recommendations clearly.

## Project Status

This project is currently in progress. I will update this repository throughout the semester as I complete additional analyses and assignments.

## Data Preparation

The `data_preparation.R` script converts the exploratory data analysis findings into reusable preparation steps for both the training and test application datasets.

The script:

- Converts `DAYS_BIRTH` into `AGE_YEARS`.
- Replaces the special `DAYS_EMPLOYED = 365243` value with missing data and creates `EMPLOYMENT_YEARS`.
- Creates financial ratios:
  - `CREDIT_INCOME_RATIO`
  - `ANNUITY_INCOME_RATIO`
  - `CREDIT_ANNUITY_RATIO`
- Creates missing-value indicators for `EXT_SOURCE_1`, `EXT_SOURCE_2`, and `EXT_SOURCE_3`.
- Creates `TOTAL_MISSING` to summarize missing information for each applicant.
- Applies the same preparation functions to both the training and test datasets.
- Checks that the prepared training and test datasets contain identical predictor columns, except for `TARGET`, which is only present in the training data.

These transformations reflect findings from the EDA. Age and employment history showed differences in default risk, financial relationships were more useful when expressed relative to income or payments, and missingness was associated with differences in default rates.

### Running the Script

Run:

```r
source("data_preparation.R")

## Author

Joey Cheek