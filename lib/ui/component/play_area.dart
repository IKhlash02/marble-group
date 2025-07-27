import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:marble_group/utils/config.dart';

import 'marble_grouping_game.dart';

class PlayArea extends RectangleComponent with HasGameReference<MarbleGroupingGame>{
  PlayArea()
      : super(
      paint: Paint()..color = AppColors.background,
      children: [RectangleHitbox()]);

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }

}
