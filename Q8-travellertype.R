pacman::p_load(tidyverse, data.table, tidytext, textstem, stringr)

dt.reviewsTraveler <- fread("Q8-traveler.csv")

bigram <- c("word1", "word2")

dt.reviewsTraveler %>%
  filter(TravelerType == "Solo Leisure") %>%
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
  count(TravelerType, word, sort = TRUE) %>%
  bind_tf_idf(word, TravelerType, n) %>%
  arrange(desc(tf_idf)) %>%
  head(n = 20)

dt.reviewsTraveler %>%
  filter(TravelerType == "Couple Leisure") %>%
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
  count(TravelerType, word, sort = TRUE) %>%
  bind_tf_idf(word, TravelerType, n) %>%
  arrange(desc(tf_idf)) %>%
  head(n = 20)

dt.reviewsTraveler %>%
  filter(TravelerType == "Business") %>%
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
  count(TravelerType, word, sort = TRUE) %>%
  bind_tf_idf(word, TravelerType, n) %>%
  arrange(desc(tf_idf)) %>%
  head(n = 20)

dt.reviewsTraveler %>%
  filter(TravelerType == "Family Leisure") %>%
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
  count(TravelerType, word, sort = TRUE) %>%
  bind_tf_idf(word, TravelerType, n) %>%
  arrange(desc(tf_idf)) %>%
  head(n = 20)
