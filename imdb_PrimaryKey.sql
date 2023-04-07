use imdb;

SELECT * FROM imdb.title_ratings;

SELECT * FROM imdb.title_akas;

TRUNCATE imdb.title_ratings;

SELECT COUNT(*) FROM imdb.title_ratings;

SELECT COUNT(*) FROM imdb.title_akas
WHERE isOriginalTitle = 1;

/* SELECT MAX(char_length((characters))
FROM imdb.title_principals; */

SELECT * FROM imdb.title_principals
ORDER BY length(characters) DESC
LIMIT 1;

SELECT * FROM imdb.title_akas aka
WHERE aka.titleId = 'tt0398417';

SELECT * FROM imdb.title_ratings LIMIT 50; -- tconst
DELETE FROM imdb.title_ratings WHERE tconst = 'tconst';
ALTER TABLE imdb.title_ratings ADD PRIMARY KEY(tconst);
ALTER TABLE title_ratings ADD FOREIGN KEY (tconst) REFERENCES title_basics(tconst) ON DELETE CASCADE;

SELECT * FROM imdb.title_principals LIMIT 50; -- tconst, nconst, ordering
ALTER TABLE imdb.title_principals ADD PRIMARY KEY(tconst, nconst, ordering);
ALTER TABLE imdb.title_principals DROP PRIMARY KEY;

SELECT * FROM imdb.title_episode LIMIT 50; -- tconst
ALTER TABLE imdb.title_episode ADD PRIMARY KEY(tconst);

SELECT * FROM imdb.title_crew LIMIT 50; -- tconst
ALTER TABLE imdb.title_crew ADD PRIMARY KEY(tconst);

SELECT * FROM imdb.title_basics LIMIT 50; -- tconst
ALTER TABLE imdb.title_basics ADD PRIMARY KEY(tconst);

SELECT * FROM imdb.title_akas LIMIT 5; -- index titleId
ALTER TABLE imdb.title_akas ADD PRIMARY KEY(titleId, ordering);

SELECT * FROM imdb.name_basics LIMIT 50; -- nconst
ALTER TABLE imdb.name_basics ADD PRIMARY KEY(nconst);

SELECT * FROM imdb.title_crew LIMIT 50; -- tconst
ALTER TABLE imdb.title_crew ADD PRIMARY KEY(tconst);