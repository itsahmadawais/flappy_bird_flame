import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_game/game/assets.dart';
import 'package:flame_game/game/flappy_bird_game.dart';

class Background extends SpriteComponent with HasGameReference<FlappyBirdGame> {
  Background();

  @override
  FutureOr<void> onLoad() async {
    final background = await Flame.images.load(Assets.background);
    size = game.size;
    sprite = Sprite(background);
  }
}
