import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:marble_group/component/marble_grouping_game.dart';
import 'package:marble_group/config.dart';

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
