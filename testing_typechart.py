import pandas as pd
import sqlite3

def return_effect(x):
    match x:
        case 1:
            return "Neutral"
        case 2:
            return "Super effective!"
        case 0.5:
            return "Not very effective..."
        case _:
            return "Effectiveness"

def type_effectiveness(types_list):
    types_list = [x.title() for x in types_list]
    query = f"SELECT * FROM type_chart WHERE Type LIKE '{types_list[0]}'"

    for t in types_list[1:]:
        query += f" OR Type LIKE '{t}'"

    # print(query)

    conn = sqlite3.connect('MasterBall.db')
    db = pd.read_sql(query, conn)
    # print(db)
    for type, data in db.items(): # Returns each column in the chart.
        print(type, end = ': ')
        print(return_effect(max(data)))


def main():
    type_effectiveness(['fire', "water"])
main()