library(fpp3)


# Lab Session 11

hh_budget |> autoplot(Wealth)

hh_budget |>
  model(drift = RW(Wealth ~ drift()),
        snaive = SNAIVE(Wealth)
        ) |>
  forecast(h = "5 years") |>
  autoplot(hh_budget, show_gap=FALSE)

aus_takeaway <- aus_retail |>
  filter(Industry == "Cafes, restaurants and takeaway food services") |>
  summarise(Turnover = sum(Turnover))

aus_takeaway |> autoplot(Turnover)

aus_takeaway |>
  model(snaive = SNAIVE(log(Turnover) ~ drift())) |>
  forecast(h = "3 years") |>
  autoplot(aus_takeaway)


# Lab Session 12

beer_model <- aus_production |>
  model(snaive = SNAIVE(Beer))

beer_model |>
  forecast(h = "3 years") |>
  autoplot(aus_production)

beer_model |> gg_tsresiduals()

augment(beer_model) |>
  features(.innov, ljung_box, lag = 8)


# Lab Session 13

hh_budget_train <- hh_budget |>
  filter(Year <= max(Year) - 4)

hh_budget_forecast <- hh_budget_train |>
  model(
    mean = MEAN(Wealth),
    naive = NAIVE(Wealth),
    drift = RW(Wealth ~ drift())
  ) |>
  forecast(h = "4 years")

hh_budget_forecast |>
  autoplot(hh_budget, level = NULL)

hh_budget_forecast |>
  accuracy(hh_budget) |>
  group_by(.model) |>
  summarise_if(is.numeric, mean)

aus_takeaway_train <- aus_takeaway |>
  filter(year(Month) <= max(year(Month)) - 4)

aus_takeaway_forecast <- aus_takeaway_train |>
  model(
    mean = MEAN(Turnover),
    naive = NAIVE(Turnover),
    drift = RW(Turnover ~ drift()),
    snaive = SNAIVE(Turnover)
  ) |>
  forecast(h = "4 years")

aus_takeaway_forecast |>
  accuracy(aus_takeaway)


# Time series cross-validation (not covered in class)

aus_takeaway_stretch <- aus_takeaway |>
  stretch_tsibble(.init = 24)
fit <- aus_takeaway_stretch |>
  model(
    mean = MEAN(Turnover),
    naive = NAIVE(Turnover),
    drift = RW(Turnover ~ drift()),
    snaive = SNAIVE(Turnover)
  ) |>
  forecast(h = "4 years")

fit |>
  group_by(.id, .model) |>
  mutate(h = row_number()) |>
  ungroup() |>
  filter(h==12) |>
  as_fable(dist=Turnover, response="Turnover") |>
  accuracy(aus_takeaway, by=".model")


# Lab Session 14

global_economy |>
  filter(Country == "China") |>
  autoplot(box_cox(GDP, 0.2))

fit <- global_economy |>
  filter(Country == "China") |>
  model(
    ets = ETS(GDP),
    ets_damped = ETS(GDP ~ trend("Ad")),
    ets_bc = ETS(box_cox(GDP, 0.2)),
    ets_log = ETS(log(GDP))
  )
fit
report(fit)
fit |>
  select(ets) |>
  report()

glance(fit)
tidy(fit)
coef(fit)

fit |>
  forecast(h = "20 years") |>
  autoplot(global_economy, level = NULL)


# Lab Session 15

gas <- aus_production |>
  select(Gas)

autoplot(gas)

fit <- gas |>
  filter(year(Quarter) <= 2005) |>
  model(
    auto = ETS(Gas),
    MAM = ETS(Gas ~ error("M") + trend("A") + season("M")),
    additive = ETS(Gas ~ season("A")),
    damped = ETS(Gas ~ trend("Ad")),
    log = ETS(log(Gas)),
    snaive = SNAIVE(Gas)
  )

fit

fc <- fit |>
  forecast(h = "4 years")

fc |>
  autoplot(aus_production, level = NULL)

fc |>
  filter(.model == "auto") |>
  autoplot(
    filter(
      aus_production,
      Quarter > yearquarter("2000 Q4")
    )
    )

fc |>
  accuracy(aus_production)


# Lab Session 16

us_gdp <- global_economy |>
  filter(Code == "USA")
us_gdp |> autoplot(log(GDP))

us_gdp_model <- us_gdp |>
  model(
    arima_notransform = ARIMA(GDP),
    arima = ARIMA(log(GDP)),
    arima1 = ARIMA(log(GDP) ~ pdq(d = 1)),
  )
us_gdp_model
glance(us_gdp_model)

us_gdp_model |>
  forecast(h = "10 years") |>
  autoplot(us_gdp, level = NULL)

us_gdp_model |>
  select(Country, arima) |>
  forecast(h = "10 years") |>
  autoplot(us_gdp)


# Lab Session 17

tourism_models <- tourism |>
  filter(Purpose == "Holiday") |>
  model(arima = ARIMA(Trips))
tourism_models
tourism_fc <- forecast(tourism_models)
tourism_fc

tourism_fc |>
  filter(Region == "Snowy Mountains") |>
  autoplot(tourism)

tourism_fc |>
  filter(Region == "Melbourne") |>
  autoplot(tourism)


# Lab Session 18

vic_elec_daily <- vic_elec |>
  filter(year(Time) == 2014) |>
  index_by(Date = date(Time)) |>
  summarise(
    Demand = sum(Demand) / 1e3,
    Temperature = max(Temperature),
    Holiday = any(Holiday)
  ) |>
  mutate(
    Day_Type = case_when(
      Holiday ~ "Holiday",
      wday(Date) %in% 2:6 ~ "Weekday",
      TRUE ~ "Weekend"
    )
  )

elec_model <- vic_elec_daily |>
  model(fit = ARIMA(Demand ~ Temperature +
    I(pmax(Temperature - 23.5, 0)) +
    (Day_Type == "Weekday")))
report(elec_model)

elec_model |> gg_tsresiduals()

vic_elec_future <- new_data(vic_elec_daily, 14) |>
  mutate(
    Temperature = 26,
    Holiday = c(TRUE, rep(FALSE, 13)),
    Day_Type = case_when(
      Holiday ~ "Holiday",
      wday(Date) %in% 2:6 ~ "Weekday",
      TRUE ~ "Weekend"
    )
  )

forecast(elec_model, vic_elec_future) |>
  autoplot(vic_elec_daily) + labs(y = "Electricity demand (GW)")


# Lab Session 19

vic_elec_daily <- vic_elec |>
  index_by(Date = date(Time)) |>
  summarise(
    Demand = sum(Demand) / 1e3,
    Temperature = max(Temperature),
    Holiday = any(Holiday)
  ) |>
  mutate(
    Day_Type = case_when(
      Holiday ~ "Holiday",
      wday(Date) %in% 2:6 ~ "Weekday",
      TRUE ~ "Weekend"
    )
  )

elec_model <- vic_elec_daily |>
  model(fit = ARIMA(Demand ~
    fourier("year", K = 10) + fourier("week", K=3) + PDQ(0,0,0) +
    Temperature + I(pmax(Temperature - 23.5, 0)) +
    (Day_Type == "Weekday")))
report(elec_model)

augment(elec_model) |>
  gg_tsdisplay(.resid, plot_type = "histogram")

augment(elec_model) |>
  features(.resid, ljung_box, dof = 9, lag = 14)

vic_next_day <- new_data(vic_elec_daily, 1) |>
  mutate(Temperature = 26, Day_Type = "Holiday")
forecast(elec_model, vic_next_day)

vic_elec_future <- new_data(vic_elec_daily, 14) |>
  mutate(
    Temperature = 26,
    Holiday = c(TRUE, rep(FALSE, 13)),
    Day_Type = case_when(
      Holiday ~ "Holiday",
      wday(Date) %in% 2:6 ~ "Weekday",
      TRUE ~ "Weekend"
    )
  )

forecast(elec_model, vic_elec_future) |>
  autoplot(filter(vic_elec_daily, year(Date) > 2013)) +
  labs(y = "Electricity demand (GW)")


# Lab Session 20

PBS_aggregated <- PBS |>
  aggregate_key(
    Concession * Type * ATC1,
    Cost = sum(Cost) / 1e6
  )
fit <- PBS_aggregated |>
  filter(Month <= yearmonth("2005 Jun")) |>
  model(
    ets = ETS(Cost),
    arima = ARIMA(Cost),
    snaive = SNAIVE(Cost)
  )
fit <- fit |>
  mutate(comb = (ets + arima + snaive)/3)
fc <- fit |>
  reconcile(
    ets_adj = min_trace(ets),
    arima_adj = min_trace(arima),
    snaive_adj = min_trace(snaive),
    comb_adj = min_trace(comb)
  ) |>
  forecast(h = "3 years")
accuracy(fc, PBS_aggregated) |>
  group_by(.model) |>
  summarise(RMSSE = mean(RMSSE)) |>
  arrange(RMSSE)
