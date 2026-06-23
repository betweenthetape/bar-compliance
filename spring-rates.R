library(tidyverse)
library(gt)

raw <- read_csv("spring-rates.csv")

# ---- Table ----
table <- raw |>
  arrange(`Vertical spring rate (N/mm)`) |>
  gt() |>
  opt_row_striping() |>
  tab_options(column_labels.font.weight = "bold") |>
  fmt_number(
    columns = c("Vertical spring rate (N/mm)", "Horizontal spring rate (N/mm)"),
    decimals = 1
  )

table

gtsave(table, "spring-rates-table.png")

# ---- Plots ----
# Strip plots
raw |>
  ggplot(aes(x = `Vertical spring rate (N/mm)`, y = 0, label = Bar)) +
  geom_point(
    size = 10,
    shape = 21,
    alpha = .7,
    fill = "#8ec73d",
    colour = "black"
  ) +
  scale_x_continuous(limits = c(0, 50), breaks = seq(0, 50, by = 10)) +
  scale_y_continuous(limits = c(-0.1, 0.15)) +
  labs(x = "Vertical spring rate (N/mm)", y = NULL) +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.grid.minor.x = element_blank()
  )

raw |>
  pivot_longer(
    cols = c(`Vertical spring rate (N/mm)`, `Horizontal spring rate (N/mm)`),
    names_to = "metric",
    values_to = "rate"
  ) |>
  ggplot(aes(x = rate, y = 0, label = Bar)) +
  geom_point(
    size = 10,
    shape = 21,
    alpha = .7,
    fill = "#8ec73d",
    colour = "black"
  ) +
  scale_x_continuous(limits = c(0, 50), breaks = seq(0, 50, by = 10)) +
  scale_y_continuous(limits = c(-0.1, 0.15)) +
  facet_wrap(~metric, ncol = 1) +
  labs(x = "Spring rate (N/mm)", y = NULL) +
  theme_minimal() +
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.grid.minor.x = element_blank(),
    strip.text = element_text(hjust = 0)
  )

# Correlation plot: vertical and horiztonal spring rates
# No correlation
raw |>
  # filter(!str_detect(Bar, "^Fasst")) |>
  ggplot(aes(
    x = `Vertical spring rate (N/mm)`,
    y = `Horizontal spring rate (N/mm)`
  )) +
  geom_point()
