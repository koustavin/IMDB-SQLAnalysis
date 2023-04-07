
create index te_parent
on title_episode (parentTconst);

------------------------------------------------------

CREATE INDEX tcd_title
ON imdb.title_crew_directors (tconst);

CREATE INDEX tcd_dir
ON imdb.title_crew_directors (directors);

CREATE INDEX tcw_title
ON imdb.title_crew_writers (tconst);

CREATE INDEX tcw_wri
ON imdb.title_crew_writers (writers);

CREATE INDEX nbk_nameid
ON imdb.name_basics_knownfortitles (nconst);

CREATE INDEX nbk_title
ON imdb.name_basics_knownfortitles (knownForTitles);

CREATE INDEX nbp_nameid
ON imdb.name_basics_primaryprofession (nconst);

CREATE INDEX tbg_tconst
ON imdb.title_basics_genres (tconst);

ALTER TABLE imdb.title_crew_directors ENGINE = InnoDB;

ALTER TABLE  imdb.title_crew_writers ENGINE = InnoDB;

ALTER TABLE imdb.name_basics_knownfortitles ENGINE = InnoDB;

-----------------------------------------------------------------------------------------------------

CREATE INDEX tb_titleType
ON imdb.title_basics (titleType);

CREATE INDEX tb_priTtl
ON imdb.title_basics (primaryTitle(50));

CREATE INDEX tb_oriTtl
ON imdb.title_basics (originalTitle(50));

CREATE INDEX tb_startYear
ON imdb.title_basics (startYear);

CREATE INDEX tb_runtimeMinutes
ON imdb.title_basics (runtimeMinutes);

CREATE INDEX tbg_genres
ON imdb.title_basics_genres (genres);

CREATE INDEX nb_primaryName
ON imdb.name_basics (primaryName(50));

CREATE INDEX tr_averageRating
ON imdb.title_ratings (averageRating);

CREATE INDEX tr_numVotes
ON imdb.title_ratings (numVotes);.

CREATE INDEX te_season
ON imdb.title_episode (seasonNumber);

CREATE INDEX te_episode
ON imdb.title_episode (episodeNumber);

ALTER TABLE  imdb.title_episode ENGINE = InnoDB;

CREATE INDEX te_combi4group
ON imdb.title_episode (parentTconst, seasonNumber, episodeNumber);