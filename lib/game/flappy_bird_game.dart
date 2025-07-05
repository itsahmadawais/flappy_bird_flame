import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/timer.dart';
import 'package:flame_game/components/background.dart';
import 'package:flame_game/components/bird.dart';
import 'package:flame_game/components/ground.dart';
import 'package:flame_game/components/pipe_group.dart';
import 'package:flame_game/game/configuration.dart';
import 'package:flutter/material.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  late Timer interval;
  bool isHit = false;
  late TextComponent score;

  @override
  FutureOr<void> onLoad() {
    addAll([Background(), Ground(), bird = Bird(), score = buildScore()]);
    interval = Timer(
      Configuration.pipeInterval,
      onTick: () => add(PipeGroup()),
      repeat: true,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);

    score.text = 'Score: ${bird.score}';
  }

  @override
  void onTap() {
    super.onTap();
    bird.fly();
  }

  TextComponent buildScore() {
    return TextComponent(
      text: 'Score: 0',
      position: Vector2(size.x / 2, size.y / 2 * 0.2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          fontFamily: 'Game',
          color: Colors.white,
        ),
      ),
    );
  }
}
