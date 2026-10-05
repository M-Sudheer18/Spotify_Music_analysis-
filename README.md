# Spotify and YouTube Tracks Data Analysis using SQL

![Spotify Logo](https://in.pinterest.com/pin/55591376647347938/)

## Overview
This project involves an analysis of Spotify tracks and their matching YouTube statistics using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. This README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the popularity of tracks using streams, views, likes, and comments.
- Compare performance of tracks across Spotify and YouTube.
- Explore audio features such as danceability, energy, and liveness at the track, album, and artist level.
- Rank artists and tracks using window functions, CTEs, and subqueries.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Spotify and YouTube Dataset](https://www.kaggle.com/datasets/salvatorerastelli/spotify-and-youtube)

## Schema

```sql
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify
(
    artist           VARCHAR(255),
    track            VARCHAR(255),
    album            VARCHAR(255),
    album_type       VARCHAR(50),
    danceability     FLOAT,
    energy           FLOAT,
    loudness         FLOAT,
    speechiness      FLOAT,
    acousticness     FLOAT,
    instrumentalness FLOAT,
    liveness         FLOAT,
    valence          FLOAT,
    tempo            FLOAT,
    duration_min     FLOAT,
    title            VARCHAR(255),
    channel          VARCHAR(255),
    views            FLOAT,
    likes            BIGINT,
    comments         BIGINT,
    licensed         BOOLEAN,
    official_video   BOOLEAN,
    stream           BIGINT,
    energy_liveness  FLOAT,
    most_played_on   VARCHAR(50)
);

-- Verify the data load
SELECT * FROM spotify;
SELECT COUNT(*) FROM spotify;
```

> Adjust column names and types if your imported CSV differs.

## Business Problems and Solutions

### Easy Level

### 1. Retrieve All Tracks with More Than 1 Billion Streams

```sql
SELECT * 
FROM spotify
WHERE stream > 1000000000;
```

**Objective:** Identify the most streamed tracks on Spotify.

### 2. List All Albums Along with Their Respective Artists

```sql
SELECT 
    DISTINCT album, 
    artist
FROM spotify
ORDER BY 1;
```

**Objective:** Map each album to the artist who released it.

### 3. Get the Total Number of Comments for Licensed Tracks

```sql
SELECT 
    SUM(comments) AS total_comments
FROM spotify
WHERE licensed = 'true';
```

**Objective:** Measure audience engagement on licensed tracks.

### 4. Find All Tracks That Belong to the Album Type 'Single'

```sql
SELECT 
    track
FROM spotify
WHERE album_type ILIKE 'single';
```

**Objective:** List all tracks released as singles.

### 5. Count the Total Number of Tracks by Each Artist

```sql
SELECT 
    artist,
    COUNT(*) AS total_no_of_songs
FROM spotify
GROUP BY artist
ORDER BY 2 DESC;
```

**Objective:** Find which artists have the largest catalog in the dataset.

### Medium Level

### 6. Calculate the Average Danceability of Tracks in Each Album

```sql
SELECT 
    album,
    AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;
```

**Objective:** Identify the most danceable albums.

### 7. Find the Top 5 Tracks with the Highest Energy Values

```sql
SELECT 
    track,
    MAX(energy) AS highest_energy
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**Objective:** Retrieve the five most energetic tracks.

### 8. List Tracks with Their Views and Likes Where `official_video = TRUE`

```sql
SELECT
    track,
    SUM(views) AS total_views,
    SUM(likes) AS total_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**Objective:** Show the top 5 official videos by views, along with their likes.

### 9. For Each Album, Calculate the Total Views of All Associated Tracks

```sql
SELECT
    album,
    track,
    SUM(views) AS total_views
FROM spotify
GROUP BY 1, 2
ORDER BY 3 DESC;
```

**Objective:** Show total views per track within each album. To get a single total per album, remove `track` from the `SELECT` and `GROUP BY`.

### 10. Retrieve the Track Names That Have Been Streamed on Spotify More Than on YouTube

```sql
SELECT * 
FROM (
    SELECT
        track,
        COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS streamed_on_youtube,
        COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS streamed_on_spotify
    FROM spotify
    GROUP BY 1
) AS t1
WHERE
    streamed_on_spotify > streamed_on_youtube
    AND streamed_on_youtube <> 0;
```

**Objective:** Use conditional aggregation to find tracks that perform better on Spotify than on YouTube.

### Advanced Level

### 11. Find the Top 3 Most-Viewed Tracks for Each Artist Using Window Functions

```sql
WITH ranking_artist AS
(
    SELECT 
        artist,
        track,
        SUM(views) AS total_views,
        DENSE_RANK() OVER(
            PARTITION BY artist 
            ORDER BY SUM(views) DESC
        ) AS rank
    FROM spotify 
    GROUP BY 1, 2
)
SELECT * 
FROM ranking_artist
WHERE rank <= 3;
```

**Objective:** Sum views per track, rank tracks within each artist with `DENSE_RANK()`, and keep the top 3 for every artist.

### 12. Find Tracks Where the Liveness Score Is Above the Average

```sql
SELECT 
    track, 
    artist,
    liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```

**Objective:** Use a subquery to find tracks that sound more "live" than the typical track.

### 13. Use a `WITH` Clause to Calculate the Difference Between the Highest and Lowest Energy Values for Tracks in Each Album

```sql
WITH cte AS
(
    SELECT 
        album,
        MIN(energy) AS lowest_energy,
        MAX(energy) AS highest_energy 
    FROM spotify
    GROUP BY 1
)
SELECT 
    album,
    highest_energy - lowest_energy AS energy_diff
FROM cte
ORDER BY 2 DESC;
```

**Objective:** Find which albums have the widest range of energy across their tracks.

## SQL Concepts Used

- Aggregation: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `GROUP BY`, `ORDER BY`, `LIMIT`
- Window functions: `DENSE_RANK() OVER (PARTITION BY ...)`
- Subqueries and CTEs (`WITH`)
- Conditional aggregation: `CASE WHEN` inside `SUM`
- Null handling: `COALESCE`
- Filtering and pattern matching: `WHERE`, `ILIKE`, `DISTINCT`

## Findings and Conclusion

- **Popularity:** Filtering by streams, views, likes, and comments highlights the tracks and artists that dominate both platforms.
- **Platform Comparison:** Conditional aggregation shows which tracks are stronger on Spotify than on YouTube.
- **Audio Features:** Danceability, energy, and liveness queries reveal how the sound of tracks and albums varies.
- **Artist Rankings:** Window functions identify each artist's top-performing tracks.
- **Album Insights:** Energy range and view totals per album show how consistent or varied an album is.

This analysis provides a view of music performance across Spotify and YouTube and can help inform playlist curation, marketing, and artist-level decision-making.

## How to Run

1. Create a PostgreSQL database.
2. Run the schema above to create the `spotify` table.
3. Import the Kaggle CSV into the `spotify` table.
4. Run the queries in `Process.sql`.

## Author - [Your Name]

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media:

- **YouTube**: [Add your channel link]
- **Instagram**: [Add your profile link]
- **LinkedIn**: [Add your profile link]
- **GitHub**: [Add your profile link]

Thank you for your support, and I look forward to connecting with you!
