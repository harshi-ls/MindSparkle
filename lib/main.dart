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

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  int gridCount = 4;
  String difficulty = "";

  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    ageController.dispose();
    nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Offset _animatedOffset(
    double width,
    double height,
    double xFactor,
    double yFactor,
    double speed,
    double phase,
    double xVariance,
    double yVariance,
  ) {
    final progress = _animationController.value;
    final dx = xFactor * width +
        sin((progress * 2 * pi * speed) + phase) * xVariance;
    final dy = yFactor * height +
        cos((progress * 2 * pi * speed) + phase) * yVariance;

    return Offset(
      dx.clamp(0.0, width - 10.0).toDouble(),
      dy.clamp(0.0, height - 10.0).toDouble(),
    );
  }

  Widget _floatingBubble({
    required Offset offset,
    required double size,
    required Color color,
    double blur = 14,
  }) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(
                color.r.toInt(),
color.g.toInt(),
color.b.toInt(),
                0.35,
              ),
              blurRadius: blur,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'MindSparkle',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8AD8FF), Color(0xFF4FC3F7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE3F2FD),
                  Color(0xFF81D4FA),
                  Color(0xFF4FC3F7),
                  Color(0xFF0288D1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final height = constraints.maxHeight;
                  return Stack(
                    children: [
                      _floatingBubble(
                        offset: _animatedOffset(
                          width,
                          height,
                          0.12,
                          0.18,
                          1.0,
                          0.2,
                          40,
                          22,
                        ),
                        size: 84,
                        color: const Color.fromRGBO(255, 255, 255, 0.22),
                      ),
                      _floatingBubble(
                        offset: _animatedOffset(
                          width,
                          height,
                          0.75,
                          0.10,
                          0.9,
                          1.3,
                          36,
                          28,
                        ),
                        size: 68,
                        color: const Color.fromRGBO(255, 255, 255, 0.18),
                      ),
                      _floatingBubble(
                        offset: _animatedOffset(
                          width,
                          height,
                          0.30,
                          0.82,
                          1.2,
                          2.1,
                          40,
                          32,
                        ),
                        size: 96,
                        color: const Color.fromRGBO(255, 255, 255, 0.16),
                      ),
                      Positioned(
                        left: _animatedOffset(
                          width,
                          height,
                          0.20,
                          0.45,
                          1.0,
                          0.7,
                          60,
                          36,
                        ).dx,
                        top: _animatedOffset(
                          width,
                          height,
                          0.20,
                          0.45,
                          1.0,
                          0.7,
                          60,
                          36,
                        ).dy,
                        child: const Icon(
                          Icons.star,
                          color: Color(0xFFFFF9C4),
                          size: 28,
                        ),
                      ),
                      Positioned(
                        left: _animatedOffset(
                          width,
                          height,
                          0.82,
                          0.62,
                          1.1,
                          1.8,
                          44,
                          30,
                        ).dx,
                        top: _animatedOffset(
                          width,
                          height,
                          0.82,
                          0.62,
                          1.1,
                          1.8,
                          44,
                          30,
                        ).dy,
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Color(0xFFB3E5FC),
                          size: 30,
                        ),
                      ),
                      Positioned(
                        left: _animatedOffset(
                          width,
                          height,
                          0.52,
                          0.26,
                          1.3,
                          0.5,
                          52,
                          34,
                        ).dx,
                        top: _animatedOffset(
                          width,
                          height,
                          0.52,
                          0.26,
                          1.3,
                          0.5,
                          52,
                          34,
                        ).dy,
                        child: const Icon(
                          Icons.bubble_chart,
                          color: Color(0xFFB3E5FC),
                          size: 34,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),

Positioned(
  left: -40,
  top: 120,
  child: Opacity(
    opacity: 0.10,
    child: Image.asset(
      'assets/images/Batman.jpg',
      height: 280,
    ),
  ),
),

Positioned(
  right: -40,
  top: 120,
  child: Opacity(
    opacity: 0.10,
    child: Image.asset(
      'assets/images/Ironman.jpg',
      height: 280,
    ),
  ),
),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 32,
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.85),
                   borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: const Color.fromRGBO(255, 255, 255, 0.85),
                      width: 1.4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(144, 202, 249, 0.35),
                        blurRadius: 35,
spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
  shaderCallback: (bounds) {
    return const LinearGradient(
      colors: [
        Color(0xFF00E5FF),
        Color(0xFF7C4DFF),
        Color(0xFF00B0FF),
      ],
    ).createShader(bounds);
  },
  child: Text(
  '🧠 MINDSPARKLE',
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontSize: 46,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 2,
    shadows: [
      Shadow(
        blurRadius: 20,
        color: Color(0xFF00E5FF),
      ),
      Shadow(
        blurRadius: 35,
        color: Color(0xFF7C4DFF),
      ),
    ],
  ),
),
                      ),
                      const SizedBox(height: 12),
                      const Text(
  'Train Your Memory.\n'
  'Challenge Your Mind.\n'
  'Become a Legend.',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFF37474F),
    height: 1.6,
  ),
),
const SizedBox(height: 15),

Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.amber.withOpacity(0.15),
  ),
  child: const Icon(
    Icons.emoji_events,
    color: Colors.amber,
    size: 60,
  ),
),

const SizedBox(height: 15),

Text(
  '🏅 Adaptive Difficulty System',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
),

const SizedBox(height: 5),

Text(
  'Difficulty automatically adjusts based on your age.',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 14,
    color: Colors.black54,
  ),
),

const SizedBox(height: 20),

const SizedBox(height: 15),
                      const SizedBox(height: 24),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
  hintText: '👤 Hero Name',
  filled: true,
  fillColor: Colors.white,
  prefixIcon: const Icon(
    Icons.person,
    color: Colors.blue,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: BorderSide(
      color: Colors.blue.shade100,
    ),
  ),
),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
  hintText: '🎂 Hero Age',
  filled: true,
  fillColor: Colors.white,
  prefixIcon: const Icon(
    Icons.cake,
    color: Colors.orange,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: BorderSide(
      color: Colors.blue.shade100,
    ),
  ),
),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        difficulty,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: startGame,
                       style: ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFF2962FF),
  elevation: 12,
  shadowColor: Colors.blueAccent,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
  ),
  padding: const EdgeInsets.symmetric(
    horizontal: 50,
    vertical: 20,
  ),
),
                        child: const Text(
  '⚡ BEGIN THE CHALLENGE ⚡',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  ),
),
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LeaderboardScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.blue.shade700,
                            width: 1.8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          '🏆 Hall of Legends',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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

  final List<Color> cardColors = [
    Colors.blue.shade600,
    Colors.purple.shade600,
    Colors.teal.shade600,
    Colors.pink.shade600,
    Colors.orange.shade600,
    Colors.cyan.shade600,
    Colors.indigo.shade600,
    Colors.green.shade600,
  ];

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
      '🐼',
      '🦊',
      '🦄',
      '🐙',
      '🍎',
      '🍌',
      '🍓',
      '🍉',
      '⭐',
      '🌟',
      '🚗',
      '🚀',
      '🎈',
      '🎁',
      '⚽',
      '🎮',
      '🧠',
      '🎵',
      '🧩',
      '🧁',
      '🪐',
      '🎯',
      '🦋',
      '🌈',
      '🍕',
      '🎨',
      '💎',
      '🛸',
    ];

    int pairCount = widget.gridCount ~/ 2;

    cardValues = emojis.take(pairCount).toList();
    cardValues = [...cardValues, ...cardValues];
    cardValues.shuffle();

print(cardValues);
print("Total cards: ${cardValues.length}");
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
    print(
  "Clicked: $index | Selected: ${selectedCards.length}"
);
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

  print("MATCH: ${cardValues[first]}");
  print("First index: $first");
  print("Second index: $second");
  print(
    "Matched count: ${matchedCards.where((m) => m).length}",
  );

  checkWin();
}else {
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
        backgroundColor: Colors.black87,
        title: const Text(
          '⚔️ Warriors Never Quit!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shield,
              color: Colors.orange,
              size: 80,
            ),
            const SizedBox(height: 20),
            Text(
              '${widget.playerName}, this battle is not over yet!\n\n'
              'Final Score: $score\n\n'
              'A true hero always rises again 💪',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                setState(() {
                  selectedCards.clear();
                  score = 0;
                  generateCards();
                });
              },
              child: const Text('🔄 Try Again'),
            ),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${widget.playerName} | Score: $score | ⏱ $timeLeft',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3E5FC),
              Color(0xFF81D4FA),
              Color(0xFF4FC3F7),
              Color(0xFF1E88E5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: kToolbarHeight + 24,
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: GridView.builder(
            itemCount: widget.gridCount,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => flipCard(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: matchedCards[index]
                        ? Colors.green.shade600
                        : cardColors[index % cardColors.length],
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: cardFlipped[index] ? 1 : 0,
                      ),
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        final isFlipped = value > 0.5;

                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(value * pi),
                          alignment: Alignment.center,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              isFlipped ? cardValues[index] : '❓',
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
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
            color: const Color.fromRGBO(0, 0, 0, 0.6),
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
class RotationYTransition extends AnimatedWidget {
  final Widget child;

  const RotationYTransition({
    super.key,
    required Animation<double> turns,
    required this.child,
  }) : super(listenable: turns);

  @override
  Widget build(BuildContext context) {
    final animation =
        listenable as Animation<double>;

    final rotate =
        Tween(begin: pi, end: 0.0)
            .animate(animation);

    return AnimatedBuilder(
      animation: rotate,
      child: child,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationY(
            rotate.value,
          ),
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}