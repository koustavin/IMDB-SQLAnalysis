ALTER TABLE title_ratings ADD FOREIGN KEY (tconst) REFERENCES title_basics(tconst) ON DELETE CASCADE;

SELECT * FROM imdb.title_basics tb
WHERE tb.tconst NOT IN
(SELECT tr.tconst FROM imdb.title_ratings tr);

SELECT tr.tconst
FROM imdb.title_ratings tr
LEFT JOIN imdb.title_basics tb
ON tr.tconst = tb.tconst
WHERE tb.tconst is NULL;

SELECT te.tconst
FROM imdb.title_episode te
LEFT JOIN imdb.title_basics tb
ON te.tconst = tb.tconst
WHERE tb.tconst is NULL;

SELECT * FROM imdb.title_basics tb
WHERE tb.originalTitle LIKE '%Batman%';

SELECT DISTINCT titleId, title FROM
imdb.title_akas
WHERE titleId IN
('tt11957490',
'tt15088914',
'tt16767666',
'tt25957158'); -- 3 titles

SELECT * FROM
imdb.title_basics
WHERE tconst IN
('tt11957490',
'tt15088914',
'tt16767666',
'tt25957158'); -- no records

SELECT * FROM
imdb.title_episode
WHERE tconst IN
('tt11957490',
'tt15088914',
'tt16767666',
'tt25957158'); -- 1 record

SELECT * FROM
imdb.title_episode
WHERE parentTconst IN
('tt11957490',
'tt15088914',
'tt16767666',
'tt25957158'); -- multiple episodes under parent tt11957490

SELECT * FROM
imdb.title_principals
WHERE tconst IN
('tt11957490',
'tt15088914',
'tt16767666',
'tt25957158'); -- 3 titles

SELECT * FROM
imdb.title_ratings
WHERE tconst IN
('tt11957490',
'tt15088914',
'tt16767666',
'tt25957158'); -- 4 titles