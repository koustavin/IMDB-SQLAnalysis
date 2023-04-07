CREATE DATABASE IF NOT EXISTS imdb;

USE imdb;

CREATE TABLE title_ratings(
tconst VARCHAR(15),
averageRating FLOAT,
numVotes INT);

DROP TABLE title_akas;

CREATE TABLE title_akas(
titleId VARCHAR(15),
ordering INT,
title VARCHAR(1000),
region VARCHAR(5),
language VARCHAR(5),
types VARCHAR(20),
attributes VARCHAR(100),
isOriginalTitle INT);

DROP TABLE title_principals;

CREATE TABLE title_principals(
tconst VARCHAR(15),
ordering INT,
nconst VARCHAR(15),
category VARCHAR(50),
job VARCHAR(300),
characters VARCHAR(1500));

CREATE TABLE name_basics(
nconst VARCHAR(15),
primaryName VARCHAR(200),
birthYear INT,
deathYear INT,
primaryProfession VARCHAR(500),
knownForTitles VARCHAR(1000));

CREATE TABLE title_basics(
tconst VARCHAR(15),
titleType VARCHAR(25),
primaryTitle VARCHAR(1000),
originalTitle VARCHAR(1000),
isAdult INT,
startYear INT,
endYear INT,
runtimeMinutes FLOAT,
genres VARCHAR(500));

DROP TABLE title_crew;

CREATE TABLE title_crew(
tconst VARCHAR(15),
directors VARCHAR(6000),
writers VARCHAR(10000));

CREATE TABLE title_episode(
tconst VARCHAR(15),
parentTconst VARCHAR(15),
seasonNumber INT,
episodeNumber INT);