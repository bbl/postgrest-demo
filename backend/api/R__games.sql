drop view if exists api.games;

create view api.games as
select *
from games;
