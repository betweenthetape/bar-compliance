library(tidyverse)
library(gt)

raw <- read_csv("spring-rates.csv")

table <- raw |>
  gt() |>
  opt_row_striping() |>
  tab_options(column_labels.font.weight = "bold")

gtsave(table, "spring-rates-table.png")
