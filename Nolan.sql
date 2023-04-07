WITH dir_total_movie_count AS (
SELECT tcd_tot.directors, count(tr_tot.averageRating) AS Total_Movie_Count
FROM imdb.title_ratings AS tr_tot
JOIN imdb.title_crew_directors AS tcd_tot ON tr_tot.tconst = tcd_tot.tconst AND tr_tot.numVotes > 24999
GROUP BY tcd_tot.directors),
dir_movie_avgRating AS(
SELECT nb.nconst,
nb.primaryName,
tbg.genres,
tb.primaryTitle,
round(tr.averageRating/(count(tr.averageRating) OVER multi_dir_gen), 2) AS Dir_Avg_Rating
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_directors AS tcd  ON tb.tconst = tcd.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcd.directors = nb.nconst
JOIN imdb.title_basics_genres AS tbg ON tb.tconst = tbg.tconst
WHERE tb.titleType = 'movie'
AND tr.numVotes > 24999
AND nb.primaryName = 'Christopher Nolan'
WINDOW multi_dir_gen AS (PARTITION BY tb.tconst, tbg.genres)),
dir_genre_avgRating AS (
SELECT
RANK() OVER dir_rank AS Ranking,
nconst AS Director_id,
primaryName AS Name,
genres AS Genre, 
round(avg(Dir_Avg_Rating), 2) AS Rating,
count(Dir_Avg_Rating) AS Movie_Count,
Total_Movie_Count
FROM dir_movie_avgRating
JOIN dir_total_movie_count ON dir_total_movie_count.directors = dir_movie_avgRating.nconst AND dir_total_movie_count.Total_Movie_Count > 2
GROUP BY 2, 3, 4
WINDOW dir_rank AS (PARTITION BY genres ORDER BY avg(Dir_Avg_Rating) DESC, count(Dir_Avg_Rating) DESC))
SELECT Genre, Ranking, Name, Rating, Movie_Count, Total_Movie_Count
FROM dir_genre_avgRating
WHERE Ranking <= 5
ORDER BY 1, 2;

SELECT tcd.directors, count(tr.averageRating) AS Total_Movie_Count
FROM imdb.title_ratings AS tr
JOIN imdb.title_crew_directors AS tcd ON tr.tconst = tcd.tconst AND tr.numVotes > 24999
GROUP BY tcd.directors;
