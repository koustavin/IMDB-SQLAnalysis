SELECT tb.primaryTitle, tr.averageRating , tr.numVotes , count(tcd.directors) AS director_count
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_directors AS tcd ON tb.tconst = tcd.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
AND tb.titleType = 'movie'
GROUP BY 1, 2, 3
HAVING count(tcd.directors) >1
ORDER BY 3 DESC;


SELECT nb.nconst AS Director_id,
nb.primaryName AS Name,
tb.primaryTitle AS Movie_Title,
tr.averageRating AS Movie_Rating,
round(tr.averageRating/count(tr.averageRating) OVER multi_dir, 1) AS Dir_Avg_Rating
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_directors AS tcd  ON tb.tconst = tcd.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcd.directors = nb.nconst
WHERE tb.primaryTitle = 'Avengers: Endgame'
AND tb.titleType = 'movie'
WINDOW multi_dir AS (PARTITION BY tb.tconst);

SELECT nb.nconst AS Director_id,
nb.primaryName AS Name,
tb.primaryTitle AS Movie_Title,
tr.averageRating AS Movie_Rating,
tr.numVotes,
round(tr.averageRating/count(tr.averageRating) OVER multi_dir, 1) AS Dir_Avg_Rating
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_directors AS tcd  ON tb.tconst = tcd.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcd.directors = nb.nconst
WHERE nb.nconst IN ('nm0751648', 'nm0751577')
AND tb.titleType = 'movie'
AND tr.numVotes > 24999
WINDOW multi_dir AS (PARTITION BY tb.tconst);

WITH dir_movie_avgRating AS(
SELECT nb.nconst,
nb.primaryName,
-- tb.primaryTitle AS Movie_Title,
-- tr.averageRating AS Movie_Rating,
tr.averageRating/count(tr.averageRating) OVER multi_dir AS Dir_Avg_Rating
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_directors AS tcd  ON tb.tconst = tcd.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcd.directors = nb.nconst
WHERE nb.nconst IN ('nm0751648', 'nm0751577')
AND tb.titleType = 'movie'
WINDOW multi_dir AS (PARTITION BY tb.tconst))
SELECT nconst AS Director_id,
primaryName AS Name,
round(avg(Dir_Avg_Rating), 2) AS Rating,
count(Dir_Avg_Rating) AS Movie_Count
FROM dir_movie_avgRating
GROUP BY 1, 2;

WITH dir_movie_avgRating AS(
SELECT nb.nconst,
nb.primaryName,
tr.averageRating/count(tr.averageRating) OVER multi_dir AS Dir_Avg_Rating
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_directors AS tcd  ON tb.tconst = tcd.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcd.directors = nb.nconst
WHERE tb.titleType = 'movie'
AND tr.numVotes > 24999
WINDOW multi_dir AS (PARTITION BY tb.tconst))
SELECT nconst AS Director_id,
primaryName AS Name,
round(avg(Dir_Avg_Rating), 2) AS Rating,
count(Dir_Avg_Rating) AS Movie_Count,
DENSE_RANK() OVER w AS Ranking
FROM dir_movie_avgRating
GROUP BY 1, 2
HAVING count(Dir_Avg_Rating) > 2
WINDOW w AS (ORDER BY avg(Dir_Avg_Rating) DESC, count(Dir_Avg_Rating) DESC);


---------------------------------------------------------

SELECT nb.nconst AS Director_id,
nb.primaryName AS Name,
tb.primaryTitle AS Movie_Title,
tbg.genres AS Genre,
tr.averageRating AS Movie_Rating,
round(tr.averageRating/count(tr.averageRating) OVER multi_dir, 2) AS Dir_Avg_Rating
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_directors AS tcd  ON tb.tconst = tcd.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcd.directors = nb.nconst
JOIN imdb.title_basics_genres AS tbg ON tb.tconst = tbg.tconst 
WHERE nb.nconst IN ('nm0751648', 'nm0751577')
AND tb.titleType = 'movie'
WINDOW multi_dir AS (PARTITION BY tb.tconst, tbg.genres);

SELECT nb.nconst AS Director_id,
nb.primaryName AS Name,
tb.primaryTitle AS Movie_Title,
tbg.genres AS Genre,
tr.averageRating AS Movie_Rating,
round(tr.averageRating/count(tr.averageRating) OVER multi_dir, 1) AS Dir_Avg_Rating
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_directors AS tcd  ON tb.tconst = tcd.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcd.directors = nb.nconst
JOIN imdb.title_basics_genres AS tbg ON tb.tconst = tbg.tconst 
WHERE tb.primaryTitle = 'Spider-Man: Into the Spider-Verse'
AND tb.titleType = 'movie'
WINDOW multi_dir AS (PARTITION BY tb.tconst, tbg.genres);

WITH dir_movie_avgRating AS(
SELECT nb.nconst,
nb.primaryName,
tbg.genres,
round(tr.averageRating/(count(tr.averageRating) OVER multi_dir_gen), 2) AS Dir_Avg_Rating
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_directors AS tcd  ON tb.tconst = tcd.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcd.directors = nb.nconst
JOIN imdb.title_basics_genres AS tbg ON tb.tconst = tbg.tconst
WHERE tb.titleType = 'movie'
AND tr.numVotes > 24999
WINDOW multi_dir_gen AS (PARTITION BY tb.tconst, tbg.genres)),
genrewise_rating AS (SELECT
RANK() OVER dir_rank AS Ranking,
nconst AS Director_id,
primaryName AS Name,
genres AS Genre, 
round(avg(Dir_Avg_Rating), 2) AS Rating,
count(Dir_Avg_Rating) AS Movie_Count
FROM dir_movie_avgRating
GROUP BY 2, 3, 4
HAVING count(Dir_Avg_Rating) > 2
WINDOW dir_rank AS (PARTITION BY genres ORDER BY avg(Dir_Avg_Rating) DESC, count(Dir_Avg_Rating) DESC))
SELECT Genre, Ranking, Name, Rating, Movie_Count
FROM genrewise_rating
WHERE Ranking <= 5
ORDER BY 1, 2;