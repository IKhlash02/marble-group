import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:marble_group/component/play_area.dart';

import '../config.dart';
import '../data/division_problem.dart';
import '../data/play_state.dart';
import 'group_zone.dart';
import 'marble.dart';

class MarbleGroupingGame extends FlameGame
    with HasCollisionDetection, TapDetector {
  late DivisionProblem problem;
  bool gameCompleted = false;
  final Map<int, Set<Marble>> groupMap = {};
  List<GroupZone> groupZones = [];

  MarbleGroupingGame(this.problem);

  double get width => size.x;

  double get height => size.y;

  final margin = 20.0;

  late PlayState _playState;

  PlayState get playState => _playState;

  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.wrong:
      case PlayState.correct:
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.wrong.name);
        overlays.remove(PlayState.correct.name);
    }
  }

  @override
  void onTap() {
    super.onTap();
    setupGame();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(PlayArea());
    playState = PlayState.welcome;
  }

  void setupGame() {
    if (playState == PlayState.playing) return;
    groupMap.clear();
    groupZones.clear();
    removeAll(children.query<Marble>());
    removeAll(children.query<GroupZone>());

    playState = PlayState.playing;

    for (int i = 0; i < problem.divisor; i++) {
      final zone = GroupZone(
        position: Vector2(0, (height / problem.divisor) * i),
        color: zoneColors[i % zoneColors.length],
        size: Vector2(70, (height / problem.divisor) - 70),
        index: i,
      );
      add(zone);
      groupZones.add(zone);
    }

    final random = math.Random();
    for (int i = 0; i < problem.dividend; i++) {
      final marble = Marble(
        position: Vector2(
          100 + (i % 6) * 60 + random.nextDouble() * 20,
          200 + (i ~/ 6) * 60 + random.nextDouble() * 20,
        ),
      );
      add(marble);
    }
    gameCompleted = false;
  }

  void checkAnswer() {
    final expected = problem.answer;
    Map<int, int> counts = {};
    for (var marble in children.query<Marble>()) {
      if (marble.zoneIndex != null) {
        counts[marble.zoneIndex!] = (counts[marble.zoneIndex!] ?? 0) + 1;
      }
    }
    var allCorrect = true;
    for (final zone in groupZones) {
      final cnt = counts[zone.index] ?? 0;
      final isOk = cnt == expected;
      zone.markCorrect(isOk);
      if (!isOk) allCorrect = false;
    }

    Future.delayed(Duration(seconds: 1), () {
      for (final zone in groupZones) {
        zone.revertColor();
      }
    });

    final totalMarbles = counts.values.fold(0, (a, b) => a + b);
    final allZonesUsed = counts.length == problem.divisor;
    if (allCorrect && allZonesUsed && totalMarbles == problem.dividend) {
      playState = PlayState.correct;
    } else {
      playState = PlayState.wrong;
    }
  }

  void reset() {
    setupGame();
  }
}
