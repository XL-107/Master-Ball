import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
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
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: const Color.fromARGB(255, 77, 9, 85),
                width: 48,
              ),
              right: BorderSide(
                color: const Color.fromARGB(255, 77, 9, 85),
                width: 48,
              ),
              bottom: BorderSide(
                color: const Color.fromARGB(255, 77, 9, 85),
                width: 48,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 220,
                  width: 220,
                  child: ElevatedButton(
                    onPressed: () {
                      _showMessage('pokeDex Button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: const Color.fromARGB(255, 163, 16, 161),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'PokeDEX',
                      style: GoogleFonts.pressStart2p(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  child: OutlinedButton(
                    onPressed: () {
                      _showMessage('Pokedex button pressed');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 111, 45, 45),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 111, 45, 45),
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Pokedex',
                      style: GoogleFonts.pressStart2p(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  child: TextButton(
                    onPressed: () {
                      _showMessage('Settings button pressed');
                    },
                    child: Text(
                      'Settings',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 111, 45, 45),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}}