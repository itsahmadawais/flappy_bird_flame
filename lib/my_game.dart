import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flame_audio/flame_audio.dart';

class MyGame extends FlameGame with KeyboardEvents {
  late Offset ballCenter;

  final double ballRadius = 50;

  late Rect goalArea;

  final Paint golaPaint = Paint()..color = Colors.lightGreen;
  bool goalReached = false;

  late Paint ballPaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 2;

  Vector2 ballVelocity = Vector2(0, 0);
  final speed = 1500;

  bool audioAvailable = false;
  String audioFile = '';

  @override
  Future<void> onLoad() async {
    ballCenter = Offset(ballRadius, ballRadius);

    goalArea = Rect.fromLTWH(size.x - 100, size.y - 100, 80, 500);
    // Try to load audio with fallback formats
    try {
      FlameAudio.audioCache.prefix = 'audio/';
      await FlameAudio.audioCache.loadAll(['bounce.mp3', 'ball-hit.mp3']);
      // final uri = await FlameAudio.audioCache.load('ball-hit.mp3');
      // print('Loaded asset URI: $uri');

      audioAvailable = true;
      audioFile = 'bounce.mp3';
    } catch (e) {
      print('Audio loading failed: $e');
    }
  }

  void playBounceSound() {
    if (audioAvailable) {
      try {
        FlameAudio.play(audioFile, volume: 1.0);
      } catch (e) {
        print('Audio playback failed: $e');
      }
    }
  }

  void playWinSound() {
    try {
      FlameAudio.play('ball-hit.mp3', volume: 1.0);
    } catch (e) {
      print('Audio playback failed: $e');
    }
  }

  @override
  void update(double dt) {
    // Step 1: Calculate next position
    var dX = ballVelocity.x * speed * dt;
    var dY = ballVelocity.y * speed * dt;

    var nextCenter = ballCenter.translate(dX, dY);

    // Step 2: Check for collisions with screen edges

    // ⬅️ Left wall
    if (nextCenter.dx - ballRadius < 0) {
      ballVelocity.x = -ballVelocity.x; // Bounce (reverse x)
      nextCenter = ballCenter.translate(-dX, dY);
      ballPaint.color = Colors.yellow;
      playBounceSound();
    }

    // ➡️ Right wall
    if (nextCenter.dx + ballRadius > size.x) {
      ballVelocity.x = -ballVelocity.x;
      nextCenter = ballCenter.translate(-dX, dY);
      ballPaint.color = Colors.purpleAccent;
      playBounceSound();
    }

    // ⬆️ Top wall
    if (nextCenter.dy - ballRadius < 0) {
      nextCenter = Offset(nextCenter.dx, ballRadius);
      ballVelocity.y = -ballVelocity.y;
      ballPaint.color = Colors.red;
      playBounceSound();
    }

    // ⬇️ Bottom wall
    if (nextCenter.dy + ballRadius > size.y) {
      nextCenter = Offset(nextCenter.dx, size.y - ballRadius);
      ballVelocity.y = -ballVelocity.y;
      ballPaint.color = Colors.greenAccent;
      playBounceSound();
    }

    // Step 3: Update the center
    ballCenter = nextCenter;

    final ballRect = Rect.fromCircle(center: ballCenter, radius: ballRadius);

    if (ballRect.overlaps(goalArea)) {
      goalReached = true;
      ballPaint.color = Colors.blue;
      // Optional: stop ball movement
      ballVelocity = Vector2.zero();
      playWinSound();
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(ballCenter, ballRadius, ballPaint);
    canvas.drawRect(goalArea, golaPaint);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    ballVelocity = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      ballVelocity.y = 1;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      ballVelocity.y = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      ballVelocity.x = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      ballVelocity.x = 1;
    }

    return KeyEventResult.handled;
  }
}
