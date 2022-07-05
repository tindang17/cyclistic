install.packages("tidyverse")
install.packages("lubridate")

library(tidyverse)
library(lubridate)

setwd("~/Documents/Google\ Data\ Analytics\ Certificate/Case\ study\ 1/csv")
# STEP 1: Collect data
trip_04_2021 <-read_csv("202104-divvy-tripdata.csv")
trip_05_2021 <-read_csv("202105-divvy-tripdata.csv")
trip_06_2021 <-read_csv("202106-divvy-tripdata.csv")
trip_07_2021 <-read_csv("202107-divvy-tripdata.csv")
trip_08_2021 <-read_csv("202108-divvy-tripdata.csv")
trip_09_2021 <-read_csv("202109-divvy-tripdata.csv")
trip_10_2021 <-read_csv("202110-divvy-tripdata.csv")
trip_11_2021 <-read_csv("202111-divvy-tripdata.csv")
trip_12_2021 <-read_csv("202112-divvy-tripdata.csv")
trip_01_2022 <-read_csv("202201-divvy-tripdata.csv")
trip_02_2022 <-read_csv("202202-divvy-tripdata.csv")
trip_03_2022 <-read_csv("202203-divvy-tripdata.csv")

# STEP 2: Wrangle data and combine into a single file

# Check whether column names are the same across all dataframes
colnames(trip_04_2021)
colnames(trip_05_2021)
colnames(trip_06_2021)
colnames(trip_07_2021)
colnames(trip_08_2021)
colnames(trip_09_2021)
colnames(trip_10_2021)
colnames(trip_11_2021)
colnames(trip_12_2021)
colnames(trip_01_2022)
colnames(trip_02_2022)
colnames(trip_03_2022)

# Inspect the data frames and look for incongruencies
str(trip_04_2021)
str(trip_05_2021)
str(trip_06_2021)
str(trip_07_2021)
str(trip_08_2021)
str(trip_09_2021)
str(trip_10_2021)
str(trip_11_2021)
str(trip_12_2021)
str(trip_01_2022)
str(trip_02_2022)
str(trip_03_2022)

# Combine every month into a annual data frame
all_trips <- bind_rows(
  trip_04_2021, 
  trip_05_2021, 
  trip_06_2021, 
  trip_07_2021, 
  trip_08_2021,
  trip_09_2021,
  trip_10_2021,
  trip_11_2021,
  trip_12_2021,
  trip_01_2022, 
  trip_02_2022, 
  trip_03_2022
)

# STEP3: Clean up and add data to prepare for analysis

#inspect the new table
colnames(all_trips)
nrow(all_trips)
dim(all_trips)
head(all_trips)
str(all_trips)
summary(all_trips)

# Add columns that list the date, month, day, and year of each ride
all_trips$date <- as.Date(all_trips$started_at)
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

# Add a "ride_length" calculation to all_trips (in seconds)
all_trips$ride_length <- difftime(all_trips$ended_at, all_trips$started_at)

# Remove negative ride length
all_trips_v2 <- all_trips[!(all_trips$ride_length < 0),]

# STEP 4: Export summary file for further cleaning
write.csv(all_trips, "~/Documents/Google\ Data\ Analytics\ Certificate/Case\ study\ 1/csv/avg_ride_length.csv")
