// Endless Runner game with Flutter + Flame
// Full explanation and Run in browser: https://flutter.dart-tutorial.dev/game-projects/endless-runner-game/
// Use as lib/main.dart after: flutter pub add flame

import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const w = 700.0;
const h = 350.0;
const groundY = 290.0;

void main() => runApp(GameWidget(game: RunnerGame()));

class RunnerGame extends FlameGame with HasCollisionDetection, TapCallbacks, KeyboardEvents {
  RunnerGame() : super(camera: CameraComponent.withFixedResolution(width: w, height: h));

  final random = Random();
  final runner = Runner();
  late final TextComponent hud;
  double speed = 300;        // how fast the world moves (pixels per second)
  double distance = 0;
  double nextObstacle = 1;   // seconds until the next obstacle
  int best = 0;
  bool running = false;
  bool dead = false;

  @override
  Color backgroundColor() => const Color(0xFFF7F7F7);

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(RectangleComponent(
      position: Vector2(0, groundY),
      size: Vector2(w, 4),
      paint: Paint()..color = const Color(0xFF535353),
    ));
    world.add(runner);
    hud = TextComponent(
      position: Vector2(16, 12),
      textRenderer: TextPaint(style: const TextStyle(color: Color(0xFF535353), fontSize: 18)),
    );
    world.add(hud);
    updateHud();
  }

  int get score => distance ~/ 10;

  void updateHud() {
    hud.text = dead
        ? 'GAME OVER   Score: $score   Best: $best   (tap to restart)'
        : running
            ? 'Score: $score   Best: $best'
            : 'Tap or press Space to start';
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!running || dead) return;
    distance += speed * dt;
    speed += 6 * dt; // slowly faster
    nextObstacle -= dt;
    if (nextObstacle <= 0) {
      world.add(Obstacle(random));
      nextObstacle = 0.9 + random.nextDouble() * 1.2;
    }
    updateHud();
  }

  void jumpPressed() {
    if (dead) {
      restart();
    } else if (!running) {
      running = true;
    } else {
      runner.jump();
    }
  }

  void jumpReleased() => runner.cutJump();

  void die() {
    dead = true;
    best = max(best, score);
    updateHud();
  }

  void restart() {
    world.removeAll(world.children.whereType<Obstacle>().toList());
    speed = 300;
    distance = 0;
    nextObstacle = 1;
    dead = false;
    running = true;
    runner.reset();
  }

  @override
  void onTapDown(TapDownEvent event) => jumpPressed();

  @override
  void onTapUp(TapUpEvent event) => jumpReleased();

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isJumpKey = event.logicalKey == LogicalKeyboardKey.space ||
        event.logicalKey == LogicalKeyboardKey.arrowUp;
    if (isJumpKey && event is KeyDownEvent) jumpPressed();
    if (isJumpKey && event is KeyUpEvent) jumpReleased();
    return KeyEventResult.handled;
  }
}

class Runner extends RectangleComponent with CollisionCallbacks, HasGameReference<RunnerGame> {
  Runner()
      : super(
          size: Vector2(36, 44),
          anchor: Anchor.bottomLeft,
          paint: Paint()..color = const Color(0xFF535353),
          children: [RectangleHitbox(size: Vector2(30, 40), position: Vector2(3, 2))],
        );

  double velocityY = 0;
  bool get onGround => position.y >= groundY;

  @override
  Future<void> onLoad() async => reset();

  void reset() {
    position = Vector2(80, groundY);
    velocityY = 0;
  }

  void jump() {
    if (onGround) velocityY = -720;
  }

  // Releasing early makes a short hop.
  void cutJump() {
    if (velocityY < -250) velocityY = -250;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.dead) return;
    velocityY += 2200 * dt; // gravity
    position.y += velocityY * dt;
    if (position.y > groundY) {
      position.y = groundY;
      velocityY = 0;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is Obstacle) game.die();
  }
}

class Obstacle extends RectangleComponent with HasGameReference<RunnerGame> {
  Obstacle(Random random)
      : super(
          // Random cactus size: short and wide, or tall and thin
          size: random.nextBool() ? Vector2(24, 40) : Vector2(40, 30),
          anchor: Anchor.bottomLeft,
          position: Vector2(w + 20, groundY),
          paint: Paint()..color = const Color(0xFF2E7D32),
          children: [RectangleHitbox(collisionType: CollisionType.passive)],
        );

  @override
  void update(double dt) {
    super.update(dt);
    if (game.dead) return;
    position.x -= game.speed * dt;
    if (position.x < -size.x) removeFromParent();
  }
}
