
-- Add ride_length column
ALTER TABLE
  cyclistic.all_trips
DROP COLUMN IF EXISTS
  trip_length;

ALTER TABLE
  cyclistic.all_trips
ADD COLUMN
  ride_length NUMERIC;
  
-- Populate ride_length column
UPDATE
  cyclistic.all_trips
SET
  ride_length = TIME_DIFF(TIME(ended_at), TIME(started_at), SECOND)
WHERE
  ride_length is not NULL AND ended_at >= started_at;

-- Add day_of_week column
ALTER TABLE
  cyclistic.all_trips
ADD COLUMN IF NOT EXISTS
  day_of_week NUMERIC;
-- Populate day_of_week column
UPDATE
  cyclistic.all_trips
SET
  day_of_week = EXTRACT(DAYOFWEEK FROM started_at)
WHERE
  day_of_week is NULL;

-- Add ride_month column
ALTER TABLE
  cyclistic.all_trips
ADD COLUMN IF NOT EXISTS
  ride_month NUMERIC;

-- Populate ride_month column
UPDATE
  cyclistic.all_trips
SET
  ride_month = EXTRACT(MONTH FROM started_at)
WHERE
  ride_month is NULL;

-- Add ride_year column
ALTER TABLE
  cyclistic.all_trips
ADD COLUMN IF NOT EXISTS
  ride_year NUMERIC;
-- Populate ride_year column
UPDATE
  cyclistic.all_trips
SET
  ride_year = EXTRACT(YEAR FROM started_at)
WHERE
  ride_year is NULL;
