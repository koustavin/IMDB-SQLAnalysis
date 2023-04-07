ALTER TABLE title_akas  ADD FOREIGN KEY (titleId) REFERENCES title_basics(tconst);

ALTER TABLE title_crew ADD FOREIGN KEY (tconst) REFERENCES title_basics(tconst);

ALTER TABLE title_episode ADD FOREIGN KEY (tconst) REFERENCES title_basics(tconst);

ALTER TABLE title_principals ADD FOREIGN KEY (tconst) REFERENCES title_basics(tconst);

ALTER TABLE title_ratings ADD FOREIGN KEY (tconst) REFERENCES title_basics(tconst);

ALTER TABLE title_principals ADD FOREIGN KEY (nconst) REFERENCES name_basics (nconst);

ALTER TABLE title_episode ADD FOREIGN KEY (parentTconst) REFERENCES title_basics (tconst);

--------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE imdb.name_basics_knownfortitles ADD FOREIGN KEY (knownForTitles) REFERENCES title_basics (tconst);

ALTER TABLE imdb.title_crew_directors ADD FOREIGN KEY (tconst) REFERENCES title_basics (tconst);

ALTER TABLE imdb.title_crew_directors ADD FOREIGN KEY (directors) REFERENCES name_basics (nconst);

ALTER TABLE imdb.title_crew_writers  ADD FOREIGN KEY (tconst) REFERENCES title_basics (tconst);

ALTER TABLE imdb.title_crew_writers ADD FOREIGN KEY (writers) REFERENCES name_basics (nconst);

ALTER TABLE imdb.title_basics_genres ADD FOREIGN KEY (tconst) REFERENCES title_basics (tconst);