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
  head(n = 20)

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
  head(n = 20)

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
  head(n = 20)
