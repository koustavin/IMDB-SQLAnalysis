SELECT tb.primaryTitle, tr.averageRating, tr.numVotes 
FROM imdb.title_basics AS tb
JOIN imdb.title_ratings AS tr  USING (tconst)
WHERE tb.titleType = 'movie'
ORDER BY tr.averageRating DESC;

SELECT ROW_NUMBER() OVER rating_window AS Ranking,
tb.originalTitle AS Title,
tb.startYear AS Release_Year,
tr.averageRating AS Rating,
tr.numVotes AS NumVotes
FROM imdb.title_basics AS tb
JOIN imdb.title_ratings AS tr  USING (tconst)
JOIN imdb.title_basics_genres AS tbg USING (tconst)
WHERE tb.titleType = 'movie'
AND tbg.genres = 'Action'
AND tr.numVotes >= 25000
WINDOW rating_window AS (ORDER BY tr.averageRating DESC, tr.numVotes DESC);

SELECT *
FROM imdb.title_basics AS tb
WHERE tb.primaryTitle  =  'RRR'
AND tb.titleType = 'movie';

WITH movie AS (
SELECT tb.tconst AS TitleId
FROM imdb.title_basics AS tb
WHERE tb.originalTitle = 'Sardar Udham')
SELECT *
FROM imdb.title_akas AS ta
JOIN movie ON movie.TitleId = ta.titleId;

WITH movie AS (
SELECT tb.tconst AS TitleId
FROM imdb.title_basics AS tb
WHERE tb.primaryTitle = 'Swades')
SELECT *
FROM imdb.title_akas AS ta
JOIN movie ON movie.TitleId = ta.titleId;

WITH movie AS (
SELECT tb.tconst AS TitleId
FROM imdb.title_basics AS tb
WHERE tb.primaryTitle = 'Sholay')
SELECT *
FROM imdb.title_akas AS ta
JOIN movie ON movie.TitleId = ta.titleId;

WITH movie AS (
SELECT tb.tconst AS TitleId
FROM imdb.title_basics AS tb
WHERE tb.primaryTitle = 'Lokkhi Chele (An Angel\'s Kiss)'
AND tb.titleType = 'movie')
SELECT ta.*
FROM imdb.title_akas AS ta
JOIN movie ON movie.TitleId = ta.titleId;

SELECT *
FROM imdb.title_akas as ta 
WHERE ta.region = 'TR'
AND ta.`ordering` = 1;

WITH movie AS (
SELECT tb.tconst AS TitleId
FROM imdb.title_basics AS tb
WHERE tb.primaryTitle = 'RRR'
AND tb.titleType = 'movie')
SELECT ta.*
FROM imdb.title_akas AS ta
JOIN movie ON movie.TitleId = ta.titleId;

WITH movie AS (
SELECT tb.tconst AS TitleId
FROM imdb.title_basics AS tb
WHERE tb.primaryTitle = 'RRR'
AND tb.titleType = 'movie')
SELECT ta.*
FROM imdb.title_akas AS ta
JOIN movie ON movie.TitleId = ta.titleId
WHERE ta.region = 'IN' OR ta.region IS NULL;

SELECT *
FROM imdb.title_akas AS ta 
WHERE ta.isOriginalTitle = 1
AND (ta.region IS NOT NULL OR ta.`language` IS NOT NULL);

SELECT count(*)
FROM imdb.title_basics AS tb;