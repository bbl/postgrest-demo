drop view if exists api.games cascade;

create view api.games as
select *
from games;
