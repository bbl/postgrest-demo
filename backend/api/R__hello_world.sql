drop view if exists api.hello_world;

create view api.hello_world as
select 'hello world' as text;

