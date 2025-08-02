import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import '../../utils/config.dart';
import '../../model/division_problem.dart';
import '../../model/play_state.dart';
import 'group_zone.dart';
import 'marble.dart';

class MarbleGroupingGame extends FlameGame
    with HasCollisionDetection, TapDetector {
  late DivisionProblem problem;
  bool gameCompleted = false;
  final Map<int, Set<Marble>> groupMap = {};
  List<GroupZone> groupZones = [];

  late PlayState _playState;
  MarbleGroupingGame(this.problem, {PlayState initialState = PlayState.welcome}){
    _playState = initialState;
  }


  double get width => size.x;

  double get height => size.y;

  double totalElapsedTime = 0.0;



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
  void update(double dt) {
    super.update(dt);
    // Tambahkan delta time (dt) ke total setiap frame.
    totalElapsedTime += dt;
  }


  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if (playState != PlayState.welcome) {
      setupGame();
    }
  }

  void setupGame() {
    groupMap.clear();
    groupZones.clear();
    removeAll(children.query<Marble>());
    removeAll(children.query<GroupZone>());

    playState = PlayState.playing;
    final random = math.Random();

    final zoneCount = problem.divisor;

    final availableHeight = height - (2 * kGameMargin) - ((zoneCount - 1) * kGroupZoneSpacing);
    final zoneHeight = availableHeight / zoneCount;

    for (int i = 0; i < zoneCount; i++) {
      final y = kGameMargin + i * (zoneHeight + kGroupZoneSpacing);

      final zone = GroupZone(
        position: Vector2(0, y),
        color: zoneColors[i % zoneColors.length],
        size: Vector2(kGroupZoneWidth, zoneHeight),
        index: i,
      );

      add(zone);
      groupZones.add(zone);
    }

    final List<Vector2> marblePositions = [];
    final double marbleSize = 40.0;

    final startX = kGroupZoneWidth + kGameMargin + 20;
    final endX = width - kGameMargin ;

    final startY = kGameMargin;
    final endY = height - kGameMargin - 100;

    int attempts = 0;



    for (int i = 0; i < problem.dividend; i++) {
      Vector2 position;

      do {
        final x = (startX + random.nextDouble() * (endX - startX)).clamp(
          startX,
          endX - marbleSize,
        );

        final y = startY + random.nextDouble() * (endY - startY);
        position = Vector2(x, y);

        attempts++;
        if (attempts > 1000) break;

      } while (marblePositions.any((p) => p.distanceTo(position) < kMinDistance));

      marblePositions.add(position);
      add(Marble(position: position));

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
      final totalMarbles = counts.values.fold(0, (a, b) => a + b);
      final allZonesUsed = counts.length == problem.divisor;
      if (allCorrect && allZonesUsed && totalMarbles == problem.dividend) {
        playState = PlayState.correct;
      } else {
        playState = PlayState.wrong;
      }

    });
  }
}
