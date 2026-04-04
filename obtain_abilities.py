import requests
import sqlite3
import pandas as pd

def get_all_pokemon():
    errorFile = open("aaa.txt", "w", encoding="utf-8")
    outputFile = open("pokemon_abilities.csv", "w", encoding="utf-8")
    # outputFile = open("new_pokemon_abilities.csv", "w", encoding="utf-8")

    outputFile.write("Number,Name,Form,Ability1,Ability2,Hidden\n")
    query = "SELECT Number, Name, Form FROM expanded_pokemon_test"

    conn = sqlite3.connect('MasterBall.db')
    db = pd.read_sql(query, conn)
    
    for x in db.itertuples():
        result = f"{x[1]:03d},{x[2]}"
        form = ""
        if (not pd.isnull(x[3])): # Has a form
            form = x[3].split()[0]
            result += f",{x[3]}"
        else:
            result += f","

        pokemon = "-".join(x[2].split())
        print(pokemon, end = ", ", flush=True)

        abilities = abilityAPI(pokemon, form)
        match len(abilities):
            case 1:
                # One ability goes into slot 1, with the rest blank.
                temp = " ".join(abilities[0]["ability"]["name"].split("-")).title()
                result += "," + temp + ",,\n"
            case 3:
                # Three abilities go in each slot. 
                for y in abilities:
                    temp = " ".join(y["ability"]["name"].split("-")).title()
                    result += "," +  temp
                result += "\n"
            case 2:
                # Initial ability goes into slot 1, and then hidden ability.
                one = " ".join(abilities[0]["ability"]["name"].split("-")).title()
                hidden = " ".join(abilities[1]["ability"]["name"].split("-")).title()
                result += f",{one},,{hidden}\n"
            case _:
                errorFile.write("invalid: " + pokemon + "\n")
                result += ",???,,\n"
        outputFile.write(result)




        # for y in abilities:
        #     total = 0
        
            # match y["slot"]:
            #     case 1:
            #         # print("Slot 1:", temp)
            #         result += temp + ","
            #         total += 1
            #     case 2:
            #         if (total )
            #         print("Slot 2:", temp)
            #     case 3:
            #         print("Slot 3:", temp)


    
    
    return

def abilityAPI(pokemon, form):
    # FORM HANDLING: 
    # Megas: <name>-mega
    #      X/Y: <name>-mega-x  
    # Alolan: <name>-alola
    # Galarian: <name>-galar
    # Hisuian: <name>-hisui
    # Paldean: wooper-paldea
    # Primal: kyogre-primal groudon-primal
    
    # form_url = ""
    match form:
        case "Mega":
            form_url = "-mega"
        case "Alolan":
            form_url = "-alola"
        case "Galarian":
            form_url = "-galar"
        case "Hisuian":
            form_url = "-hisui"
        case "Primal":
            form_url = "-primal"
        case "":
            form_url = ""
        case _:
            form_url = "-" + form


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
    # Toxtricity: <>-low-key, <>-amped 
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

    url = "https://pokeapi.co/api/v2/pokemon/" + pokemon + form_url
    # print(pokemon + form_url)

    response = requests.get(url)
    # print(response)
    if response.status_code == 200:
        data = response.json()
        return data["abilities"]
    return []


def main():
    get_all_pokemon()

main()