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
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColors.headerBackground,
              ),
              child: Text(
                'Find the result of the division',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.purple[100],
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
                    margin: EdgeInsets.symmetric(horizontal: 28),
                    width: double.infinity,
                    height: 120,
                    decoration: _boxDecoration(
                      AppColors.cardBackground,
                      15.0,
                      4,
                      6,
                    ),

                    child: Center(
                      child: Text(
                        '${problems[currentLevel].dividend} ÷ ${problems[currentLevel].divisor}',
                        style: TextStyle(
                          color: Colors.purple[100],
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: _boxDecoration(
                        AppColors.cardSmallBackground,
                        10.0,
                        5,
                        4,
                      ),
                      child: Text(
                        '=',
                        style: TextStyle(
                          height: 0.8,
                          color: Colors.purple[100],
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
            InkWell(
              onTap: () {
                game.checkAnswer();
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: _boxDecoration(
                  AppColors.buttonBackground,
                  40,
                  3,
                  4,
                ),
                child: Text(
                  'Check Answer',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green[800],
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

  BoxDecoration _boxDecoration(
    Color baseColor,
    double circular,
    double dx,
    double dy,
  ) {
    return BoxDecoration(
      color: baseColor,
      borderRadius: BorderRadius.circular(circular),
      border: Border.all(
        color: Color.lerp(baseColor, Colors.black, 0.3)!,
        width: 3,
      ),
      boxShadow: [
        BoxShadow(
          color: Color.lerp(baseColor, Colors.black, 0.3)!,
          spreadRadius: 2,
          offset: Offset(dx, dy),
        ),
      ],
    );
  }
}
