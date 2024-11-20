install.packages("pacman")
pacman::p_load(tidyverse, data.table)

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
  annotate(geom="text", label=expression("R"^2*" = 0.1118"), x = 18, y = 0.125, size = 5) +
  theme_minimal(base_family = "serif") +
  labs(x="Mean Wants of Extra Baggage to Mean Flight Duration Ratio ", y = "Mean Length of Stay to Mean Flight Duration Ratio")

dt.q6 %>%
  ggplot(aes(x=avg_stay_flight_ratio, y=avg_seat_flight_ratio)) +
  geom_point() +
  geom_abline(slope = -0.0005775, intercept = 0.0445806) +
  annotate(geom="text", label=expression("R"^2*" = 0.0004"), x = 18, y = 0.15, size = 5) +
  theme_minimal(base_family = "serif") +
  labs(x="Mean Wants of Preferred Seat to Mean Flight Duration Ratio ", y = "Mean Length of Stay to Mean Flight Duration Ratio")

dt.q6 %>%
  ggplot(aes(x=avg_stay_flight_ratio, y=avg_meals_flight_ratio)) +
  geom_point() +
  geom_abline(slope = 0.003284, intercept = 0.049313) +
  annotate(geom="text", label=expression("R"^2*" = 0.0309"), x = 18, y = 0.15, size = 5) +
  theme_minimal(base_family = "serif") +
  labs(x="Mean Wants of In-Flight Meals to Mean Flight Duration Ratio ", y = "Mean Length of Stay to Mean Flight Duration Ratio")
