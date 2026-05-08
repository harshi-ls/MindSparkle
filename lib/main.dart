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

  String difficulty = "";

  void calculateDifficulty() {
    int age = int.tryParse(ageController.text) ?? 0;

    if (age <= 0) {
      difficulty = "Please enter a valid age.";
    } else if (age <= 6) {
      difficulty = "Very Easy Mode (2x2 Grid)";
    } else if (age <= 10) {
      difficulty = "Easy Mode (4x2 Grid)";
    } else if (age <= 15) {
      difficulty = "Medium Mode (4x4 Grid)";
    } else if (age <= 25) {
      difficulty = "Hard Mode (6x4 Grid)";
    } else {
      difficulty = "Expert Mode (6x6 Grid)";
    }

    setState(() {});
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
                onPressed: calculateDifficulty,
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

              const SizedBox(height: 30),

              Text(
                difficulty,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}