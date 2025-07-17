# Project Submission Summary
The assigned project can be split into two key categories:
1. Firstly, query development for MongoDB & mySQL to obtain unique insights from a synthethic database of reviews, open comments & flight statistics for common airlines (e.g SIA, Emirates, Qatar).
2. Develop a theoretical chatbot capable of determining customer sentiment & take note of essential data 🤖

## Query Development 
We will focus on the unique insights from the airline-comparison portion of query development. Overall our team took a few unique approaches:

- All metrics associated with customer preference such as "wants_extra_baggage" were normalized agains the total flight time
- June-September were designated as "seasonal" timings with other months designated as non-seasonal
- Feedback & complaints from customers were sorted according to keywords. A summarised example is listed below

| Complaint Category | Sorting keywords|
|----------|----------|
| Seat Comfort  | "Legroom", "Seat", "Space", "Comfort"  | 
| Food & Beverages    | "Beverage", "Food", "Snacks","Lunch","Dinner","Breakfast"  | 
|Staff Service| "Care", "Polite", "Professional", "Friendly", etc.|

### Key Insights
We will place a focus on insights surrounding Singapore airlines. The findings we found the most interesting are listed in a table below

| Insight | Supporting Statistics |
|----------|----------|
| SIA observed the greatest loss to competitors such as Qatar in terms of **Value for Money**, with dissatisfaction in pricing being a primary issue cited by customers. This was excacerbated during seasonal-periods.| SIA 2.8, Qatar 5|
| SIA observed the highest percentage of food-complaints when providing snacks, followed by Lunch Service| A complaint frequency of 24.2% & 23.9% for all food related feedback|
| There are seasonal variations for SIA's ratings versus Qatar's greater consistency| 3.61 ▶️ 3.33 (SIA Food & Beverage from Non-seasonal to Seasonal) |

<img width="767" height="270" alt="image" alignment = "middle" src="https://github.com/user-attachments/assets/389a5cb8-bbc3-4465-9142-2c0b6cffaf2b" />

## Chatbot Development
Our team picked up a few unique strategies when coming up with the design principle of the chatbot. The finalized Entity-Relationship Diagram is shown below:

<img width="426" height="436" alt="image" src="https://github.com/user-attachments/assets/0b92bbb3-5933-43a5-a10a-9a46b2e8cfb0" />

### Contextualization 
Firstly, we created a word dictionary that associated common phrases to common circumstances. This was stored in the "Keyword Dictionary" table with each word assigned a generated ID. 

<img width="551" height="244" alt="image" src="https://github.com/user-attachments/assets/91cec7bf-495a-4941-8fb6-e4b7d8f81792" />

A common example is flight turbulance. By creating a dictionary that links lexical variations to the circumstance, it allows the chatbot to more accurately direct users & provide an appropriate response.

### Data Cleaning
Secondly, as the chat allowed any input from users, we reduced data inconsistencies by performing a few operations. This is listed in the table below.

| Operation | Intended Outcome |
|----------|----------|
| Using *Upper()* on all queried outputs| This helps to account for different capitalization by making all entries capitalized.|
| Replace punctuations with spaces | Punctuations provide less insight on the user's intent & will increase the variation of user inputs|

### Feature Extraction
MySQL provides a SOUNDEX function, which generates a phonetic code of the word based on their pronunciation. We used this as a form of stemming to reduce them to their basic form

<img width="562" height="199" alt="image" src="https://github.com/user-attachments/assets/63d286e0-8a1a-4d92-9346-9e9b35edd8a7" />

As a result, we simplified the keyword dictionary to only include the SOUNDEX code.

In addition, we used the Levenshtein distance function that helps determine the differences between strings. It counts the number of required operations, including insertions/deletions or substitutions, to make two different string identical to each other. 

<img width="564" height="200" alt="image" src="https://github.com/user-attachments/assets/e0e23dfd-6c95-451d-bf9c-cb1306e0c52a" />

This helped to account for common mispellings by users. We capped the distance value at 2, to provide a suitable margin of error. 





