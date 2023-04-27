
drop view if exists api.previous_popular_games;

create view api.previous_popular_games as
select g.game_id,
       p.game_id      as prev_popular_game_id,
       p.title        as prev_popular_game_title,
       p.release_date as prev_popular_game_release_date,
       p.rating       as prev_popular_game_rating,
       p.team         as prev_popular_game_team
from games as g
         left join lateral (
    select prev.*
    from games as prev
    where prev.rating > g.rating
      and prev.release_date < g.release_date
      and g.genres = prev.genres
    order by rating desc
    limit 1
    ) as p on true;

-- For embedding --
drop function if exists api.previous_popular_games;

create function api.previous_popular_games(api.games)
returns setof api.previous_popular_games
as $$
  select * from api.previous_popular_games where game_id = $1.game_id
$$ stable language sql;
