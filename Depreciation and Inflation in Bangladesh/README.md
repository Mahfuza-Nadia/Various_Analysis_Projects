# Exchange Rate Depreciation and Inflation in Bangladesh

## Project Description

This project examines the relationship between exchange-rate changes and inflation in Bangladesh using monthly economic data.

## Data Source

* **Source:** World Bank Global Economic Monitor (GEM)
* **Country:** Bangladesh
* **Period:** July 2006 – June 2026
* **Frequency:** Monthly
* **Observations:** 240 months

## Research Question

**Is exchange-rate depreciation associated with higher inflation in Bangladesh?**

The study also examines whether exchange-rate changes are associated with inflation with a one- or two-month lag.

## Variables

* CPI Price
* CPI Price, % year-on-year (Inflation)
* Official Exchange Rate, LCU per USD
* Merchandise Exports
* Merchandise Imports
* Exchange Rate Change
* Trade Balance
* Export Growth
* Import Growth

## Methodology

The analysis uses:

* Data cleaning and transformation
* Descriptive statistics
* Time-series visualizations
* Correlation analysis
* Linear regression
* One- and two-month lagged regression
* Residual diagnostics
* Newey-West standard errors

The analysis identifies statistical associations and does not establish causality.

## How to Reproduce

1. Install **R 4.3.1** or a compatible version.
2. Install and load the required packages:

   * `tidyverse`
   * `lubridate`
3. Place `GEM_Bangladesh.csv` in the working directory.
4. Open `Bangladesh_Economic_Case_Study.R` in RGui.
5. Run the script from beginning to end.

The script cleans the data, creates the analysis variables, performs the statistical analysis, and saves the processed dataset.

## Files

* `GEM_Bangladesh.csv` — Raw World Bank data
* `Bangladesh_Economic_Case_Study.R` — R analysis script
* `Bangladesh_analysis_data.csv` — Processed dataset
* `Exchange Rate Depreciation and Inflation in Bangladesh.pdf` — Report
