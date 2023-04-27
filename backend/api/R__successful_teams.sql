drop view if exists api.successful_teams;

create view api.successful_teams as
with team_games as (select game_id,
                           title,
                           rating,
                           unnest(team) as team
                    from games
                    where rating > 4.0)
select team,
       count(distinct game_id) as number_of_top_rated_games,
       max(rating)             as rating_of_top_rated_game,
       array_to_json(
               (array_agg(title order by rating desc))[:3]
           )                   as top3_rated_games_list
from team_games
group by team
order by number_of_top_rated_games desc, rating_of_top_rated_game desc;