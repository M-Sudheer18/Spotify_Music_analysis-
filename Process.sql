SELECT * 
FROM spotify

-- Retrieve the names of all tracks that have more than 1 billion streams.
SELECT * FROM spotify
WHERE stream > 1000000000;


-- List all albums along with their respective artists.
SELECT 
	DISTINCT album, artist
FROM spotify
ORDER BY 1;


-- Get the total number of comments for tracks where licensed = TRUE.
SELECT 
	SUM(comments) as total_comments
FROM spotify
WHERE licensed = 'true';


-- Find all tracks that belong to the album type single.
SELECT 
	track
FROM spotify
WHERE album_type ILIKE 'single';


-- Count the total number of tracks by each artist.
SELECT 
	artist,
	COUNT(*) as total_noof_songs
FROM spotify
GROUP BY artist
ORDER BY 2 DESC;


-- Calculate the average danceability of tracks in each album.
SELECT 
	album,
	avg(danceability) as avg_da
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;


-- Find the top 5 tracks with the highest energy values.
SELECT 
	track,
	MAX(energy)
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- List all tracks along with their views and likes where official_video = TRUE.
SELECT
  track,
  SUM(views) as total_views,
  SUM(likes) as total_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- For each album, calculate the total views of all associated tracks.
SELECT
  album,
  track,
  SUM(views)
FROM spotify
GROUP BY 1, 2
ORDER BY 3 DESC

-- Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT *
FROM (
  SELECT
    track,
    -- most_played_on,
    COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0)  AS streamed_on_youtube,
    COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0)  AS streamed_on_spotify
  FROM spotify
  GROUP BY 1
) AS t1
WHERE
  streamed_on_spotify > streamed_on_youtube
  AND streamed_on_youtube <> 0;

-- Find the top 3 most-viewed tracks for each artist using window functions.

-- Each artist and total views for each track
-- Track with Highest Views for each artist we need Top 3
-- Dence Rank
-- CTE and Filter Rank <=3

WITH ranking_artist
AS
(
SELECT 
	artist,
	track,
	SUM(views) as total_views,
	DENSE_RANK() OVER(
					PARTITION BY artist ORDER BY SUM(views) DESC 
				) as rank
FROM spotify 
GROUP BY 1, 2
ORDER BY 1, 3 DESC
)
SELECT * 
FROM ranking_artist
WHERE rank <= 3;

-- Write a query to find tracks where the liveness score is above the average.
SELECT 
	track, 
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify); 	


-- Use a WITH clause to calculate the difference between the 
-- highest and lowest energy values for tracks in each album.

WITH cte
AS
(
SELECT 
	album,
	MIN(energy) as lowest_energy,
	MAX(energy) as highest_energy 
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energy as energy_diff
FROM cte
ORDER BY 2 DESC;
















-- Advanced Level
-- Find the top 3 most-viewed tracks for each artist using window functions.
-- Write a query to find tracks where the liveness score is above the average.
-- Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.


















































































































































