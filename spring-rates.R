library(tidyverse)
library(gt)

raw <- read_csv("spring-rates.csv") |>
  mutate(Bar = str_replace_all(Bar, "30mm", "35 mm")) |>
  mutate(Bar = str_replace_all(Bar, "50mm", "50 mm"))

# ---- Table ----
table <- raw |>
  rename(
    `Vertical displacement (mm)` = `Vertical mean (mm)`,
    `Horizontal displacement (mm)` = `Horizontal mean (mm)`
  ) |>
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

# ---- Analysis ----
raw |>
  select(bar = Bar, vert = 5, hori = 6) |>
  filter(!str_detect(bar, "^Fasst")) |>
  mutate(compliance_diff = (vert - hori) / hori * 100) |>
  summarise(avg_compliance_diff = mean(compliance_diff))
