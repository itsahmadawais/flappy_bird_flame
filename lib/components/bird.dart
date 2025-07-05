import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_game/game/assets.dart';
import 'package:flame_game/game/bird_movement.dart';
import 'package:flame_game/game/configuration.dart';
import 'package:flame_game/game/flappy_bird_game.dart';
import 'package:flutter/animation.dart';

class Bird extends SpriteGroupComponent<BirdMovementEnum>
    with HasGameReference<FlappyBirdGame>, CollisionCallbacks {
  Bird();

  int score = 0;

  @override
  FutureOr<void> onLoad() async {
    final birdMidFlap = await game.loadSprite(Assets.birdMidFlap);
    final birdUpFlap = await game.loadSprite(Assets.birdUpFlap);
    final birdDownFlap = await game.loadSprite(Assets.birdDownFlap);

    FlameAudio.audioCache.prefix = 'audio/';

    size = Vector2(50, 40);
    position = Vector2(50, game.size.y / 2 - size.y / 2);
    sprites = {
      BirdMovementEnum.middle: birdMidFlap,
      BirdMovementEnum.up: birdUpFlap,
      BirdMovementEnum.down: birdDownFlap,
    };
    current = BirdMovementEnum.middle;

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += Configuration.birdVelocity * dt;

    if (position.y < 1) {
      gameOver();
    }
  }

  void fly() {
    add(
      MoveByEffect(
        Vector2(0, Configuration.gravity),
        EffectController(duration: 0.2, curve: Curves.decelerate),
        onComplete: () => current = BirdMovementEnum.down,
      ),
    );
    FlameAudio.play(Assets.flying);
    current = BirdMovementEnum.up;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    gameOver();
  }

  void gameOver() {
    FlameAudio.play(Assets.collision);
    game.overlays.add('gameOver');
    game.pauseEngine();
    game.isHit = true;
  }

  void reset() {
    position = Vector2(50, game.size.y / 2 - size.y / 2);
    score = 0;
  }
}
