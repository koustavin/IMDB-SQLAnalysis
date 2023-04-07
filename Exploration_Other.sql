WITH season_episode_count AS (
SELECT te.parentTconst, max(te.seasonNumber) AS NumberOfSeasons, count(te.episodeNumber) AS NumberOfEpisodes
FROM imdb.title_episode AS te
GROUP BY 1)
SELECT
RANK() OVER ranking AS Ranking,
tb.tconst AS TVSeries_Id,
tb.primaryTitle AS Title,
tb.genres AS Genres,
tr.averageRating AS Rating,
tr.numVotes AS NumberOfVotes,
tb.startYear AS Started,
tb.endYear AS Ended,
NumberOfSeasons,
NumberOfEpisodes
FROM imdb.title_basics AS tb
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst AND tb.titleType = 'tvSeries' AND tr.numVotes > 24999
JOIN season_episode_count ON tb.tconst = season_episode_count.parentTconst
WINDOW ranking AS (ORDER BY tr.averageRating DESC, tr.numVotes DESC)
LIMIT 50;.

SELECT tb.primaryTitle, tb.startYear, tb.genres , tr.averageRating , tr.numVotes 
FROM imdb.title_basics as tb 
JOIN imdb.title_ratings as tr ON tb.tconst = tr.tconst 
AND tb.titleType = 'tvMiniSeries'
AND tr.numVotes >= 5000
ORDER BY tr.averageRating DESC, tr.numVotes DESC;

------------------------------------------------------------------------------------------------------------------

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

---------------------------------------------------------------------------------------------------------------------

SELECT tb.primaryTitle, tb.startYear, tb.genres , tr.averageRating , tr.numVotes 
FROM imdb.title_basics as tb 
JOIN imdb.title_ratings as tr ON tb.tconst = tr.tconst 
AND tb.titleType = 'tvEpisode'
AND tr.numVotes >= 5000
ORDER BY tr.averageRating DESC, tr.numVotes DESC;

SELECT tb.primaryTitle AS ParentTitle, te.parentTconst AS ParentId, max(te.seasonNumber) AS NumberOfSeasons, count(te.episodeNumber) AS NumberOfEpisodes, tr.averageRating AS ParentRating
FROM imdb.title_episode AS te
JOIN imdb.title_basics AS tb ON tb.tconst = te.parentTconst AND tb.titleType IN ('tvSeries', 'tvMiniSeries')
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
GROUP BY tb.primaryTitle, te.parentTconst, tr.averageRating;

WITH season_episode_count AS (
SELECT te.parentTconst, max(te.seasonNumber) AS NumberOfSeasons, count(te.episodeNumber) AS NumberOfEpisodes
FROM imdb.title_episode AS te
GROUP BY 1)
SELECT tb.primaryTitle AS ParentTitle,
parentTconst AS ParentId,
NumberOfSeasons,
NumberOfEpisodes,
tr.averageRating AS ParentRating
FROM season_episode_count AS sec
JOIN imdb.title_basics AS tb ON tb.tconst = sec.parentTconst AND tb.titleType IN ('tvSeries', 'tvMiniSeries')
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst;

SELECT DISTINCT tb.titleType
FROM imdb.title_episode AS te
JOIN imdb.title_basics AS tb ON tb.tconst = te.parentTconst;

SELECT DISTINCT tb.titleType
FROM imdb.title_basics AS tb;

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