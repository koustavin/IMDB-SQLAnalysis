SELECT tc.directors, (CHAR_LENGTH(tc.directors) - CHAR_LENGTH(REPLACE(tc.directors, ',', ''))) AS comma_count
FROM imdb.title_crew AS tc 
ORDER BY (CHAR_LENGTH(tc.directors) - CHAR_LENGTH(REPLACE(tc.directors, ',', ''))) DESC
LIMIT 10; -- maximum 491 comma separated values (for 490 commas) for directors in a single row

SELECT tc.writers, (CHAR_LENGTH(tc.writers) - CHAR_LENGTH(REPLACE(tc.writers, ',', ''))) AS comma_count
FROM imdb.title_crew tc
ORDER BY (CHAR_LENGTH(tc.writers) - CHAR_LENGTH(REPLACE(tc.writers, ',', ''))) DESC
LIMIT 10; -- maximum 991 comma separated values for writers in a single row

SELECT nb.knownForTitles, (CHAR_LENGTH(nb.knownForTitles) - CHAR_LENGTH(REPLACE(nb.knownForTitles, ',', ''))) AS comma_count
FROM imdb.name_basics AS nb
ORDER BY (CHAR_LENGTH(nb.knownForTitles) - CHAR_LENGTH(REPLACE(nb.knownForTitles, ',', ''))) DESC
LIMIT 10; -- maximum 6 comma separated values for knownForTitles in a single row

SELECT nb.primaryProfession, (CHAR_LENGTH(nb.primaryProfession) - CHAR_LENGTH(REPLACE(nb.primaryProfession, ',', ''))) AS comma_count
FROM imdb.name_basics AS nb
ORDER BY (CHAR_LENGTH(nb.primaryProfession) - CHAR_LENGTH(REPLACE(nb.primaryProfession, ',', ''))) DESC
LIMIT 10; -- maximum 3 comma separated values for primaryProfession in a single row

SELECT tb.genres, (CHAR_LENGTH(tb.genres) - CHAR_LENGTH(REPLACE(tb.genres, ',', ''))) AS comma_count
FROM imdb.title_basics AS tb
ORDER BY (CHAR_LENGTH(tb.genres) - CHAR_LENGTH(REPLACE(tb.genres, ',', ''))) DESC
LIMIT 10; -- maximum 3 comma separated values for genres in a single row

CREATE TABLE imdb.numbers(
n INT);

SELECT ROW_NUMBER() OVER()
FROM imdb.name_basics as nb
LIMIT 500;

INSERT INTO imdb.numbers
SELECT ROW_NUMBER() OVER()
FROM imdb.name_basics as nb
LIMIT 910;

DELETE FROM imdb.numbers;

WITH table_2_split AS (
SELECT tconst, directors, writers 
FROM imdb.title_crew
ORDER BY LENGTH(writers) DESC
LIMIT 10)
SELECT
  table_2_split.tconst,
  SUBSTRING_INDEX(SUBSTRING_INDEX(table_2_split.directors, ',', numbers.n), ',', -1) AS directors,
  SUBSTRING_INDEX(SUBSTRING_INDEX(table_2_split.writers, ',', numbers.n), ',', -1) AS writers
FROM
  imdb.numbers INNER JOIN table_2_split
  ON (CHAR_LENGTH(table_2_split.directors) - CHAR_LENGTH(REPLACE(table_2_split.directors, ',', ''))) >= (numbers.n-1)
  OR (CHAR_LENGTH(table_2_split.writers) - CHAR_LENGTH(REPLACE(table_2_split.writers, ',', ''))) >= (numbers.n-1);


SELECT nb.primaryProfession , LENGTH(nb.primaryProfession)
FROM imdb.name_basics as nb 
ORDER BY LENGTH(nb.primaryProfession) DESC 
LIMIT 50;