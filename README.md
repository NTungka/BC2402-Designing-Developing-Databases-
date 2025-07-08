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
| SIA observed the greatest loss to competitors such as Qatar in terms of **Value for Money**, with dissatisfaction in pricing being a primary issue cited by customers. This was excacerbated during seasonal-periods.| SIA 3.48, Qatar 3.72|
| SIA observed the highest percentage of food-complaints when providing snacks, followed by Lunch Service| A complaint frequency of 24.2% & 23.9% for all food related feedback|
| There are seasonal variations for SIA's ratings versus Qatar's greater consistency| 3.61 ▶️ 3.33 (SIA Food & Beverage from Non-seasonal to Seasonal) |

## Chatbot Development
Ourt team picked up a few unique strategies when coming up with the design principle of the chatbot. The finalized Entity-Relationship Diagram is shown below:

![image](https://github.com/user-attachments/assets/ce9a20c7-4350-4c48-86dd-cfd4c12c526c)

### Data Cleaning






