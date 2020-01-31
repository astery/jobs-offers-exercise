# Jobs offers exercise

Exercise description located at `exercise_description.pdf`

## 01 / 03 . Exercise: Continents grouping

There is no need to read in sax-way for such small file but let's do 
because we can.

Run `mix show_continents_stats | less -S`. `less` is needed to get
horizontal scrolling to comfortably view wide table.

## 02 / 03 . Question: Scaling

In the previous example at script start we load file and emit
events to update stats.

With huge database and huge event stream we can do the same.
At start read current state or replay history of events and
update stats on events arrival.

It can be done via db tools like `view` and `triggers` or
can be further decoupled with plain events like in our implementation.

## 03 / 03 . Exercise: API implementation

Challenges are `grouping` and `querying at radius`.
I see two major ways to implement such task:

- Using established db tools like `postgres with postgis`
- Implementing storage structures and algorithms specially for task

First faster to develop, has operational costs.
Second potentially executes faster, but harder to develop and prone 
to error.

I'll go for second path and use simple bruteforce approach because we 
have a such small dataset - check every offer if it in given radius.
Alternative is to use some sorted structure to faster search for x, y
boundaries and after that check for radius in corners.

Endpoint located here - http://localhost:4000/api/offers?lon=2.305791&lat=48.8661039&radius=50

# Taken time

- 1 - Wondering about task
- 2 - Adding counter for continent statistic
- 2 - Adding mix task for loading from files
- 1 - Adding function to get continent names from points
- 1 - Adding endpoint
- 1 - Fix bugs, adding validation.

8 hours in total
