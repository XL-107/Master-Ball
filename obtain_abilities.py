import requests
import sqlite3
import pandas as pd

def get_all_pokemon():
    query = "SELECT DISTINCT Name, Form FROM expanded_pokemon_test WHERE Form IS NOT NULL"

    conn = sqlite3.connect('MasterBall.db')
    db = pd.read_sql(query, conn)
    
    for x in db.itertuples():
        print(x)
    
    
    return

def abilityAPI():
    # FORM HANDLING: 
    # Megas: <name>-mega
    #      X/Y: <name>-mega-x  
    # Gmax: <name>-gmax
    # Alolan: <name>-alola
    # Galarian: <name>-galar
    # Hisuian: <name>-hisui
    # Paldean: wooper-paldea
    # Primal: kyogre-primal groudon-primal
    # 
    # OTHER CASES: 
    # Deoxys: deoxys-<normal/attack/defense/speed> 
    # Partner Pikachu/Eevee: pikachu-starter eevee-starter
    # Castform: castform, castform-<rainy/sunny/snowy> 
    # Tauros breeds: tauros-paldea-<aqua/blaze/combat>-breed
    # Burmy/Wormadam: wormadam-<plant/sandy/trash>
    #       All burmy forms are the same and do not have a unique URL.
    # Rotom: rotom, rotom-<fan/frost/heat/mow/wash>
    # dialga-origin, palkia-origin, giratina-origin, giratina-altered
    # Shaymin: <>-land, <>-sky
    # Basculin: <>-red-striped, <>-blue-striped, <>-white-striped
    # Darmanitan: <>-standard, <>-zen, <>-galar-standard, <>-galar-zen
    # Tornadus/Thundurus/Landorus/Enamorus: <>-incarnate, <>-therian
    # Kyurem: <>, <>-black, <>-white
    # Keldeo: <>-ordinary, <>-resolute
    # Meloetta: <>-aria, <>-pirouette
    # Greninja: <>-ash
    # Meowstic: <>-female, <>-male
    # Aegislash: <>-blade, <>-shield
    # Pumpkaboo/Gourgeist: <>-<average/large/small/super> 
    # Zygarde: <>-10, <>-50, <>-10-power-construct, <>-50-power-construct, <>-complete
    #       "power-construct" is a special ability. Probably best to put it into ability2 or something...
    # Hoopa: <>, <>-unbound (confined needs to use default instead)
    # Oricorio: <>-baile, <>-pau, <>-pom-pom, <>-sensu
    # Rockruff: <>, <>-own-tempo
    # Lycanroc: <>-dusk, <>-midday, <>-midnight
    # Wishiwashi: <>-school, <>-solo
    # Minior: <>-<red/orange/yellow/green/blue/indigo/violet> (core)
    #         <>-<red/orange/yellow/green/blue/indigo/violet>-meteor
    #         note: all of these have the same ability...
    # Necrozma: <>-dusk, <>-dawn, <>-ultra
    # Toxtricity: <>-low-key, <>-amped     (<>-gmax)
    # Eiscue: <>-ice, <>-noice
    # Indeedee: <>-female, <>-male
    # Morpeko: <>-full-belly, <>-hangry
    # Zacian/Zamazenta: <>, <>-crowned
    # Eternatus: <>, <>-eternamax
    # Urshifu: <>-single-strike, <>-rapid-strike
    # Calyrex: <>, <>-ice, <>-shadow
    # Ursaluna: <>, <>-bloodmoon
    # Basculegion: <>-male, <>-female
    # Oinkologne: <>-male, <>-female
    # Maushold: <>-family-of-three, <>-family-of-four
    # Squawkabilly: <>-<blue/green/white/yellow>-plumage
    #           These DO have different abilities depending on plumage. 
    # Palafin: <>-hero, <>-zero
    # Tatsugiri: <>-<curly/droopy/stretchy>
    # Dudunsparce: <>-<two/three>-segment
    # Gimmighoul: <>, <>-roaming (chest is default)
    # Ogerpon: <>, <>-<cornerstone/hearthflame/wellspring>-mask (teal is default)
    # Terapagos: <>, <>-stellar, <>-terastal





    url = "https://pokeapi.co/api/v2/pokemon/Vanillite"
    response = requests.get(url)
    print(response)
    if response.status_code == 200:
        data = response.json()
        return data["abilities"]
    return []


def main():
    get_all_pokemon()

main()