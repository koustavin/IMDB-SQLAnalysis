SELECT tr.*
FROM imdb.title_ratings tr
LEFT JOIN imdb.title_basics tb
ON tr.tconst = tb.tconst
WHERE tb.tconst is NULL;

SELECT te.*
FROM imdb.title_episode te
LEFT JOIN imdb.title_basics tb
ON te.tconst = tb.tconst
WHERE tb.tconst is NULL;

SELECT ta.*
FROM imdb.title_akas ta
LEFT JOIN imdb.title_basics tb
ON ta.titleId = tb.tconst
WHERE tb.tconst IS NULL;

SELECT tc.*
FROM imdb.title_crew tc
LEFT JOIN imdb.title_basics tb
ON tc.tconst = tb.tconst
WHERE tb.tconst IS NULL;

SELECT tp.*
SELECT tp.*
FROM imdb.title_principals tp
LEFT JOIN imdb.title_basics tb
ON tp.tconst = tb.tconst
WHERE tb.tconst IS NULL;