import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MasterBall HomeScreen',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'MasterBall'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startMusic();
  }

  Future<void> _startMusic() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(0.5);
    await _player.play(AssetSource('audio/music.mp3'));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
  
  void _showMessage(String text) {
    ScaffoldMessenger.of(context)..clearSnackBars()..showSnackBar(
      SnackBar(content: Text(text, style: GoogleFonts.pressStart2p(fontSize: 10, color: Colors.white,)), duration: Duration(milliseconds: 1), backgroundColor: const Color.fromARGB(255, 133, 23, 137),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          backgroundColor: const Color.fromARGB(255, 133, 23, 137),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 77, 9, 85),
            centerTitle: true,
            title: Text(
              widget.title,
              style: GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Color.fromARGB(255, 77, 9, 85),
                  width: 24,
                ),
                right: BorderSide(
                  color: Color.fromARGB(255, 77, 9, 85),
                  width: 24,
                ),
                bottom: BorderSide(
                  color: Color.fromARGB(255, 77, 9, 85),
                  width: 24,
                ),
              ),
            ),      
          ),
        ),

        Positioned(
          top: 200,
          left: 40,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    _showMessage('PokeDEX Button pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(0),
                     side: const BorderSide(color: Colors.white, width: 3,)
                    ),
                    backgroundColor: const Color.fromARGB(255, 163, 16, 161),
                    foregroundColor: Colors.white,
                  ),
                child: Image.asset('assets/images/pokedex.png', width: 90, height: 90, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'PokeDEX',
                style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.white, decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 200,
          left: 220,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    _showMessage('Team Builder Button pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(0),
                     side: const BorderSide(color: Colors.white, width: 3,)
                    ),
                    backgroundColor: const Color.fromARGB(255, 163, 16, 161),
                    foregroundColor: Colors.white,
                  ),
                child: Image.asset('assets/images/pokeball.png', width: 90, height: 90, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Team Builder',
                style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.white, decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 450,
          left: 40,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    _showMessage('Damage Calculator Button pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(0),
                     side: const BorderSide(color: Colors.white, width: 3,)
                    ),
                    backgroundColor: const Color.fromARGB(255, 163, 16, 161),
                    foregroundColor: Colors.white,
                  ),
                child: Image.asset('assets/images/calc.png', width: 90, height: 90, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'DMG Calculator',
                style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.white, decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 450,
          left: 220,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    _showMessage('Other Button pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(0),
                     side: const BorderSide(color: Colors.white, width: 3,)
                    ),
                    backgroundColor: const Color.fromARGB(255, 163, 16, 161),
                    foregroundColor: Colors.white,
                  ),
                child: Image.asset('assets/images/question.png', width: 180, height: 180, fit: BoxFit.fitHeight),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Other',
                style: GoogleFonts.pressStart2p(fontSize: 12, color: Colors.white, decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 175,
          left: 40,
          child: Text(
            'Welcome to your ultimate\nPokémon companion!',
            style: GoogleFonts.pressStart2p(fontSize: 14, color: Colors.white, decoration: TextDecoration.none),
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
          top: 110,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/masterball.png',
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 700,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/pokemons.png',
            width: 200,
            height: 180,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}