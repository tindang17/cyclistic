SELECT
  *
FROM 
  `unique-result-230022.cyclistic.all_trips`
ORDER BY
  started_at
LIMIT 1000;
-- CLEAN AND PREPARE 2021_04 table
ALTER TABLE
  cyclistic.all_trips
DROP COLUMN IF EXISTS
  trip_length;

ALTER TABLE
  cyclistic.all_trips
ADD COLUMN
  ride_length NUMERIC;

UPDATE
  cyclistic.all_trips
SET
  ride_length = TIME_DIFF(TIME(ended_at), TIME(started_at), SECOND)
WHERE
  ride_length is not NULL AND ended_at >= started_at;

ALTER TABLE
  cyclistic.all_trips
ADD COLUMN IF NOT EXISTS
  day_of_week NUMERIC;

UPDATE
  cyclistic.all_trips
SET
  day_of_week = EXTRACT(DAYOFWEEK FROM started_at)
WHERE
  day_of_week is NULL;

ALTER TABLE
  cyclistic.all_trips
ADD COLUMN IF NOT EXISTS
  ride_month NUMERIC;

UPDATE
  cyclistic.all_trips
SET
  ride_month = EXTRACT(MONTH FROM started_at)
WHERE
  ride_month is NULL;

ALTER TABLE
  cyclistic.all_trips
ADD COLUMN IF NOT EXISTS
  ride_year NUMERIC;

UPDATE
  cyclistic.all_trips
SET
  ride_year = EXTRACT(YEAR FROM started_at)
WHERE
  ride_year is NULL;
