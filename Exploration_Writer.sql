-- Overall Ranking for all Writers having at least 3 movies with at least 25000 votes
WITH wri_movie_avgRating AS(
SELECT nb.nconst,
nb.primaryName,
tr.averageRating/count(tr.averageRating) OVER multi_wri AS Wri_Avg_Rating
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_writers AS tcw  ON tb.tconst = tcw.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcw.writers = nb.nconst
WHERE tb.titleType = 'movie'
AND tr.numVotes > 24999
WINDOW multi_wri AS (PARTITION BY tb.tconst))
SELECT
RANK() OVER wri_rank AS Ranking,
nconst AS Writer_id,
primaryName AS Name,
round(avg(Wri_Avg_Rating), 2) AS Rating,
count(Wri_Avg_Rating) AS Movie_Count
FROM wri_movie_avgRating
GROUP BY 2, 3
HAVING count(Wri_Avg_Rating) > 2
WINDOW wri_rank AS (ORDER BY avg(Wri_Avg_Rating) DESC, count(Wri_Avg_Rating) DESC);

-- GenreWise Breakdown : Writers in the Top 5 Positions for each Genre, satisfying the above criteria for all their movies (at least 3 movies with at least 25000 votes), but having at least 1 movie in that Genre with at least 25000 votes
WITH wri_total_movie_count AS (
SELECT tcw_tot.writers, count(tr_tot.averageRating) AS Total_Movie_Count
FROM imdb.title_ratings AS tr_tot
JOIN imdb.title_crew_writers AS tcw_tot ON tr_tot.tconst = tcw_tot.tconst AND tr_tot.numVotes > 24999
GROUP BY tcw_tot.writers),
wri_movie_avgRating AS(
SELECT nb.nconst,
nb.primaryName,
tbg.genres,
tb.primaryTitle,
round(tr.averageRating/(count(tr.averageRating) OVER multi_wri_gen), 2) AS Wri_Avg_Rating
FROM imdb.title_basics AS tb
JOIN imdb.title_crew_writers AS tcw ON tb.tconst = tcw.tconst
JOIN imdb.title_ratings AS tr ON tb.tconst = tr.tconst 
JOIN imdb.name_basics AS nb ON tcw.writers = nb.nconst
JOIN imdb.title_basics_genres AS tbg ON tb.tconst = tbg.tconst
WHERE tb.titleType = 'movie'
AND tr.numVotes > 24999
WINDOW multi_wri_gen AS (PARTITION BY tb.tconst, tbg.genres)),
wri_genre_avgRating AS (
SELECT
RANK() OVER wri_rank AS Ranking,
nconst AS Writer_id,
primaryName AS Name,
genres AS Genre, 
round(avg(Wri_Avg_Rating), 2) AS Rating,
count(Wri_Avg_Rating) AS Movie_Count,
Total_Movie_Count
FROM wri_movie_avgRating
JOIN wri_total_movie_count ON wri_total_movie_count.writers = wri_movie_avgRating.nconst AND wri_total_movie_count.Total_Movie_Count > 2
GROUP BY 2, 3, 4
WINDOW wri_rank AS (PARTITION BY genres ORDER BY avg(Wri_Avg_Rating) DESC, count(Wri_Avg_Rating) DESC))
SELECT Genre, Ranking, Name, Rating, Movie_Count, Total_Movie_Count
FROM wri_genre_avgRating
WHERE Ranking <= 5
ORDER BY 1, 2;