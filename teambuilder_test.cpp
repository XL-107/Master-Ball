#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <sqlite3.h>
typedef std::map<std::string, double> TYPE_MATCHUPS;
//Gets the type of the Pokemon from the pokemon database
std::vector<std::string> get_pokemon(std::string pokemon){
    std::vector<std::string> type;
    sqlite3* db;
    sqlite3_stmt* stmt;
    sqlite3_open("pokemon_test.db", &db);
    std::string query = "SELECT Type1, Type2 FROM pokemon_test WHERE Name = '" + pokemon + "'";
    sqlite3_prepare_v2(db, query.c_str(), -1, &stmt, NULL);
    if(sqlite3_step(stmt) == SQLITE_ROW){
        type.push_back((const char*)sqlite3_column_text(stmt, 0));
        if(sqlite3_column_type(stmt,1) != SQLITE_NULL){
            type.push_back((const char*)sqlite3_column_text(stmt, 1));
        }else {
            type.push_back("None");
        }
    }else {
        std::cout << "Pokemon not found \n";
    }
    return type;
}
//Converts the column with the specified header into a map that contains all of its weaknesses, immunities, and resistances
TYPE_MATCHUPS get_type(std::string type){
    TYPE_MATCHUPS matchups;
    sqlite3* db;
    sqlite3_stmt* stmt;
    
    sqlite3_open("type_chart.db", &db);
    if(sqlite3_open("type_chart.db", &db) != SQLITE_OK){
        std::cout << "Failed to open database\n";
    }
    std::string query = "SELECT Type, " + type + " FROM type_chart";
    //built-in function that compiles the SQLite query that will then be executed
    //std::cout << "Running query: " << query << std::endl;
    sqlite3_prepare_v2(db, query.c_str(), -1, &stmt, NULL);
    while(sqlite3_step(stmt) == SQLITE_ROW){
        std::string defending_type = (const char*)sqlite3_column_text(stmt,0);
        double multiplier = sqlite3_column_double(stmt,1);
        matchups[defending_type] = multiplier;
    }

    sqlite3_finalize(stmt);
    sqlite3_close(db);

    return matchups;
}
//main function that calculates a Pokemon's weaknesses, resistances and immunities. This function would only be called if the
//Pokemon has two types.
TYPE_MATCHUPS defense_calc(TYPE_MATCHUPS type1, TYPE_MATCHUPS type2) {
    TYPE_MATCHUPS defense;
    TYPE_MATCHUPS::iterator iter1 = type1.begin();
    TYPE_MATCHUPS::iterator iter2 = type2.begin();
    while (iter1 != type1.end()){
        defense[iter1->first] = iter1->second * iter2->second;
        ++iter1;
        ++iter2;
    }
    return defense;
}

int main(int argc, char const *argv[]){
    /*
    TYPE_MATCHUPS swampert_matchup = defense_calc(get_type("Water"), get_type("Ground"));
    TYPE_MATCHUPS::iterator swampert_iter = swampert_matchup.begin();
    while (swampert_iter != swampert_matchup.end()){
        std::cout << swampert_iter->first << " " << swampert_iter->second << std::endl;
        ++swampert_iter;
    }*/
    
    std::string type1 = get_pokemon(argv[1])[0];
    //std::cout << type1 << std::endl;
    std::string type2 = get_pokemon(argv[1])[1];
    //std::cout << type2 << std::endl;
    TYPE_MATCHUPS matchup = defense_calc(get_type(type1), get_type(type2));
    TYPE_MATCHUPS::iterator iter = matchup.begin();
    while(iter != matchup.end()){
        std::cout << iter->first << " " << iter->second << std::endl;
        ++iter;
    }
    /*std::map<std::string, int> total_weaks;
    std::map<std::string, int> total_resists;
    for (unsigned int i = 1; i < argc; i++) {
        std::string type1 = get_pokemon(argv[i])[0];
        std::string type2 = get_pokemon(argv[i])[1];
        TYPE_MATCHUPS matchup = defense_calc(get_type(type1), get_type(type2));
        TYPE_MATCHUPS::iterator iter = matchup.begin();
        while(iter != matchup.end()){
            if (iter->second < 1.0){
                total_resists[iter->first]++;
            }else if (iter->second > 1.0){
                total_weaks[iter->first]++;
            }
        }
    }
    std::map<std::string, int>::iterator weaks_iter = total_weaks.begin();
    std::cout << "Total Weaknesses" << std::endl;
    while (weaks_iter != total_weaks.end()){
        std::cout << weaks_iter->first << ": " << weaks_iter->second << std::endl;
        ++weaks_iter;
    }
    std::map<std::string, int>::iterator resists_iter = total_resists.begin();
    std::cout << "Total Resistances" << std::endl;
    while (resists_iter != total_resists.end()){
        std::cout << resists_iter->first << ": " << resists_iter->second << std::endl;
        ++resists_iter;
    }*/
    return 0;
}

