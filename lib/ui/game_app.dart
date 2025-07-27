import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:marble_group/ui/widget/pixel_style.dart';
import 'package:marble_group/utils/config.dart';
import 'package:marble_group/model/play_state.dart';
import 'package:marble_group/ui/overlay_screen.dart';
import 'package:marble_group/model/overlay_type.dart';

import '../model/division_problem.dart';
import 'component/marble_grouping_game.dart';

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
      body: Stack(
        children: [
          SafeArea(
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
                  margin: EdgeInsets.only(bottom: 30, top: 20),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 28),
                        width: double.infinity ,
                        height: 120,
                        decoration: pixelBoxDecoration(
                          AppColors.cardBackground,
                          15.0,
                          4,
                          6,
                        ),

                        child: Text(
                          '${problems[currentLevel].dividend} ÷ ${problems[currentLevel].divisor}',
                          style: TextStyle(
                            height: 0.7,
                            color: Colors.purple[100],
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -20,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          decoration: pixelBoxDecoration(
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
                      PlayState.welcome.name: (context, _) =>  OverlayScreen(
                        title: "MARBLE DIVISION",
                        subtitle: "Group the marbles to solve the division!",
                        overlayType: OverlayType.welcome,
                        onTap: () {
                          game.setupGame();
                        },
                      ),

                      PlayState.correct.name: (context, _) =>  OverlayScreen(
                        title: "PERFECT!",
                        subtitle: "Great job! You grouped the marbles correctly!",
                        overlayType: OverlayType.correct,
                        onTap: () {
                          game.setupGame();
                        },
                      ),

                      PlayState.wrong.name: (context, _) =>  OverlayScreen(
                        title: "OOPS!",
                        subtitle: "Group the marbles into equal parts",
                        overlayType: OverlayType.wrong,
                        onTap: () {
                          game.setupGame();
                        },
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
                    decoration: pixelBoxDecoration(
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
        ],
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
