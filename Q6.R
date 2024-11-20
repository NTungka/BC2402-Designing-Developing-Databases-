dt.q6 <- fread("Q6.csv", stringsAsFactors = TRUE)

lm.baggage <- lm(avg_baggage_flight_ratio~avg_stay_flight_ratio, dt.q6)
summary(lm.baggage)

lm.seat <- lm(avg_seat_flight_ratio~avg_stay_flight_ratio, dt.q6)
summary(lm.seat)

lm.meal <- lm(avg_meals_flight_ratio~avg_stay_flight_ratio, dt.q6)
summary(lm.meal)

dt.q6 %>%
  ggplot(aes(x=avg_stay_flight_ratio, y=avg_baggage_flight_ratio)) +
  geom_point() +
  geom_abline(slope = 0.007019, intercept = 0.073887) +
  theme_minimal(base_family = "serif") +
  labs(x="Average")

dt.q6 %>%
  ggplot(aes(x=avg_stay_flight_ratio, y=avg_seat_flight_ratio)) +
  geom_point() +
  geom_abline(slope = -0.0005775, intercept = 0.0445806) +
  theme_minimal(base_family = "serif")

dt.q6 %>%
  ggplot(aes(x=avg_stay_flight_ratio, y=avg_meals_flight_ratio)) +
  geom_point() +
  geom_abline(slope = 0.003284, intercept = 0.049313) +
  theme_minimal(base_family = "serif")
