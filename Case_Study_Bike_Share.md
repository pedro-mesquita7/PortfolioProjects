Case_Study_Bike_Share
================
Pedro Mesquita
2022-05-10

# Intro

In the final step to finish my Google Data Analytics Certificate, I was
introduced to resolve an optional case study to display and to put to
the test my new learned skills. I’m happy that I opted to do it because
technical skills can get more understood and developed when I put them
into practice.

Scenario: in the provided prompt, I’m a data analyst working at
Cyclistic (fictitious bike-sharing company). The company wants to design
a new marketing strategy with the goal of converting casual riders into
annual members. But first, they want to know how casual riders and
annual members use bikes differently.

As learned in this course, I will explore this case study with the 6
phases of data analysis (Ask, Prepare, Process, Analyze, Share and Act.

# PHASE 1 - ASK

The finance department at Cyclistic has determined that annual members
are the more profitable customer type and are trying to create a
campaign aimed at converting casual riders to annual members. To help
them complete this business task, the finance team has assigned me with
answering the following question: “How do annual members and casual
riders use Cyclistic bikes differently?”

# PHASE 2 - PREPARE and PHASE 3 - PROCESS

To answer the question asked, I will store the historical bike trip data
from the company, which is in 12 csv files corresponding to 12 months of
the year 2021.

But is this a good data source? Let’s find out if it meets the following
criteria: \* Reliable: it’s accurate, complete, and unbiased, because
every bike trip was registered in the source files and so this reflects
the overall population of users. \* Original: the original data source
was found \* Comprehensive: there is no missing information in the data
to answer the question \* Current: the data used in this project is
recent and it is updated regularly (every month) \* Cited: this source
has been cited by other students of Google Data Analytics

There are some key facts or constraints about the data: \* Each month
contains every single trip that has occurred \* There is no customer
information, in order to respect the privacy of the users \* The data
should have no trips shorter than 1 minute or longer than 1 day. Any
data that does not fit these constraints should be removed as it is a
maintenance trip carried out by the Cyclistic team, or the bike has been
stolen.

Note: The dataset used in this project can be found
[here](https://divvy-tripdata.s3.amazonaws.com/index.html). This data is
anonymized to ensure privacy, but it limits the extent of the analysis
possible. The data is released under this
[license](https://ride.divvybikes.com/data-license-agreement).

## Load Packages

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──

    ## ✔ ggplot2 3.3.5     ✔ purrr   0.3.4
    ## ✔ tibble  3.1.6     ✔ dplyr   1.0.9
    ## ✔ tidyr   1.2.0     ✔ stringr 1.4.0
    ## ✔ readr   2.1.2     ✔ forcats 0.5.1

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following objects are masked from 'package:base':
    ## 
    ##     date, intersect, setdiff, union

``` r
library(janitor)
```

    ## 
    ## Attaching package: 'janitor'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     chisq.test, fisher.test

``` r
library(dplyr)
library(scales)
```

    ## 
    ## Attaching package: 'scales'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     discard

    ## The following object is masked from 'package:readr':
    ## 
    ##     col_factor

``` r
library(mapview)
```

## Load the Data

Loading all the csv files (12) in the folder and assigning them to a
data frame.

``` r
original_df <- dir("01_Sources", full.name =T) %>% 
  map_df(read_csv)
```

    ## Rows: 96834 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...
    ## dbl  (4): start_lat, start_lng, end_lat, end_lng
    ## dttm (2): started_at, ended_at
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 49622 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...
    ## dbl  (4): start_lat, start_lng, end_lat, end_lng
    ## dttm (2): started_at, ended_at
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 228496 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...
    ## dbl  (4): start_lat, start_lng, end_lat, end_lng
    ## dttm (2): started_at, ended_at
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 337230 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...
    ## dbl  (4): start_lat, start_lng, end_lat, end_lng
    ## dttm (2): started_at, ended_at
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 531633 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...
    ## dbl  (4): start_lat, start_lng, end_lat, end_lng
    ## dttm (2): started_at, ended_at
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 729595 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...
    ## dbl  (4): start_lat, start_lng, end_lat, end_lng
    ## dttm (2): started_at, ended_at
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 822410 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...
    ## dbl  (4): start_lat, start_lng, end_lat, end_lng
    ## dttm (2): started_at, ended_at
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 804352 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...
    ## dbl  (4): start_lat, start_lng, end_lat, end_lng
    ## dttm (2): started_at, ended_at
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 756147 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...
    ## dbl  (4): start_lat, start_lng, end_lat, end_lng
    ## dttm (2): started_at, ended_at
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 631226 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...
    ## dbl  (4): start_lat, start_lng, end_lat, end_lng
    ## dttm (2): started_at, ended_at
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 359978 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...
    ## dbl  (4): start_lat, start_lng, end_lat, end_lng
    ## dttm (2): started_at, ended_at
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
    ## Rows: 247540 Columns: 13
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (7): ride_id, rideable_type, start_station_name, start_station_id, end_...
    ## dbl  (4): start_lat, start_lng, end_lat, end_lng
    ## dttm (2): started_at, ended_at
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
df <- original_df
```

## Transform the Data

### Creating new columns

Calculating the ride length of each ride and turning it into a numeric
value.

``` r
df <- mutate(df, ride_length = ended_at - started_at)
df$ride_length <- as.numeric(as.character(df$ride_length)) 
```

Adding columns that list date, year, month, day, day of the week and
time started of each ride. This will allow us to aggregate ride data for
each month, day, or year … before completing these operations we could
only aggregate at the ride level.

``` r
df$date <- as.Date(df$started_at) 
df$year <- format(as.Date(df$started_at), "%Y")
df$month <- format(as.Date(df$started_at), "%m")
df$day <- format(as.Date(df$started_at), "%d")
df$day_of_week <- format(as.Date(df$started_at), "%A")
df$time <- format(df$started_at, format= "%H:%M")
```

## Clean the Data

### Filtering irrelevant data

In this analysis I will NOT consider the following criteria: \* trips
that took less than a 60 seconds, as it is probably a maintenance; \*
trips that took more than a day (86400 sec), as I consider this as a
stolen bike.

``` r
df <- filter(df, ride_length > 60)
df <- filter(df, ride_length < 86400)
```

## Filtering Outliers

### Calculating the Z-Score

Calculating the mean, standard deviation and zscore. And adding the
zscore in a new column.

``` r
df_mean <- mean(df$ride_length)                             
df_sd <- sd(df$ride_length)
df_zscore <- (df$ride_length-mean(df$ride_length))/sd(df$ride_length)
df <- data.frame(df, df_zscore)
```

### Removing rows that have a zscore +/- 3 and add back to the

Filtering the data frame with data points that have a zscore less than 3
and removing the zscore column from the data frame.

``` r
df <- df[!(df_zscore > 3), ]
df <- subset(df, select = -c(df_zscore))
```

## Renaming columns

Renaming some columns to make the data more readable.

``` r
df <- df %>% 
  rename(trip_id = ride_id, ride_type = rideable_type, user_type = member_casual)
```

# PHASE 4 - ANALYZE

## View the Data

### Data Viz 1 - Number of rides by user type and week day

Ordering the days of the week and creating the first data viz

``` r
df$day_of_week <- ordered(df$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

df %>% 
  group_by(user_type, day_of_week) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(user_type, day_of_week)  %>% 
  ggplot(aes(x = day_of_week, y = number_of_rides, fill = user_type)) +
  geom_col(position = "dodge") +
  xlab('weekdays') + 
  ylab('number of rides') +
  scale_y_continuous(labels = scales::comma) +
  labs(title="Cyclystic: Number of Rides vs. Days of the Week", subtitle = "Comparing casual and member user types", caption="data collected in 2021") + 
  scale_fill_brewer(palette = "Set2")
```

    ## `summarise()` has grouped output by 'user_type'. You can override using the
    ## `.groups` argument.

![](Case_Study_Bike_Share_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

### Data Viz 2 - Average ride duration by user type and week day

``` r
df %>% 
  group_by(user_type, day_of_week) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length/60)) %>% 
  arrange(user_type, day_of_week)  %>% 
  ggplot(aes(x = day_of_week, y = average_duration, fill = user_type)) +
  geom_col(position = "dodge")+
  xlab('weekdays') + 
  ylab('average ride duration') +
  labs(title="Cyclystic: Average ride duration vs. Days of the Week", subtitle = "Comparing casual and member user types", caption="data collected in 2021") + 
  scale_fill_brewer(palette = "Set2")
```

    ## `summarise()` has grouped output by 'user_type'. You can override using the
    ## `.groups` argument.

![](Case_Study_Bike_Share_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

### Data Viz 3 - Number of rides by user type and month

``` r
df$month <- ordered(df$month, levels=c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"))

df %>% 
  group_by(user_type, month) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(user_type, month)  %>% 
  ggplot(aes(x = month, y = number_of_rides, fill = user_type)) +
  geom_col(position = "dodge") +
  xlab('month') + 
  ylab('number of rides') +
  scale_y_continuous(labels = scales::comma) +
  labs(title="Cyclystic: Number of Rides vs. Month", subtitle = "Comparing casual and member user types", caption="data collected in 2021") + 
  scale_fill_brewer(palette = "Set2")
```

    ## `summarise()` has grouped output by 'user_type'. You can override using the
    ## `.groups` argument.

![](Case_Study_Bike_Share_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

# PHASE 5 - SHARE

In this script is presented all the analysis that took place.

# PHASE 6 - ACT

### Key Takeways

-   Casual riders travel more during the weekends, while annual members
    use them consistently over the entire week.
-   Casual riders have a trip duration almost twice greater than the
    annual members.
-   There is a significant usage of bike services in the summer by both
    user types

### Recomendations

Based on the analysis of the data, the following recommendations can be
made to the Cyclistic stakeholders:

-   To convert casual riders into annual members, marketing campaigns
    should be targeted towards weekends (since the greatest number of
    rides by casual riders happens in those days) or summer months
    (since it is when the greatest number of rides happen).
-   It is important to convert casual riders into annual members since
    they have the most average ride duration.
-   Further analysis should be done to determine which casual riders are
    live in Chicago, as these riders are more likely to consider
    obtaining an annual membership compared to a tourist.
