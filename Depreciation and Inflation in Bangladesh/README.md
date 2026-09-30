# Exchange Rate Depreciation and Inflation in Bangladesh

### Evidence from Monthly Economic Data (July 2006 – June 2026)

## Project Description

This project examines the relationship between exchange-rate changes and inflation in Bangladesh using monthly economic data from July 2006 to June 2026.

The study combines data cleaning, descriptive analysis, time-series visualization and econometric modeling using R. It also includes an interactive Power BI dashboard to visualize inflation trends, exchange-rate movements and their observed relationship.

The project aims to investigate whether exchange-rate depreciation is associated with higher inflation in Bangladesh and whether this relationship extends to subsequent months.

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

The econometric analysis examines statistical associations and does not establish causality.

## Power BI Dashboard

An interactive, single-page dashboard was developed using Microsoft Power BI to visualize the monthly economic data and explore the relationship between exchange-rate changes and inflation.

### Dashboard Features

* **Average Inflation:** Displays the average inflation rate over the selected period.
* **Average Exchange Rate:** Shows the average official exchange rate.
* **Average Depreciation:** Presents the average monthly exchange-rate change.
* **Maximum Inflation:** Displays the highest inflation rate in the selected period.
* **Monthly Inflation Trend:** Visualizes changes in year-on-year inflation over time.
* **Monthly Exchange Rate Trend:** Shows movements in the official exchange rate.
* **Scatter Plot:** Illustrates the observed relationship between exchange-rate changes and inflation.
* **Date Slicer:** Allows users to explore the dashboard over different periods.

The dashboard is intended for descriptive and exploratory analysis. It complements the econometric analysis conducted in R rather than replacing it.

## How to Reproduce

1. Install **R 4.3.1** or a compatible version.
2. Install and load the required packages:

   * `tidyverse`
   * `lubridate`
3. Place `GEM_Bangladesh.csv` in the working directory.
4. Open `Bangladesh_Economic_Case_Study.R` in RGui.
5. Run the script from beginning to end.

The script cleans the data, creates the analysis variables, performs the statistical analysis, and saves the processed dataset.

To explore the Power BI dashboard:

1. Install Microsoft Power BI Desktop.
2. Download `Bangladesh_dashboard.pbix` from the `powerbi` folder.
3. Open the file in Power BI Desktop.
4. Use the date slicer and interactive visuals to explore the data.

## Files

* `GEM_Bangladesh.csv` — Raw World Bank data
* `Bangladesh_Economic_Case_Study.R` — R analysis script
* `Bangladesh_analysis_data.csv` — Processed dataset
* `Exchange Rate Depreciation and Inflation in Bangladesh.pdf` — Research report
* `powerbi/Bangladesh_Depreciation and Inflation_dashboard.pbix` — Interactive Power BI dashboard
* `powerbi/dashboard.png` — Dashboard screenshot

## Tools and Technologies

* **R (4.3.1):** Data cleaning, transformation and econometric analysis
* **tidyverse:** Data manipulation and visualization
* **lubridate:** Date processing
* **Microsoft Power BI:** Interactive dashboard development
* **GitHub:** Project documentation and version control

## Research Scope and Limitations

This project examines the statistical relationship between exchange-rate changes and inflation in Bangladesh using monthly data. The regression models include contemporaneous and lagged exchange-rate changes.

The findings should be interpreted as statistical associations rather than causal effects. Other macroeconomic factors may also influence inflation, and the results are subject to the limitations of the available data and model specifications.

## Project Purpose

This project demonstrates the application of R for applied economic research, econometric analysis of monthly time-series data and Power BI for interactive economic data visualization. It brings together statistical analysis and data presentation in a reproducible research workflow.

