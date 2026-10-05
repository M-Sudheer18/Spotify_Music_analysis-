
-- EDA
SELECT * 
FROM spotify
LIMIT 5;

SELECT COUNT(*)
FROM spotify;

SELECT COUNT(DISTINCT album) FROM spotify;
SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT duration_min FROM spotify; 
SELECT MIN(duration_min) FROM spotify; 
SELECT MAX(duration_min) FROM spotify; 

SELECT * 
FROM spotify 
WHERE duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;
SELECT * 
FROM spotify 
WHERE duration_min = 0;

SELECT DISTINCT 
channel FROM spotify;

SELECT DISTINCT 
most_played_on FROM spotify;















































































































