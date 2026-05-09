import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MindSparkleApp());
}

class MindSparkleApp extends StatelessWidget {
  const MindSparkleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
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
  final TextEditingController nameController = TextEditingController();

  int gridCount = 4;
  String difficulty = "";

  @override
  void dispose() {
    ageController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void startGame() {
    int age = int.tryParse(ageController.text) ?? 0;
    String playerName = nameController.text.trim();

    if (playerName.isEmpty) {
      setState(() {
        difficulty = "Please enter your name.";
      });
      return;
    }

    if (age <= 0) {
      setState(() {
        difficulty = "Please enter a valid age.";
      });
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
          playerName: playerName,
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
                'Enter your details to begin',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Your Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 15),
              Text(
                difficulty,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaderboardScreen(),
                    ),
                  );
                },
                child: const Text('🏆 View Leaderboard'),
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
  final String playerName;

  const GameScreen({
    super.key,
    required this.difficulty,
    required this.gridCount,
    required this.playerName,
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
  late Timer timer;
  int timeLeft = 60;

  final List<Map<String, String>> heroes = [
    {
      'name': 'Moon Knight 🌙',
      'image': 'assets/images/Moon Knight.jpg',
    },
    {
      'name': 'Minnal Murali ⚡',
      'image': 'assets/images/Minnal Murali.jpg',
    },
    {
      'name': 'Joker 🃏',
      'image': 'assets/images/Joker.jpg',
    },
    {
      'name': 'Deadpool 🔴',
      'image': 'assets/images/Deadpool.jpg',
    },
    {
      'name': 'Spider-Man 🕷️',
      'image': 'assets/images/Spiderman.jpg',
    },
    {
      'name': 'Captain America 🛡️',
      'image': 'assets/images/Captainamerica.jpg',
    },
    {
      'name': 'Thor ⚒️',
      'image': 'assets/images/Thor.jpg',
    },
    {
      'name': 'Thanos 💀',
      'image': 'assets/images/Thanos.jpg',
    },
    {
      'name': 'Superman 💥',
      'image': 'assets/images/Superman.jpg',
    },
    {
      'name': 'Venom 🖤',
      'image': 'assets/images/Venom.jpg',
    },
    {
      'name': 'Batman 🦇',
      'image': 'assets/images/Batman.jpg',
    },
    {
      'name': 'Hulk 💚',
      'image': 'assets/images/Hulk.jpg',
    },
    {
      'name': 'Iron Man 🤖',
      'image': 'assets/images/Ironman.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    generateCards();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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

    cardFlipped = List.generate(widget.gridCount, (index) => false);
    matchedCards = List.generate(widget.gridCount, (index) => false);

    setGameTimer();
  }

  void setGameTimer() {
    if (widget.gridCount == 4) {
      timeLeft = 60;
    } else if (widget.gridCount == 8) {
      timeLeft = 90;
    } else if (widget.gridCount == 16) {
      timeLeft = 120;
    } else if (widget.gridCount == 24) {
      timeLeft = 180;
    } else {
      timeLeft = 240;
    }

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return;

        if (timeLeft > 0) {
          setState(() {
            timeLeft--;
          });
        } else {
          timer.cancel();
          showTimeUpDialog();
        }
      },
    );
  }

  void flipCard(int index) async {
    if (isBusy || cardFlipped[index] || matchedCards[index]) {
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
        setState(() {
          matchedCards[first] = true;
          matchedCards[second] = true;
          score += 10;
        });

        checkWin();
      } else {
        await Future.delayed(const Duration(seconds: 1));

        if (!mounted) return;

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

  Future<void> checkWin() async {
    bool hasWon = matchedCards.every((matched) => matched);

    if (hasWon) {
      timer.cancel();
      await saveScore();

      if (!mounted) return;

      final randomHero = heroes[Random().nextInt(heroes.length)];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VictoryScreen(
            heroName: randomHero['name']!,
            heroImage: randomHero['image']!,
            score: score,
            timeLeft: timeLeft,
            playerName: widget.playerName,
          ),
        ),
      );
    }
  }

  void showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('⏰ Time\'s Up!'),
          content: Text('Final Score: $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                setState(() {
                  selectedCards.clear();
                  score = 0;
                  generateCards();
                });
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveScore() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> scores = prefs.getStringList('leaderboard') ?? [];

    scores.add('${widget.playerName} - $score');

    scores.sort((a, b) {
      int scoreA = int.parse(a.split('-').last.trim());
      int scoreB = int.parse(b.split('-').last.trim());

      return scoreB.compareTo(scoreA);
    });

    await prefs.setStringList('leaderboard', scores);
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
          '${widget.playerName} | Score: $score | ⏱ $timeLeft',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: widget.gridCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => flipCard(index),
              child: Container(
                decoration: BoxDecoration(
                  color: matchedCards[index] ? Colors.green : Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    cardFlipped[index] ? cardValues[index] : '❓',
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

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<String> leaderboard = [];

  @override
  void initState() {
    super.initState();
    loadLeaderboard();
  }

  Future<void> loadLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      leaderboard = prefs.getStringList('leaderboard') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Leaderboard'),
        centerTitle: true,
      ),
      body: leaderboard.isEmpty
          ? const Center(
              child: Text(
                'No scores yet!',
                style: TextStyle(fontSize: 22),
              ),
            )
          : ListView.builder(
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    '#${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Text(leaderboard[index]),
                );
              },
            ),
    );
  }
}

class VictoryScreen extends StatelessWidget {
  final String heroName;
  final String heroImage;
  final int score;
  final int timeLeft;
  final String playerName;

  const VictoryScreen({
    super.key,
    required this.heroName,
    required this.heroImage,
    required this.score,
    required this.timeLeft,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            heroImage,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '🔥 HEY LEGEND!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'You are\n$heroName',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    '⭐ Score: $score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '⏱ Time Left: $timeLeft s',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('🏠 Back To Home'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
