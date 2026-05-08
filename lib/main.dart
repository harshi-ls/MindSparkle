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

class GameScreen extends StatefulWidget {
  final String difficulty;
  final int gridCount;

  const GameScreen({
    super.key,
    required this.difficulty,
    required this.gridCount,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> cardValues = [];
  List<bool> cardFlipped = [];
  List<bool> matchedCards = [];

  List<int> selectedCards = [];

  bool isBusy = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    generateCards();
  }

  void generateCards() {
    List<String> emojis = [
      '🐶',
      '🐱',
      '🍎',
      '🍌',
      '⭐',
      '🚗',
      '🎈',
      '⚽',
      '🐸',
      '🍕',
      '🌈',
      '🎮',
      '🧠',
      '🎵',
      '🚀',
      '🦋',
      '🍇',
      '🍩',
    ];

    int pairCount = widget.gridCount ~/ 2;

    cardValues = emojis.take(pairCount).toList();
    cardValues = [...cardValues, ...cardValues];

    cardValues.shuffle();

    cardFlipped =
        List.generate(widget.gridCount, (index) => false);

    matchedCards =
        List.generate(widget.gridCount, (index) => false);
  }

  void flipCard(int index) async {
    if (isBusy ||
        cardFlipped[index] ||
        matchedCards[index]) {
      return;
    }

    setState(() {
      cardFlipped[index] = true;
      selectedCards.add(index);
    });

    if (selectedCards.length == 2) {
      isBusy = true;

      int first = selectedCards[0];
      int second = selectedCards[1];

      if (cardValues[first] == cardValues[second]) {
  matchedCards[first] = true;
  matchedCards[second] = true;

  score += 10;

  checkWin();
} else {
        await Future.delayed(
          const Duration(seconds: 1),
        );

        setState(() {
          cardFlipped[first] = false;
          cardFlipped[second] = false;
          score -= 2;
        });
      }

      selectedCards.clear();
      isBusy = false;
    }
  }
void checkWin() {
  bool hasWon =
      matchedCards.every((matched) => matched);

  if (hasWon) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('🎉 Congratulations!'),
          content: Text(
            'You completed the game!\n\nScore: $score',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                setState(() {
                  generateCards();

                  cardFlipped = List.generate(
                    widget.gridCount,
                    (index) => false,
                  );

                  matchedCards = List.generate(
                    widget.gridCount,
                    (index) => false,
                  );

                  selectedCards.clear();

                  score = 0;
                });
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }
}
  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 2;

    if (widget.gridCount == 8) {
      crossAxisCount = 4;
    } else if (widget.gridCount == 16) {
      crossAxisCount = 4;
    } else if (widget.gridCount == 24) {
      crossAxisCount = 6;
    } else if (widget.gridCount == 36) {
      crossAxisCount = 6;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
  'Score: $score | ${widget.difficulty}',
),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: widget.gridCount,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => flipCard(index),
              child: Container(
                decoration: BoxDecoration(
                  color: matchedCards[index]
                      ? Colors.green
                      : Colors.blue,
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    cardFlipped[index]
                        ? cardValues[index]
                        : '❓',
                    style: const TextStyle(fontSize: 35),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}