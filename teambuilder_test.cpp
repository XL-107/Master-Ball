#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <sqlite3.h>
typedef std::map<std::string, double> TYPE_MATCHUPS;
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
    TYPE_MATCHUPS swampert_matchup = defense_calc(get_type("Water"), get_type("Ground"));
    TYPE_MATCHUPS::iterator swampert_iter = swampert_matchup.begin();
    while (swampert_iter != swampert_matchup.end()){
        std::cout << swampert_iter->first << " " << swampert_iter->second;
        ++swampert_iter;
    }
    return 0;
}

