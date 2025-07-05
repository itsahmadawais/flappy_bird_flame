import 'package:flame_game/screens/game_over_screen.dart';
import 'package:flame_game/screens/main_meu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame_game/game/flappy_bird_game.dart';

void main() {
  final game = FlappyBirdGame();
  runApp(
    GameWidget(
      game: game,
      initialActiveOverlays: const [MainMeuScreen.id],
      overlayBuilderMap: {
        'mainMenu': (context, _) => MainMeuScreen(game: game),
        'gameOver': (context, _) => GameOverScreen(game: game),
      },
    ),
  );
}
