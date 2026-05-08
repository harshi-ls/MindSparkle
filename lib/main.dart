import 'package:flutter/material.dart';

void main() {
  runApp(const MindSparkleApp());
}

class MindSparkleApp extends StatelessWidget {
  const MindSparkleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController ageController = TextEditingController();

  int gridCount = 4;
  String difficulty = "";

  void startGame() {
    int age = int.tryParse(ageController.text) ?? 0;

    if (age <= 0) {
      difficulty = "Please enter a valid age.";
      setState(() {});
      return;
    }

    if (age <= 6) {
      gridCount = 4;
      difficulty = "Very Easy";
    } else if (age <= 10) {
      gridCount = 8;
      difficulty = "Easy";
    } else if (age <= 15) {
      gridCount = 16;
      difficulty = "Medium";
    } else if (age <= 25) {
      gridCount = 24;
      difficulty = "Hard";
    } else {
      gridCount = 36;
      difficulty = "Expert";
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          difficulty: difficulty,
          gridCount: gridCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'MindSparkle',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🧠 MindSparkle',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter your age to begin',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: startGame,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 18,
                  ),
                ),
                child: const Text(
                  'Start Game',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  final String difficulty;
  final int gridCount;

  const GameScreen({
    super.key,
    required this.difficulty,
    required this.gridCount,
  });

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 2;

    if (gridCount == 8) {
      crossAxisCount = 4;
    } else if (gridCount == 16) {
      crossAxisCount = 4;
    } else if (gridCount == 24) {
      crossAxisCount = 6;
    } else if (gridCount == 36) {
      crossAxisCount = 6;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Difficulty: $difficulty'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: gridCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Icon(
                  Icons.question_mark,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}