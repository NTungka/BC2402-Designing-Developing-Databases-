pacman::p_load(tidyverse, data.table, tidytext, textstem, stringr)

dt.reviews <- fread("Q8.csv")

dt.reviews <- dt.reviews %>% add_row(Airline = "Both", Reviews = paste(dt.reviews %>% filter(Airline == "Qatar Airways") %>% select(Reviews), dt.reviews %>% filter(Airline == "Singapore Airlines") %>% select(Reviews), sep= " ") )

str_count(dt.reviews %>% filter(Airline == "Qatar Airways") %>% select(Reviews), '\\w+')
str_count(dt.reviews %>% filter(Airline == "Singapore Airlines") %>% select(Reviews), '\\w+')
str_count(dt.reviews %>% filter(Airline == "Both") %>% select(Reviews), '\\w+')

# dt.reviews %>%
#   filter(Airline == "Qatar Airways") %>%
#   unnest_tokens(word, Reviews) %>%
#   anti_join(stop_words) %>%
#   count(Airline, word, sort = TRUE) %>%
#   bind_tf_idf(Airline, word, n)

bigram <- c("word1", "word2")

dt.reviews %>%
  filter(Airline == "Qatar Airways") %>%
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
  count(Airline, word, sort = TRUE) %>%
  bind_tf_idf(word, Airline, n) %>%
  arrange(desc(tf_idf)) %>%
  head(n = 20)

dt.reviews %>%
  filter(Airline == "Singapore Airlines") %>%
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
  count(Airline, word, sort = TRUE) %>%
  bind_tf_idf(word, Airline, n) %>%
  arrange(desc(tf_idf)) %>%
  head(n = 20)

dt.reviews %>%
  filter(Airline == "Both") %>%
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
  count(Airline, word, sort = TRUE) %>%
  bind_tf_idf(word, Airline, n) %>%
  arrange(desc(tf_idf)) %>%
  head(n = 20)
