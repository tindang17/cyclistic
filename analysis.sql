--Overall average ride length
SELECT
  AVG(ride_length) as average_ride_length 
FROM 
  `unique-result-230022.cyclistic.all_trips` 
WHERE
  ride_length is not NULL
LIMIT 
  1000;

--Longest ride
SELECT
  started_at,
  ended_at,
  member_casual,
  MAX(ride_length) as max_trip_length
FROM 
  `unique-result-230022.cyclistic.all_trips` 
WHERE
  ride_length is not NULL
GROUP BY
  started_at, ended_at, member_casual
ORDER BY
  max_trip_length DESC
LIMIT 
  1;

--Compare member vs casual riders
SELECT
  member_casual,
  MAX(ride_length) as max_trip_length,
  MIN(ride_length) as min_trip_length,
  ROUND(AVG(ride_length), 2) as average_ride_length,
  COUNT(DISTINCT ride_id) as total_trips
FROM
  cyclistic.all_trips
WHERE
  ride_length is not NULL AND ride_length  >= 0
GROUP BY
  member_casual;


--Average trip length per day
SELECT
  member_casual,
  CASE
    WHEN day_of_week = 1 THEN "Sunday"
    WHEN day_of_week = 2 THEN "Monday"
    WHEN day_of_week = 3 THEN "Tueday"
    WHEN day_of_week = 4 THEN "Wednesday"
    WHEN day_of_week = 5 THEN "Thursday"
    WHEN day_of_week = 6 THEN "Friday"
    WHEN day_of_week = 7 THEN "Saturday" 
    ELSE "NA" END AS day,
  AVG(ride_length) as average_ride_length_sec
FROM
  cyclistic.all_trips
WHERE
  ride_length is not NULL and ride_length >= 0
GROUP BY
  day, member_casual
ORDER BY
  day, member_casual;

--Total number of rides
SELECT
  member_casual,
  COUNT(ride_id) as total_trips
FROM
  cyclistic.all_trips
WHERE
  ride_length is not NULL and ride_length >= 0
GROUP BY
  member_casual;

--Total number of rides per day
SELECT
    member_casual,
  CASE
    WHEN day_of_week = 1 THEN FORMAT_DATE("%A", started_at)
    WHEN day_of_week = 2 THEN FORMAT_DATE("%A", started_at)
    WHEN day_of_week = 3 THEN FORMAT_DATE("%A", started_at)
    WHEN day_of_week = 4 THEN FORMAT_DATE("%A", started_at)
    WHEN day_of_week = 5 THEN FORMAT_DATE("%A", started_at)
    WHEN day_of_week = 6 THEN FORMAT_DATE("%A", started_at)
    WHEN day_of_week = 7 THEN FORMAT_DATE("%A", started_at) END AS day,
  COUNT(ride_id) as total_trips
FROM
  cyclistic.all_trips
WHERE
  ride_length is not NULL and ride_length >= 0
GROUP BY
  day, member_casual
ORDER BY
  day, member_casual;

--Popular ride time
SELECT
  member_casual,
  CASE 
    WHEN EXTRACT(HOUR FROM started_at) >= 1 AND EXTRACT(HOUR FROM started_at) < 6 THEN "Early Morning"
    WHEN EXTRACT(HOUR FROM started_at) >= 6 AND EXTRACT(HOUR FROM started_at) < 12 THEN "Morning"
    WHEN EXTRACT(HOUR FROM started_at) >= 12 AND EXTRACT(HOUR FROM started_at) < 18 THEN "Afternoon"
    WHEN EXTRACT(HOUR FROM started_at) >= 18 AND EXTRACT(HOUR FROM started_at) < 24 THEN "Night"
    ELSE "Midnight" END AS part_of_day,
  COUNT(ride_id) as total_trips
FROM
  cyclistic.all_trips
WHERE
  ride_length is not NULL
GROUP BY
  part_of_day, member_casual
ORDER BY
  part_of_day, member_casual;
-- Average trip length of different intervals in a day
SELECT
  member_casual,
  CASE 
    WHEN EXTRACT(HOUR FROM started_at) >= 1 AND EXTRACT(HOUR FROM started_at) < 6 THEN "1AM - 6AM"
    WHEN EXTRACT(HOUR FROM started_at) >= 6 AND EXTRACT(HOUR FROM started_at) < 12 THEN "6AM - 12PM"
    WHEN EXTRACT(HOUR FROM started_at) >= 12 AND EXTRACT(HOUR FROM started_at) < 18 THEN "12PM - 18PM"
    WHEN EXTRACT(HOUR FROM started_at) >= 18 AND EXTRACT(HOUR FROM started_at) < 24 THEN "18PM - 0AM"
    ELSE "Midnight" END AS part_of_day,
  AVG(ride_length) as average_ride_length_sec
FROM
  cyclistic.all_trips
WHERE
  ride_length >= 0
GROUP BY
  part_of_day, member_casual
ORDER BY
  part_of_day, member_casual;
--popular months
SELECT
  ride_month,
  COUNT(ride_id) as total_trips
FROM
  cyclistic.all_trips
WHERE
  ride_length is not NULL
GROUP BY
  ride_month
ORDER BY
  total_trips DESC;

--popular season
SELECT
  CASE 
    WHEN ride_month BETWEEN 3 AND 5 THEN "Spring"
    WHEN ride_month BETWEEN 6 AND 8 THEN "Summer"
    WHEN ride_month BETWEEN 9 AND 11 THEN "Fall"
    ELSE "Winter" END as season,
  COUNT(DISTINCT ride_id) as total_trips
FROM
  cyclistic.all_trips
WHERE
  ride_length is not NULL
GROUP BY
  season
ORDER BY
  total_trips DESC;

--trips percentage of each season
WITH trips AS (
   SELECT
    CASE 
      WHEN ride_month BETWEEN 3 AND 5 THEN "Spring"
      WHEN ride_month BETWEEN 6 AND 8 THEN "Summer"
      WHEN ride_month BETWEEN 9 AND 11 THEN "Fall"
      ELSE "Winter" END as season,
    COUNT(DISTINCT ride_id) as total_trips_per_season,
    (SELECT
      COUNT(DISTINCT ride_id)
    FROM
      cyclistic.all_trips
    WHERE
      ride_length is not NULL
    ) as total_trips
  FROM
    cyclistic.all_trips
  WHERE
    ride_length is not NULL
  GROUP BY
    season
  ORDER BY
    total_trips_per_season DESC
)
SELECT
  *,
  ROUND((total_trips_per_season / total_trips) * 100, 2) as contribution_percent
FROM
  trips;
