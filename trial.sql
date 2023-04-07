-- Director Rating
-- I am using title_crew data in it's original form, without splitting for multiple directors.
-- This way we are effectively ignoring the titles with split credit, since it's subjective to decide whether all the directors/writers should get
-- equal credit (or blame) for the titles with shared credits.

SELECT TB.PRIMARYTITLE, TB.ORIGINALTITLE, NB.PRIMARYNAME AS DIRECTOR, TB.TITLETYPE, TB.STARTYEAR, TR.AVERAGERATING, TR.NUMVOTES
FROM IMDB.NAME_BASICS NB
JOIN IMDB.TITLE_CREW TC ON TC.DIRECTORS = NB.NCONST
JOIN IMDB.TITLE_RATINGS TR ON TR.TCONST = TC.TCONST
JOIN IMDB.TITLE_BASICS TB ON TB.TCONST = TR.TCONST
-- AND TB.TITLETYPE = 'movie'
WHERE NB.PRIMARYNAME = 'Kaushik Ganguly';

WITH GLO_AVG AS (
SELECT AVG(AVERAGERATING) AS AVG_RATING, AVG(NUMVOTES) AS AVG_VOTES
FROM IMDB.TITLE_RATINGS)
SELECT
NB.PRIMARYNAME AS DIRECTOR,
AVG(TR.AVERAGERATING) AS AVERAGE_RATING,
AVG(TR.NUMVOTES) AVERAGE_NUMBER_OF_VOTES,
COUNT(TR.AVERAGERATING) TITLE_COUNT
FROM IMDB.NAME_BASICS NB
JOIN IMDB.TITLE_CREW TC ON TC.DIRECTORS = NB.NCONST
JOIN IMDB.TITLE_RATINGS TR ON TR.TCONST = TC.TCONST
JOIN GLO_AVG ON TR.AVERAGERATING > GLO_AVG.AVG_RATING AND TR.NUMVOTES > GLO_AVG.AVG_VOTES
JOIN IMDB.TITLE_BASICS TB ON TB.TCONST = TR.TCONST AND TB.TITLETYPE = 'movie'
GROUP BY NB.PRIMARYNAME
HAVING COUNT(TR.AVERAGERATING) > 4
ORDER BY AVG(TR.AVERAGERATING) DESC;


SELECT
nb.primaryName AS writer_name,
avg(tr.averageRating) AS avg_rating,
avg(tr.numVotes) AS average_num_of_votes,
count(tr.averageRating) AS num_of_abv_avg_titles
FROM
imdb.name_basics AS nb
JOIN imdb.title_crew AS tc ON tc.writers = nb.nconst
JOIN imdb.title_ratings AS tr ON tr.tconst = tc.tconst AND tr.numVotes >= 25000
JOIN imdb.title_basics AS tb ON tb.tconst = tr.tconst AND tb.titleType = 'movie'
GROUP BY nb.primaryName
-- HAVING count(tr.averageRating) > 4
ORDER BY avg(tr.averageRating) DESC;