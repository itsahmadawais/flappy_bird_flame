import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_game/game/assets.dart';
import 'package:flame_game/game/configuration.dart';
import 'package:flame_game/game/flappy_bird_game.dart';
import 'package:flame_game/game/pipe_position.dart';

class Pipe extends SpriteComponent with HasGameReference<FlappyBirdGame> {
  Pipe({required this.pipePosition, required this.height});

  @override
  final double height;
  final PipePositionEnum pipePosition;

  @override
  FutureOr<void> onLoad() async {
    final pipe = await Flame.images.load(Assets.pipe);
    final pipeRotated = await Flame.images.load(Assets.pipeRotated);
    size = Vector2(50, height);

    switch (pipePosition) {
      case PipePositionEnum.top:
        position.y = 0;
        sprite = Sprite(pipeRotated);
        break;
      case PipePositionEnum.bottom:
        position.y = game.size.y - size.y - Configuration.groundHeight;
        sprite = Sprite(pipe);
        break;
    }

    add(RectangleHitbox());
  }
}
