category <- c("ORDER", "CONTACT", "INVOICE", "FEEDACK", "PAYMENT", "REFUND", "SHIPPING", "CANCEL")

category_frequency <- c(1995,
                        1160,
                        1000,
                        1000,
                        999,
                        997,
                        973,
                        950)

df_category <- data.frame(category, category_frequency)

df_category %>%
  ggplot(aes(x=reorder(category, category_frequency), y=category_frequency)) +
  geom_bar(stat="identity", fill="#2ca25f") +
  geom_text(aes(label=category_frequency), color="white", fontface=2, hjust = 1.25, size=5) +
  coord_flip() +
  theme_minimal(base_family = "serif") +
  theme(legend.position = "none",
        axis.title = element_text(size = 14),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12)) +
  labs(x="Category", y="Frequency")
