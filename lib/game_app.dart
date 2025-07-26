import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:marble_group/component/marble_grouping_game.dart';
import 'package:marble_group/config.dart';
import 'package:marble_group/data/play_state.dart';
import 'package:marble_group/widget/overlay_screen.dart';

import 'data/division_problem.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final MarbleGroupingGame game;
  int currentLevel = 0;
  List<DivisionProblem> problems = [
    DivisionProblem(dividend: 24, divisor: 3, answer: 8),
    DivisionProblem(dividend: 15, divisor: 5, answer: 3),
    DivisionProblem(dividend: 20, divisor: 4, answer: 5),
    DivisionProblem(dividend: 18, divisor: 6, answer: 3),
  ];

  @override
  void initState() {
    super.initState();
    game = MarbleGroupingGame(problems[currentLevel]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xFFC37BBA),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Find the result of the division',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 40, top: 20),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${problems[currentLevel].dividend} ÷ ${problems[currentLevel].divisor}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A1B9A),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Text(
                        '=',
                        style: TextStyle(
                          height: 0,
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GameWidget(
                game: game,
                overlayBuilderMap: {
                  PlayState.welcome.name: (context, game) =>
                      const OverlayScreen(
                        title: "TAP TO PLAY",
                        subtitle: "swipe",
                      ),

                  PlayState.correct.name: (context, game) =>
                      const OverlayScreen(
                        title: "Correct!",
                        subtitle: "Well done! Ready for the next level?",
                      ),

                  PlayState.wrong.name: (context, game) => const OverlayScreen(
                    title: "Try Again",
                    subtitle:
                        "Group the marbles correctly to solve the division!",
                  ),
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: ElevatedButton(
                onPressed: () {
                  game.checkAnswer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBackground,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      width: 4,
                      strokeAlign: 0,
                      color: Color.lerp(
                        AppColors.buttonBackground,
                        Colors.black,
                        0.3,
                      )!,
                    ),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Check Answer',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void nextLevel() {
    if (currentLevel < problems.length - 1) {
      setState(() {
        currentLevel++;
        game = MarbleGroupingGame(problems[currentLevel]);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You completed all levels!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentLevel = 0;
                  game = MarbleGroupingGame(problems[currentLevel]);
                });
              },
              child: Text('Play Again'),
            ),
          ],
        ),
      );
    }
  }
}
