import requests
import sqlite3
import pandas as pd

def get_all_pokemon():
    query = "SELECT DISTINCT Name FROM expanded_pokemon_test"

    conn = sqlite3.connect('MasterBall.db')
    db = pd.read_sql(query, conn)
    
    for x in db.head(5)["Name"].items():
        print(x[1])
    
    
    return

def abilityAPI():
    # FORM HANDLING: 
    # EX: gengar-mega, gengar-gmax, ninetails-alola, 
    # Partner Pikachu -> pikachu-starter
    # Tauros breeds -> tauros-paldea-combat-breed
    # ??? 

    url = "https://pokeapi.co/api/v2/pokemon/Vanillite"
    response = requests.get(url)
    print(response)
    if response.status_code == 200:
        data = response.json()
        return data["abilities"]
    return []


def main():
    abilityAPI()

main()