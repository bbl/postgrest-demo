
import pandas as pd
from sqlalchemy import create_engine


def parse_arr(record: str) -> list:
    record = str(record)
    record = record.replace('[', '').replace(']', '').replace('\'', '')
    return record.split(',')


if __name__ == '__main__':
    engine = create_engine('postgresql://postgres:postgres@localhost:5432/postgres')

    df = pd.read_csv('games.csv')
    df['Genres'] = df['Genres'].apply(parse_arr)
    df['Team'] = df['Team'].apply(parse_arr)

    df.to_sql('raw_games_data', engine, if_exists='replace', index=False)
