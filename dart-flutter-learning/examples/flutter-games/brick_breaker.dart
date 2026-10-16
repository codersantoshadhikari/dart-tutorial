// Brick Breaker game with Flutter + Flame
// Full explanation and Run in browser: https://flutter.dart-tutorial.dev/game-projects/brick-breaker-game/
// Use as lib/main.dart after: flutter pub add flame

import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const w = 400.0;
const h = 700.0;
const brickColors = [Colors.red, Colors.orange, Colors.amber, Colors.green, Colors.blue];

void main() => runApp(GameWidget(game: BreakoutGame()));

class BreakoutGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, TapCallbacks {
  BreakoutGame() : super(camera: CameraComponent.withFixedResolution(width: w, height: h));

  final paddle = Paddle();
  final ball = Ball();
  late final TextComponent hud;
  int score = 0;
  int lives = 3;
  int level = 1;

  @override
  Color backgroundColor() => const Color(0xFF1D1F33);

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    hud = TextComponent(
      position: Vector2(12, 12),
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
    world.addAll([paddle, ball, hud]);
    buildBricks();
    resetBall();
  }

  void buildBricks() {
    const cols = 8, gap = 6.0;
    const brickW = (w - gap * (cols + 1)) / cols;
    for (var row = 0; row < 5; row++) {
      for (var col = 0; col < cols; col++) {
        world.add(Brick(
          Vector2(gap + col * (brickW + gap), 70 + row * 26),
          Vector2(brickW, 20),
          brickColors[row],
        ));
      }
    }
  }

  void resetBall() {
    ball.launched = false;
    ball.velocity.setZero();
    updateHud();
  }

  void launch() {
    if (lives <= 0) {
      // Start a new game
      world.removeAll(world.children.whereType<Brick>().toList());
      score = 0;
      lives = 3;
      level = 1;
      buildBricks();
      resetBall();
      return;
    }
    if (ball.launched) return;
    ball.launched = true;
    ball.velocity.setValues(150, -350 - level * 30.0);
    updateHud();
  }

  void brickBroken() {
    score += 10;
    updateHud();
    // The brick just hit is removed at the end of the frame, so it still counts here.
    if (world.children.whereType<Brick>().length <= 1) {
      level++;
      buildBricks();
      resetBall();
    }
  }

  void ballLost() {
    lives--;
    resetBall();
  }

  void updateHud() {
    hud.text = lives <= 0
        ? 'Game over! Score: $score. Tap to play again'
        : 'Score: $score   Lives: $lives   Level: $level${ball.launched ? '' : '   (tap to launch)'}';
  }

  @override
  void onTapDown(TapDownEvent event) => launch();
}

class Paddle extends RectangleComponent
    with DragCallbacks, KeyboardHandler, HasGameReference<BreakoutGame> {
  Paddle()
      : super(
          size: Vector2(90, 14),
          anchor: Anchor.center,
          position: Vector2(w / 2, h - 50),
          paint: Paint()..color = Colors.white,
          children: [RectangleHitbox()],
        );

  double move = 0;

  @override
  void onDragUpdate(DragUpdateEvent event) => position.x += event.localDelta.x;

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    move = (keys.contains(LogicalKeyboardKey.arrowRight) || keys.contains(LogicalKeyboardKey.keyD) ? 1.0 : 0.0) -
        (keys.contains(LogicalKeyboardKey.arrowLeft) || keys.contains(LogicalKeyboardKey.keyA) ? 1.0 : 0.0);
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) game.launch();
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x = (position.x + move * 420 * dt).clamp(size.x / 2, w - size.x / 2);
  }
}

class Ball extends CircleComponent with CollisionCallbacks, HasGameReference<BreakoutGame> {
  Ball()
      : super(
          radius: 8,
          anchor: Anchor.center,
          paint: Paint()..color = Colors.yellowAccent,
          children: [CircleHitbox()],
        );

  final velocity = Vector2.zero();
  bool launched = false;

  @override
  void update(double dt) {
    super.update(dt);
    if (!launched) {
      // Sit on the paddle until launched
      position = game.paddle.position - Vector2(0, 20);
      return;
    }
    position += velocity * dt;

    // Walls
    if (position.x < radius) {
      position.x = radius;
      velocity.x = velocity.x.abs();
    } else if (position.x > w - radius) {
      position.x = w - radius;
      velocity.x = -velocity.x.abs();
    }
    if (position.y < radius) {
      position.y = radius;
      velocity.y = velocity.y.abs();
    }
    if (position.y > h + radius) game.ballLost();
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is Paddle) {
      // Where on the paddle did it hit? -1 (left edge) .. 1 (right edge)
      final offset = (position.x - other.position.x) / (other.size.x / 2);
      final speed = velocity.length;
      velocity
        ..x = speed * 0.8 * offset.clamp(-1.0, 1.0)
        ..y = -sqrt(max(speed * speed - velocity.x * velocity.x, speed * speed * 0.2));
    } else if (other is Brick) {
      final hitFromSide =
          position.x < other.position.x || position.x > other.position.x + other.size.x;
      if (hitFromSide) {
        velocity.x = -velocity.x;
      } else {
        velocity.y = -velocity.y;
      }
      other.removeFromParent();
      game.brickBroken();
    }
  }
}

class Brick extends RectangleComponent {
  Brick(Vector2 position, Vector2 size, Color color)
      : super(
          position: position,
          size: size,
          paint: Paint()..color = color,
          children: [RectangleHitbox(collisionType: CollisionType.passive)],
        );
}
