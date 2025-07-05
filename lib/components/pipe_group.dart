import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_game/components/pipe.dart';
import 'package:flame_game/game/assets.dart';
import 'package:flame_game/game/configuration.dart';
import 'package:flame_game/game/flappy_bird_game.dart';
import 'package:flame_game/game/pipe_position.dart';
import 'package:flutter/foundation.dart';

class PipeGroup extends PositionComponent
    with HasGameReference<FlappyBirdGame> {
  final _random = Random();

  @override
  FutureOr<void> onLoad() async {
    position.x = game.size.x;
    final heightMinusGround = game.size.y - Configuration.groundHeight;
    final spacing = 100 + _random.nextDouble() * (heightMinusGround / 4);
    final centerY =
        spacing + _random.nextDouble() * (heightMinusGround - spacing);
    addAll([
      Pipe(pipePosition: PipePositionEnum.top, height: centerY - spacing / 2),
      Pipe(
        pipePosition: PipePositionEnum.bottom,
        height: heightMinusGround - (centerY + spacing / 2),
      ),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Configuration.gameSpeed * dt;

    if (position.x < -10) {
      removeFromParent();
      updateScore();
    }

    if (game.isHit) {
      removeFromParent();
      game.isHit = false;
    }
  }

  void updateScore() {
    game.bird.score += 1;
    FlameAudio.play(Assets.point);
  }
}
