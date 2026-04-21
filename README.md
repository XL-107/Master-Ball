# Master Ball
Master Ball is a flutter-based Android app all about Pokemon! 
We plan for this pokemon app to have sorting, display, and also teambuilding capabilities. 

## Current Capabilites:
We have code for a working teambuilder and pokedex, and a partially complete main menu, but they are not linked to each other. There is still no final product. 

## Running:
Our code depends on an Android Studio medium phone emulator with additional packages. Follow the steps listed in [the official Flutter guide to Android Studio](https://docs.flutter.dev/platform-integration/android/setup) to install and prepare the emulator. 

Flutter relies on a `pubspec.yaml` file to load packages, so the folder where the `flutter run` command is executed is important. 

The teambuilder is located in the branch `frontend-testing`, in the folder `sql_testing`. The code itself is `lib/pages/teambuilder.dart`, not the `main.dart` file. To run the teambuilder page, navigate to the `sql_testing` folder, and execute `flutter run -t lib/pages/teambuilder.dart` in the terminal. 

The pokedex is located in the branch `simplePokedex`, in the folders `BasicPokedex/basic_pokedex`. To run the teambuilder page, navigate to the `basic_pokedex` folder in `BasicPokedex`, and execute `flutter run` in the terminal. 

The main menu is located in the branch `Main-Menu`, in the folder `screen_app`. To run the main menu, navigate to the `screen_app`, and execute `flutter run` in the terminal. 

## Various Notes:
Try not to mix linux and windows installations when working on the project. The android emulator doesn't like being run out of WSL very much. 

The teambuilder uses many, many external PNGs stored in the assets file for the pokemon images, taken from the [Pokemon Showdown Icons Sheet](https://play.pokemonshowdown.com/sprites/pokemonicons-sheet.png) using an external script to cut the images out. This totals up to about 1 MB. 

The database file in the assets folder is separate from the stored assets in the phone emulator. These are accessed using the function `getApplicationDocumentsDirectory()`. This returns the path to the file storage on the phone emulator, which contains a copy of the database file. 

## Image sources
- Master Ball Logo: https://www.serebii.net/itemdex/masterball.shtml
- Teambuilder Pokemon Icons: https://play.pokemonshowdown.com/sprites/pokemonicons-sheet.png
- Teambuilder Large Pokemon Icons: https://play.pokemonshowdown.com/sprites/gen5/
- Teambuilder Type Icons: https://www.deviantart.com/pokemon-ressources/gallery/57345584/icon-type
- Main Menu Pikachu and Starters Decorations: https://www.furaffinity.net/view/6644676/
- Main Menu PokeDEX icon: https://bulbapedia.bulbagarden.net/wiki/Pok%C3%A9dex#/media/File:Gen_I_Pok%C3%A9dex.png
- Main Menu Pokeball icon: https://commons.wikimedia.org/wiki/File:Pokebola-pokeball-png-0.png
- Main Menu Calculator icon: https://favpng.com/png_search/calculator-designs/4
