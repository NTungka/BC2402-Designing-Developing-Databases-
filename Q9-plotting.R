pacman::p_load(tidyverse, data.table, tidytext, textstem, stringr)

dt.reviewsPeriod <- fread("Q9.csv")

bigram <- c("word1", "word2")

dt.reviewsPeriod %>%
  filter(Period == "Pre-COVID") %>%
  unnest_tokens(word, Reviews, token = "ngrams", n = 2) %>%
  filter(!grepl('[0-9]', word)) %>%
  anti_join(stop_words) %>%
  separate(word, bigram, sep = " ") %>%
  mutate(
    word1 = lemmatize_words(word1),
    word2 = lemmatize_words(word2)
  ) %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word) %>%
  unite(word, word1, word2, sep = " ") %>%
  count(Period, word, sort = TRUE) %>%
  bind_tf_idf(word, Period, n) %>%
  arrange(desc(tf_idf)) %>%
  head(n = 20) %>%
  ggplot(aes(x=reorder(word, n), y=n)) +
  geom_bar(stat="identity", fill="darkgreen") +
  geom_text(aes(label=n), color="white", hjust = 1.25) +
  coord_flip() +
  theme_minimal(base_family = "serif") +
  theme(legend.position = "none",
        axis.title = element_text(size = 14),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12)) +
  labs(x="Phrase", y="Frequency")

dt.reviewsPeriod %>%
  filter(Period == "During-COVID") %>%
  unnest_tokens(word, Reviews, token = "ngrams", n = 2) %>%
  filter(!grepl('[0-9]', word)) %>%
  anti_join(stop_words) %>%
  separate(word, bigram, sep = " ") %>%
  mutate(
    word1 = lemmatize_words(word1),
    word2 = lemmatize_words(word2)
  ) %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word) %>%
  unite(word, word1, word2, sep = " ") %>%
  count(Period, word, sort = TRUE) %>%
  bind_tf_idf(word, Period, n) %>%
  arrange(desc(tf_idf)) %>%
  head(n = 20) %>%
  ggplot(aes(x=reorder(word, n), y=n)) +
  geom_bar(stat="identity", fill="darkgreen") +
  geom_text(aes(label=n), color="white", hjust = 1.25) +
  coord_flip() +
  theme_minimal(base_family = "serif") +
  theme(legend.position = "none",
        axis.title = element_text(size = 14),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12)) +
  labs(x="Phrase", y="Frequency")

dt.reviewsPeriod %>%
  filter(Period == "Post-COVID") %>%
  unnest_tokens(word, Reviews, token = "ngrams", n = 2) %>%
  filter(!grepl('[0-9]', word)) %>%
  anti_join(stop_words) %>%
  separate(word, bigram, sep = " ") %>%
  mutate(
    word1 = lemmatize_words(word1),
    word2 = lemmatize_words(word2)
  ) %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word) %>%
  unite(word, word1, word2, sep = " ") %>%
  count(Period, word, sort = TRUE) %>%
  bind_tf_idf(word, Period, n) %>%
  arrange(desc(tf_idf)) %>%
  head(n = 20) %>%
  ggplot(aes(x=reorder(word, n), y=n)) +
  geom_bar(stat="identity", fill="darkgreen") +
  geom_text(aes(label=n), color="white", hjust = 1.25) +
  coord_flip() +
  theme_minimal(base_family = "serif") +
  theme(legend.position = "none",
        axis.title = element_text(size = 14),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12)) +
  labs(x="Phrase", y="Frequency")
