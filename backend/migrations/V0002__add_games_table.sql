create extension if not exists "uuid-ossp";

create table games
(
    game_id        uuid primary key default gen_random_uuid(),
    title          text,
    release_date   date,
    team           text[],
    rating         decimal,
    times_listed   decimal,
    number_reviews decimal,
    genres         text[],
    summary        text
);