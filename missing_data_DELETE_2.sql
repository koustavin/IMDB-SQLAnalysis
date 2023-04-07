SELECT tp.*
FROM imdb.title_principals tp
LEFT JOIN imdb.name_basics nb
ON tp.nconst = nb.nconst
WHERE nb.nconst IS NULL;

DELETE FROM imdb.title_principals WHERE nconst in ('nm0814558', 'nm3954812', 'nm12474983', 'nm10601832', 'nm14479251', 'nm14073087', 'nm7893339', 'nm11040532', 'nm14144091', 'nm9966635', 'nm7646462', 'nm6403526', 'nm12058627', 'nm7902371', 'nm9887282', 'nm12538846', 'nm12292711', 'nm1706355', 'nm9420756', 'nm7372640', 'nm14581578', 'nm12937240', 'nm12975423', 'nm9713691', 'nm3992774', 'nm13387305', 'nm13589982', 'nm13087531', 'nm13087532', 'nm13635805', 'nm13635808', 'nm4744492', 'nm13792093', 'nm13893793', 'nm9646596', 'nm14175936', 'nm14160197', 'nm12610480', 'nm14364933', 'nm4923517', 'nm14368735', 'nm11470099', 'nm14430404', 'nm14461873', 'nm14465476', 'nm14287534', 'nm6875535', 'nm9372527', 'nm8343901', 'nm8346494', 'nm8601248', 'nm11808933', 'nm8983838', 'nm8454240', 'nm9174341', 'nm13751755', 'nm12659818', 'nm9396359', 'nm10337502', 'nm10395886');

select te.*
from imdb.title_episode te 
left join imdb.title_basics tb 
on te.parentTconst = tb.tconst 
where tb.tconst is null;

delete from imdb.title_episode
where parentTconst in ('tt9810440', 'tt11957490', 'tt13891328', 'tt14965588');