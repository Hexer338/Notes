Notes for Pipeline Aggregations:

Why?
1. Pipeline aggregations are much faster than scripted_metric queries
2. Easily readable and easy to debug
3. Response filtering of ES to remove any unwanted metrics
4. Application of filters will be easier and much faster since we can use Es query filters instead of filters inside script
5. These filters will be cached and will improve performance
6. Extra aggregations are not needed for postReduce functions
7. Functions across multiple tables is possible
8. Is constant inside functions can be supported
9. Bucketing inside functions will be easier
10. All current functions can be supported by existing pipeline aggregations



And maybe we can support pagination inside functions?
And in future, functions can return multiple values



Current Implementation of functions:

A functions mode: `map`|`mapReduce`|`reduce`|`postReduce` is determined by number of arguments and type of arguments.
A function gives all the possible modes to the parent function. Then parent function decides only one mode for the function.
When multiple modes are possible the top function, the order of modes is: `postReduce`|`reduce` > `mapReduce` > `map`
exception for `calc` function.. If there is only arg for `calc` function, it will let the inner function behave as top function if possible

How do parent function decide on the mode of arguments?

`reduce` works on `reduced` args.. there is no ambiguity there
`map` works on `map` args.. there is no ambiguity there
`postReduce` works on `reduced` args.. Here `postReduce` or `reduce` behaviour will be based on number of arguments and this function behaviour is determined by external things.. there is not much confusion in here

confusion comes up with `mapReduce` and `map`. They both take `map` arguments.
One returns `reduced` value while other returns `map` value.
Here number of `args` vary the function mode. if 1 arg then `mapReduce` else `map` functionality
This becomes complex when parent function also has `mapReduce` possibilty
And numbers can be considered as both map/reduce args


Just like postReduce, mapReduce also depends on number of arguments
Buckets inside functions is a problem..
If the number of buckets are too large, we might not be able to aggregate over them

If functions should return multiple values, then we can support pagination
Otherwise also, If pagination has to be done, then they must support `postQuery` mode to handle response from previous requests
so that esQueries can be chained and their results can be displayed to user
But that is too much into future.

Instead returning multiple values seems to be the possible one for now



#### Code Structure
1. Same as the current structure
But for `reduce` mode, child functions will return aggregations instead of script... that is the only change

Constrction of aggs from args has to be formulated


Construction of aggs for map-reduce:
  Based on the function type, use it in script.source

construction of aggs for reduce:
  Use child aggregation aggs in the params

construction of script for map functions:
  use script from aggs just like now

What about filters?
All filters will be either doc-filters of elasticsearch or metric filters
This means there will be seperate transformer for function filters


Sample queries:
sum(sales)
avg(sales)
latest(sales)
calc(sales)


How to write `sum` function? does it take args array? or does it take arguments directly
taking arguments directly seems better.. since it reduces code complexity.













map, mapReduce, reduce, postReduce

map -- generate script 
mapReduce will use scripts | fields

cardinality
terms 


distinctcount(regions, provinces)


sum(sales) where a > 10


sum(sales where sales > 10, profit where profit > 20)
if(sales > profit, sales, profit)


total(yield)/count(sites)



terms
datehistogram
ranges
function






sales by city when diff(sum(sales) across city, avg(sum(sales) across city)) > 0 in states


percentage(sum(sales) across city, avg(sum(sales) across city)) in california

percentageIncrease(total(sales)) across years




percentage(perBucket(sum(sales)), avg(sum(sales) across regions)) across city in california



sales by city when diff(perBucket(sum(sales)), avg(sum(sales))) > 0 in california
this year, last year



percentage(perBucket(sum(sales)), avg(sum(sales) across city)) in city
percentage(sum(sales), )
sales by city when diff(perBucket(sum(sales)), avg(sum(sales) across city)) > 0 in states
