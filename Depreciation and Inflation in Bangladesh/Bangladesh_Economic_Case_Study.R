# ============================================================
# Bangladesh Economic Performance and Inflation
# Exchange Rate, Inflation and Trade: 2006-2026
#
# Working title:
# Exchange Rate Depreciation and Inflation in Bangladesh:
# Evidence from Monthly Economic Data
#
# Research question:
# Is exchange-rate depreciation associated with higher inflation?
#
# Data source:
# World Bank Global Economic Monitor (GEM), monthly Bangladesh data
# Period: July 2006 - June 2026
# ============================================================


# ============================================================
# 1. LOAD PACKAGES
# ============================================================

library(tidyverse)
library(lubridate)


# ============================================================
# 2. SET WORKING DIRECTORY
# ============================================================

setwd("G:/OneDrive/Documents")

getwd()


# ============================================================
# 3. IMPORT THE RAW GEM DATA
# ============================================================

data <- read_csv("GEM_Bangladesh.csv")

dim(data)
names(data)
head(data)


# ============================================================
# 4. CREATE A CLEAN COPY
#
# The first four columns identify the series.
# Monthly observations begin in column 5.
#
# World Bank uses ".." for unavailable observations.
# Converting the monthly columns to numeric changes these
# entries to NA while preserving the raw data object.
# ============================================================

data_clean <- data

data_clean[5:ncol(data_clean)] <- lapply(
  data_clean[5:ncol(data_clean)],
  as.numeric
)

sapply(data_clean[5:ncol(data_clean)], class)


# ============================================================
# 5. RESHAPE THE DATA FROM WIDE TO LONG FORMAT
# ============================================================

data_long <- data_clean %>%
  pivot_longer(
    cols = 5:ncol(data_clean),
    names_to = "Month",
    values_to = "Value"
  )

dim(data_long)
head(data_long)


# ============================================================
# 6. CHECK NUMBER OF OBSERVATIONS PER SERIES
# ============================================================

data_long %>%
  count(Series)


# ============================================================
# 7. CONVERT MONTH TO A PROPER DATE
# ============================================================

data_long <- data_long %>%
  mutate(
    Month = str_extract(Month, "^\\d{4}M\\d{2}"),
    Date = ymd(paste0(
      str_sub(Month, 1, 4),
      "-",
      str_sub(Month, 6, 7),
      "-01"
    ))
  )

head(data_long %>% select(Series, Month, Date, Value))


# ============================================================
# 8. CHECK MISSING VALUES
# ============================================================

data_long %>%
  group_by(Series) %>%
  summarise(
    missing_values = sum(is.na(Value)),
    total_observations = n()
  )


# ============================================================
# 9. CHECK FOR DUPLICATES
# ============================================================

data_long %>%
  count(Series, Date) %>%
  filter(n > 1)


# ============================================================
# 10. CREATE ONE ROW PER MONTH
# ============================================================

data_analysis <- data_long %>%
  select(Date, Series, Value) %>%
  pivot_wider(
    names_from = Series,
    values_from = Value
  )

dim(data_analysis)
names(data_analysis)


# ============================================================
# 11. RENAME THE ECONOMIC VARIABLES
# ============================================================

data_analysis <- data_analysis %>%
  rename(
    CPI = `CPI Price,not seas.adj,,,`,
    Inflation = `CPI Price, % y-o-y, not seas. adj.,,`,
    Exchange_Rate = `Official exchange rate, LCU per USD, period average,,`,
    Exports = `Exports Merchandise, Customs, current US$, millions, not seas. adj.`,
    Imports = `Imports Merchandise, Customs, current US$, millions, not seas. adj.`
  )

names(data_analysis)


# ============================================================
# 12. CREATE ECONOMIC VARIABLES
#
# Exchange_Rate_Change:
# positive values indicate an increase in LCU per USD,
# i.e. depreciation of the taka against the US dollar.
#
# July 2006 is NA because there is no previous month.
# ============================================================

data_analysis <- data_analysis %>%
  arrange(Date) %>%
  mutate(
    Exchange_Rate_Change =
      (Exchange_Rate / lag(Exchange_Rate) - 1) * 100,

    Trade_Balance =
      Exports - Imports,

    Export_Growth =
      (Exports / lag(Exports) - 1) * 100,

    Import_Growth =
      (Imports / lag(Imports) - 1) * 100
  )

head(data_analysis)
summary(data_analysis)


# ============================================================
# 13. SAVE THE CLEAN ANALYSIS DATASET
# ============================================================

write_csv(
  data_analysis,
  "Bangladesh_analysis_data.csv"
)


# ============================================================
# 14. BASIC DESCRIPTIVE STATISTICS
# ============================================================

summary(
  data_analysis %>%
    select(
      CPI,
      Inflation,
      Exchange_Rate,
      Exports,
      Imports,
      Exchange_Rate_Change,
      Trade_Balance,
      Export_Growth,
      Import_Growth
    )
)


# ============================================================
# 15. VISUALIZATION: MONTHLY INFLATION
# ============================================================

ggplot(
  data_analysis,
  aes(x = Date, y = Inflation)
) +
  geom_line() +
  labs(
    title = "Monthly Inflation in Bangladesh",
    x = "Date",
    y = "Inflation (% year-on-year)"
  )


# ============================================================
# 16. VISUALIZATION: MONTHLY EXCHANGE-RATE CHANGE
# ============================================================

ggplot(
  data_analysis,
  aes(x = Date, y = Exchange_Rate_Change)
) +
  geom_line() +
  labs(
    title = "Monthly Exchange Rate Change in Bangladesh",
    x = "Date",
    y = "Exchange Rate Change (%)"
  )


# ============================================================
# 17. VISUALIZATION: INFLATION AND EXCHANGE-RATE CHANGE
# ============================================================

ggplot(
  data_analysis,
  aes(x = Date)
) +
  geom_line(aes(y = Inflation)) +
  geom_line(aes(y = Exchange_Rate_Change)) +
  labs(
    title = "Inflation and Exchange Rate Change in Bangladesh",
    x = "Date",
    y = "Percentage"
  )


# ============================================================
# 18. SCATTER PLOT: INFLATION VS EXCHANGE-RATE CHANGE
# ============================================================

ggplot(
  data_analysis,
  aes(
    x = Exchange_Rate_Change,
    y = Inflation
  )
) +
  geom_point() +
  labs(
    title = "Inflation and Exchange Rate Change",
    x = "Exchange Rate Change (%)",
    y = "Inflation (% year-on-year)"
  )


# ============================================================
# 19. SCATTER PLOT WITH REGRESSION LINE
# ============================================================

ggplot(
  data_analysis,
  aes(
    x = Exchange_Rate_Change,
    y = Inflation
  )
) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Inflation and Exchange Rate Change",
    x = "Exchange Rate Change (%)",
    y = "Inflation (% year-on-year)"
  )


# ============================================================
# 20. CORRELATION
# ============================================================

cor(
  data_analysis$Inflation,
  data_analysis$Exchange_Rate_Change,
  use = "complete.obs"
)


# ============================================================
# 21. SIMPLE REGRESSION
#
# Inflation_t = alpha + beta * Exchange_Rate_Change_t + error_t
# ============================================================

model1 <- lm(
  Inflation ~ Exchange_Rate_Change,
  data = data_analysis
)

summary(model1)


# ============================================================
# 22. BASIC RESIDUAL DIAGNOSTIC
#
# A simple fitted-value vs residual plot is used because the
# full plot(model1) caused an RGui issue in the original workflow.
# ============================================================

plot(
  fitted(model1),
  residuals(model1),
  xlab = "Fitted values",
  ylab = "Residuals",
  main = "Residuals vs Fitted Values"
)


# ============================================================
# 23. CREATE ONE-MONTH LAG
# ============================================================

data_analysis$Exchange_Rate_Change_Lag1 <-
  dplyr::lag(
    data_analysis$Exchange_Rate_Change,
    1
  )


# ============================================================
# 24. LAGGED REGRESSION
#
# Inflation_t =
# alpha + beta0 * Exchange_Rate_Change_t
# + beta1 * Exchange_Rate_Change_(t-1)
# + error_t
# ============================================================

model2 <- lm(
  Inflation ~
    Exchange_Rate_Change +
    Exchange_Rate_Change_Lag1,
  data = data_analysis
)

summary(model2)


# ============================================================
# 25. CREATE A COMMON SAMPLE FOR MODEL COMPARISON
#
# This makes sure both models use exactly the same observations.
# ============================================================

data_common <- na.omit(
  data_analysis[
    ,
    c(
      "Inflation",
      "Exchange_Rate_Change",
      "Exchange_Rate_Change_Lag1"
    )
  ]
)


# ============================================================
# 26. CURRENT-ONLY MODEL ON THE COMMON SAMPLE
# ============================================================

model1_common <- lm(
  Inflation ~ Exchange_Rate_Change,
  data = data_common
)


# ============================================================
# 27. CURRENT + ONE-MONTH-LAG MODEL ON THE COMMON SAMPLE
# ============================================================

model2_common <- lm(
  Inflation ~
    Exchange_Rate_Change +
    Exchange_Rate_Change_Lag1,
  data = data_common
)


# ============================================================
# 28. COMPARE THE TWO MODELS
# ============================================================

anova(
  model1_common,
  model2_common
)


# ============================================================
# 29. LAGGED CORRELATION
# ============================================================

cor(
  data_analysis$Inflation,
  data_analysis$Exchange_Rate_Change_Lag1,
  use = "complete.obs"
)


# ============================================================
# 30. LAGGED SCATTER PLOT
# ============================================================

ggplot(
  data_analysis,
  aes(
    x = Exchange_Rate_Change_Lag1,
    y = Inflation
  )
) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Inflation and Lagged Exchange Rate Change",
    x = "Previous Month's Exchange Rate Change (%)",
    y = "Inflation (% year-on-year)"
  )


# ============================================================
# 31. CREATE TWO-MONTH LAG
# ============================================================

data_analysis$Exchange_Rate_Change_Lag2 <-
  dplyr::lag(
    data_analysis$Exchange_Rate_Change,
    2
  )


# ============================================================
# 32. TWO-MONTH LAG MODEL
#
# Inflation_t =
# alpha + beta0 * current exchange-rate change
# + beta1 * one-month lag
# + beta2 * two-month lag
# + error_t
# ============================================================

model3 <- lm(
  Inflation ~
    Exchange_Rate_Change +
    Exchange_Rate_Change_Lag1 +
    Exchange_Rate_Change_Lag2,
  data = data_analysis
)

summary(model3)


# ============================================================
# 33. SAVE THE FINAL ANALYSIS DATASET INCLUDING LAGS
# ============================================================

write_csv(
  data_analysis,
  "Bangladesh_analysis_data_final.csv"
)


# ============================================================
# END OF ANALYSIS
#
# Important interpretation rule:
# Correlation and regression identify statistical associations.
# They do NOT by themselves establish that exchange-rate
# depreciation causes inflation.
# ============================================================
