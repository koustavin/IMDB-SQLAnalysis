/*** Calculate Ratings for Directors and Writers for Movies over various Genres ***/

-- Overall Ranking for all Directors having at least 3 movies with at least 25000 votes
SELECT
DENSE_RANK() OVER dir_rank AS Ranking,
nb.nconst AS Director_id,
nb.primaryName AS Name,
round(avg(tr.averageRating), 2) AS Rating,
count(tb.tconst) AS Movie_Count
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_directors AS tcd  ON tb.tconst = tcd.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcd.directors = nb.nconst
WHERE tb.titleType = 'movie'
AND tr.numVotes >= 25000
GROUP BY nb.nconst, nb.primaryName
HAVING count(tb.tconst) >= 3
WINDOW dir_rank AS (ORDER BY avg(tr.averageRating) DESC, count(tb.tconst) DESC);

-- GenreWise Breakdown : Directors in the Top 5 Positions for each Genre, satisfying the above criteria for all their movies (at least 3 movies with at least 25000 votes), but having at least 1 movie in that Genre with at least 25000 votes
WITH dir_genre_avgRating AS(
SELECT
DENSE_RANK() OVER dir_genre_rank AS Genre_Ranking,
nb.nconst AS Director_id,
nb.primaryName AS Name,
tbg.genres AS Genre,
round(avg(tr.averageRating), 2) AS Genre_Rating,
count(tb.tconst) AS Genre_Movie_Count
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_directors AS tcd  ON tb.tconst = tcd.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcd.directors = nb.nconst
JOIN imdb.title_basics_genres AS tbg ON tb.tconst = tbg.tconst
WHERE tb.titleType = 'movie'
AND tr.numVotes >= 25000
GROUP BY nb.nconst, nb.primaryName, tbg.genres 
HAVING count(tb.tconst) >= 3
WINDOW dir_genre_rank AS (PARTITION BY tbg.genres ORDER BY avg(tr.averageRating) DESC, count(tb.tconst) DESC))
SELECT *
FROM dir_genre_avgRating
WHERE Genre_Ranking <= 5
ORDER BY Genre, Genre_Ranking;

-- Overall Ranking for all Writers having at least 3 movies with at least 25000 votes
SELECT
DENSE_RANK() OVER wri_rank AS Ranking,
nb.nconst AS Writer_id,
nb.primaryName AS Name,
round(avg(tr.averageRating), 2) AS Rating,
count(tb.tconst) AS Movie_Count
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_writers AS tcw  ON tb.tconst = tcw.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcw.writers = nb.nconst
WHERE tb.titleType = 'movie'
AND tr.numVotes >= 25000
GROUP BY nb.nconst, nb.primaryName
HAVING count(tb.tconst) >= 3
WINDOW wri_rank AS (ORDER BY avg(tr.averageRating) DESC, count(tb.tconst) DESC);

-- GenreWise Breakdown : Writers in the Top 5 Positions for each Genre, satisfying the above criteria for all their movies (at least 3 movies with at least 25000 votes), but having at least 1 movie in that Genre with at least 25000 votes
WITH wri_genre_avgRating AS(
SELECT
DENSE_RANK() OVER wri_genre_rank AS Genre_Ranking,
nb.nconst AS Writer_id,
nb.primaryName AS Name,
tbg.genres AS Genre,
round(avg(tr.averageRating), 2) AS Genre_Rating,
count(tb.tconst) AS Genre_Movie_Count
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_writers AS tcw ON tb.tconst = tcw.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcw.writers = nb.nconst
JOIN imdb.title_basics_genres AS tbg ON tb.tconst = tbg.tconst
WHERE tb.titleType = 'movie'
AND tr.numVotes >= 25000
GROUP BY nb.nconst, nb.primaryName, tbg.genres 
HAVING count(tb.tconst) >= 3
WINDOW wri_genre_rank AS (PARTITION BY tbg.genres ORDER BY avg(tr.averageRating) DESC, count(tb.tconst) DESC))
SELECT *
FROM wri_genre_avgRating
WHERE Genre_Ranking <= 5
ORDER BY Genre, Genre_Ranking;

/*** Top 50 TV Series (based on Ratings) ***/

WITH season_episode_count AS (
SELECT te.parentTconst AS ShowId,
max(te.seasonNumber) AS TotalSeasons,
count(te.episodeNumber) AS TotalEpisodes
FROM imdb.title_episode AS te
GROUP BY 1),
parent_show AS (
SELECT tb2.primaryTitle AS ParentShowTitle,
tr2.averageRating AS ParentRating,
tb2.tconst AS ParentShowId
FROM imdb.title_basics AS tb2
JOIN imdb.title_ratings AS tr2 ON tb2.tconst = tr2.tconst
								AND tb2.titleType IN ('tvSeries', 'tvMiniSeries'))
SELECT
DENSE_RANK() OVER epi_rank AS `Rank`,
tb.primaryTitle AS EpiTitle,
replace(tb.startYear, ',', '')  AS ReleasedOn,
round(tr.averageRating, 2) AS EpiRating,
tr.numVotes AS EpiVotes,
ParentShowTitle AS ShowTitle,
concat('S', lpad(te2.seasonNumber, 2, '0'), '.E', lpad(te2.episodeNumber, 2, '0')) AS EpiSerial,
TotalSeasons AS TotalSeasons,
TotalEpisodes AS TotalEpisodes,
round(ParentRating, 2) AS ShowRating
FROM imdb.title_basics AS tb
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst
								AND tb.titleType = 'tvEpisode'
								AND tr.numVotes >= 5000
JOIN imdb.title_episode as te2 ON te2.tconst = tb.tconst
JOIN parent_show ON te2.parentTconst = parent_show.ParentShowId
JOIN season_episode_count ON parent_show.ParentShowId = season_episode_count.ShowId
WINDOW epi_rank AS (ORDER BY tr.averageRating DESC, tr.numVotes DESC)
LIMIT 50;


/*** Highest Rated Movies/TV Series from last 5 Years, also compare it with Most Rated (based on Number of Votes) ***/

WITH movie_ranking AS(
SELECT
DENSE_RANK() OVER (PARTITION BY tb.startYear ORDER BY tr.averageRating DESC) AS HighestRatedRanking,
DENSE_RANK() OVER (PARTITION BY tb.startYear ORDER BY tr.numVotes DESC) AS MostVotedRanking,
replace(tb.startYear, ',', '') AS ReleasedOn,
tb.primaryTitle AS Title,
tr.averageRating AS Rating,
tr.numVotes AS NumberOfVotes
FROM imdb.title_basics AS tb
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst
AND tb.startYear BETWEEN 2018 AND 2022
AND tb.titleType = 'movie'
AND tr.numVotes >= 25000)
SELECT
CASE	WHEN (HighestRatedRanking <= 5 AND MostVotedRanking > 5)
					THEN concat('Highest Rated : ', HighestRatedRanking, ' of ', ReleasedOn)
			WHEN (HighestRatedRanking > 5 AND MostVotedRanking <= 5)
					THEN concat('Most Voted : ', MostVotedRanking, ' of ', ReleasedOn)
			WHEN (HighestRatedRanking <= 5 AND MostVotedRanking <= 5)
					THEN concat('Highest Rated : ', HighestRatedRanking, ' & Most Voted : ', MostVotedRanking, ' of ', ReleasedOn)
END AS WhyOnTop,
ReleasedOn AS `Year`,
Title,
round(Rating, 2) AS Rating,
NumberOfVotes
FROM movie_ranking
WHERE HighestRatedRanking <= 5
OR MostVotedRanking <= 5
ORDER BY ReleasedOn, WhyOnTop;


/*** Top 5 Movies from each decade, starting with, say 1980's ***/

WITH movie_decade AS(
SELECT
CASE	WHEN tb.startYear BETWEEN 1980 AND 1989 THEN '1980''s'
			WHEN tb.startYear BETWEEN 1990 AND 1999 THEN '1990''s'
			WHEN tb.startYear BETWEEN 2000 AND 2009 THEN '2000''s'
			WHEN tb.startYear BETWEEN 2010 AND 2019 THEN '2010''s'
			WHEN tb.startYear BETWEEN 2020 AND 2023 THEN '2020''s'
END AS Decade,
DENSE_RANK() OVER (PARTITION BY (
		CASE
			WHEN tb.startYear BETWEEN 1980 AND 1989 THEN '1980''s'
			WHEN tb.startYear BETWEEN 1990 AND 1999 THEN '1990''s'
			WHEN tb.startYear BETWEEN 2000 AND 2009 THEN '2000''s'
			WHEN tb.startYear BETWEEN 2010 AND 2019 THEN '2010''s'
			WHEN tb.startYear BETWEEN 2020 AND 2023 THEN '2020''s'
		END)
	ORDER BY averageRating DESC) AS `Rank`,
count(primaryTitle) OVER (PARTITION BY (
		CASE
			WHEN tb.startYear BETWEEN 1980 AND 1989 THEN '1980''s'
			WHEN tb.startYear BETWEEN 1990 AND 1999 THEN '1990''s'
			WHEN tb.startYear BETWEEN 2000 AND 2009 THEN '2000''s'
			WHEN tb.startYear BETWEEN 2010 AND 2019 THEN '2010''s'
			WHEN tb.startYear BETWEEN 2020 AND 2023 THEN '2020''s'
		END)) AS TotElgblMoviesOfDecade,
tb.primaryTitle,
tb.startYear,
tb.genres,
tr.averageRating,
tr.numVotes 
FROM imdb.title_basics AS tb
JOIN imdb.title_ratings AS tr
ON tb.tconst = tr.tconst
AND tb.startYear >= 1980
AND tb.titleType = 'movie'
AND tr.numVotes >= 25000)
SELECT
Decade,
`Rank`,
primaryTitle AS Title,
replace(startYear, ',', '') AS `Year`,
round(averageRating, 2) AS Rating,
numVotes AS NumberOfVotes,
genres AS Genre,
TotElgblMoviesOfDecade
FROM movie_decade
WHERE `Rank` <= 5;

