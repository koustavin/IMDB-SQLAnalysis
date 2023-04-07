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

SELECT nb.primaryName , tbg.genres , tb.primaryTitle , tr.averageRating , tr.numVotes 
FROM imdb.title_basics as tb 
JOIN imdb.title_crew_directors as tcd ON tb.tconst = tcd.tconst 
JOIN imdb.name_basics as nb ON nb.nconst = tcd.directors 
JOIN imdb.title_basics_genres as tbg ON tb.tconst = tbg.tconst 
JOIN imdb.title_ratings as tr ON tb.tconst = tr.tconst AND tr.numVotes >= 25000
WHERE nb.primaryName = 'Peter Jackson';


--------------------------------------------------------------------------------------------------------------------------

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
