CREATE TABLE imdb.num_nb_kft(
n INT); -- numbers table for name_basics.knownForTitles

CREATE TABLE imdb.num_nb_pp(
n INT); -- numbers table for name_basics.primaryProfession

CREATE TABLE imdb.num_tc_dir(
n INT); -- numbers table for title_crew.directors

CREATE TABLE imdb.num_tc_wri(
n INT); -- numbers table for title_crew.writers

CREATE TABLE imdb.num_tb_gen(
n INT); -- numbers table for title_basics.genres

INSERT INTO imdb.num_nb_kft
SELECT ROW_NUMBER() OVER()
FROM imdb.name_basics
LIMIT 6; -- just need to insert 1, 2, 3 ... 6 each in a separate row

INSERT INTO imdb.num_nb_pp
SELECT ROW_NUMBER() OVER()
FROM imdb.name_basics
LIMIT 3;

INSERT INTO imdb.num_tc_dir
SELECT ROW_NUMBER() OVER()
FROM imdb.name_basics
LIMIT 491;

INSERT INTO imdb.num_tc_wri
SELECT ROW_NUMBER() OVER()
FROM imdb.name_basics
LIMIT 991;

INSERT INTO imdb.num_tb_gen
SELECT ROW_NUMBER() OVER()
FROM imdb.name_basics
LIMIT 3;

CREATE TABLE imdb.name_basics_knownForTitles(
nconst VARCHAR(15),
primaryName VARCHAR(200),
birthYear INT,
deathYear INT,
knownForTitles VARCHAR(15));

DROP TABLE imdb.name_basics_primaryProfession;

CREATE TABLE imdb.name_basics_primaryProfession(
nconst VARCHAR(15),
primaryName VARCHAR(200),
birthYear INT,
deathYear INT,
primaryProfession VARCHAR(30));

CREATE TABLE imdb.title_crew_directors(
tconst VARCHAR(15),
directors VARCHAR(15));

CREATE TABLE imdb.title_crew_writers(
tconst VARCHAR(15),
writers VARCHAR(15));

CREATE TABLE imdb.title_basics_genres(
tconst VARCHAR(15),
genres VARCHAR(15));

INSERT INTO imdb.name_basics_knownForTitles(nconst, primaryName, birthYear, deathYear, knownForTitles)
SELECT
  nb.nconst,
  nb.primaryName,
  nb.birthYear,
  nb.deathYear,
  SUBSTRING_INDEX(SUBSTRING_INDEX(nb.knownForTitles, ',', numbers.n), ',', -1) AS knownForTitles
FROM
  imdb.num_nb_kft  AS numbers INNER JOIN imdb.name_basics AS nb
  ON (CHAR_LENGTH(nb.knownForTitles) - CHAR_LENGTH(REPLACE(nb.knownForTitles, ',', ''))) >= (numbers.n - 1);
 
INSERT INTO imdb.name_basics_primaryProfession(nconst, primaryName, birthYear, deathYear, primaryProfession)
SELECT
  nb.nconst,
  nb.primaryName,
  nb.birthYear,
  nb.deathYear,
  SUBSTRING_INDEX(SUBSTRING_INDEX(nb.primaryProfession, ',', numbers.n), ',', -1) AS primaryProfession
FROM
  imdb.num_nb_pp  AS numbers INNER JOIN imdb.name_basics AS nb
  ON (CHAR_LENGTH(nb.primaryProfession) - CHAR_LENGTH(REPLACE(nb.primaryProfession, ',', ''))) >= (numbers.n - 1);
  
 INSERT INTO imdb.title_crew_directors(tconst, directors)
 SELECT
  tc.tconst,
  SUBSTRING_INDEX(SUBSTRING_INDEX(tc.directors, ',', numbers.n), ',', -1) AS directors
FROM
  imdb.num_tc_dir  AS numbers INNER JOIN imdb.title_crew AS tc
  ON (CHAR_LENGTH(tc.directors) - CHAR_LENGTH(REPLACE(tc.directors, ',', ''))) >= (numbers.n - 1);
 
 INSERT INTO imdb.title_crew_writers(tconst, writers)
 SELECT
  tc.tconst,
  SUBSTRING_INDEX(SUBSTRING_INDEX(tc.writers, ',', numbers.n), ',', -1) AS writers
FROM
  imdb.num_tc_wri  AS numbers INNER JOIN imdb.title_crew AS tc
  ON (CHAR_LENGTH(tc.writers) - CHAR_LENGTH(REPLACE(tc.writers, ',', ''))) >= (numbers.n - 1);
   
  INSERT INTO imdb.title_basics_genres(tconst, genres)
 SELECT
  tb.tconst,
  SUBSTRING_INDEX(SUBSTRING_INDEX(tb.genres, ',', numbers.n), ',', -1) AS genres
FROM
  imdb.num_tb_gen AS numbers INNER JOIN imdb.title_basics AS tb
  ON (CHAR_LENGTH(tb.genres) - CHAR_LENGTH(REPLACE(tb.genres, ',', ''))) >= (numbers.n - 1);