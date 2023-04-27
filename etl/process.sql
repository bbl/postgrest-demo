truncate games;

with games_to_insert as (
select "Title",
       nullif("Release Date", 'releases on TBD')::date as release_date,
       "Team"::text[],
       "Rating",
       "Times Listed",
       "Number of Reviews",
       "Genres"::text[],
       "Summary"
from raw_games_data
)
insert into games(title, release_date, team, rating, times_listed, number_reviews, genres, summary)
select * from games_to_insert
where release_date is not null and "Rating" is not null;
