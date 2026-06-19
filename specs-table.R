library(tidyverse)
library(gt)

raw <- read_csv(
  "specs.csv",
  skip = 1,
  col_names = c(
    "Bar",
    "Rise (mm)",
    "Width uncut (mm)",
    "Backsweep (°)",
    "Upsweep (°)",
    "Clamp diameter (mm)",
    "Material",
    "Weight uncut (g)",
    "Price ($)"
  )
)

table <- raw |>
  slice(-10) |>
  gt() |>
  opt_row_striping() |>
  tab_options(column_labels.font.weight = "bold")

gtsave(table, "specs-table.png")
