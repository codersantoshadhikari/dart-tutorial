// Flappy Bird game with Flutter + Flame
// Full explanation and Run in browser: https://flutter.dart-tutorial.dev/game-projects/flappy-bird-game/
// Use as lib/main.dart after: flutter pub add flame

import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const gameWidth = 400.0;
const gameHeight = 700.0;
const groundY = 650.0;

void main() => runApp(GameWidget(game: FlappyGame()));

enum Phase { ready, playing, over }

class FlappyGame extends FlameGame with HasCollisionDetection, TapCallbacks, KeyboardEvents {
  FlappyGame()
      : super(camera: CameraComponent.withFixedResolution(width: gameWidth, height: gameHeight));

  final random = Random();
  final bird = Bird();
  late final TextComponent message;
  Phase phase = Phase.ready;
  int score = 0;
  double pipeTimer = 0;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(RectangleComponent(
      size: Vector2(gameWidth, gameHeight),
      paint: Paint()..color = const Color(0xFF70C5CE), // sky
    ));
    world.add(Ground());
    world.add(bird);
    message = TextComponent(
      anchor: Anchor.topCenter,
      position: Vector2(gameWidth / 2, 60),
      priority: 10,
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
    world.add(message);
    showMessage();
  }

  void showMessage() {
    message.text = switch (phase) {
      Phase.ready => 'Tap to start',
      Phase.playing => '$score',
      Phase.over => 'Game over: $score. Tap!',
    };
  }

  void flap() {
    switch (phase) {
      case Phase.ready:
        phase = Phase.playing;
        bird.flap();
      case Phase.playing:
        bird.flap();
      case Phase.over:
        restart();
    }
    showMessage();
  }

  @override
  void onTapDown(TapDownEvent event) => flap();

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.space || event.logicalKey == LogicalKeyboardKey.arrowUp)) {
      flap();
    }
    return KeyEventResult.handled;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (phase != Phase.playing) return;
    pipeTimer += dt;
    if (pipeTimer > 1.6) {
      pipeTimer = 0;
      spawnPipes();
    }
  }

  void spawnPipes() {
    const gap = 170.0;
    final gapCenter = 150 + random.nextDouble() * 300;
    final topHeight = gapCenter - gap / 2;
    final bottomY = gapCenter + gap / 2;
    world.add(Pipe(position: Vector2(gameWidth + 10, 0), height: topHeight, isTop: true));
    world.add(Pipe(position: Vector2(gameWidth + 10, bottomY), height: groundY - bottomY));
  }

  void addPoint() {
    score++;
    showMessage();
  }

  void gameOver() {
    if (phase != Phase.playing) return;
    phase = Phase.over;
    showMessage();
  }

  void restart() {
    world.removeAll(world.children.whereType<Pipe>().toList());
    bird.reset();
    score = 0;
    pipeTimer = 0;
    phase = Phase.ready;
  }
}

class Bird extends CircleComponent with CollisionCallbacks, HasGameReference<FlappyGame> {
  Bird()
      : super(
          radius: 16,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFFFFD54F),
          children: [CircleHitbox()],
        );

  double velocityY = 0;

  @override
  Future<void> onLoad() async => reset();

  void reset() {
    position = Vector2(120, 330);
    velocityY = 0;
    angle = 0;
  }

  void flap() => velocityY = -330;

  @override
  void update(double dt) {
    super.update(dt);
    if (game.phase != Phase.playing) return;
    velocityY += 900 * dt;                       // gravity
    position.y += velocityY * dt;
    angle = (velocityY / 600).clamp(-0.5, 1.2);  // tilt up and down
    if (position.y < radius) {                   // ceiling
      position.y = radius;
      velocityY = 0;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is Pipe || other is Ground) game.gameOver();
  }
}

class Pipe extends RectangleComponent with HasGameReference<FlappyGame> {
  Pipe({required super.position, required double height, this.isTop = false})
      : super(
          size: Vector2(70, height),
          paint: Paint()..color = const Color(0xFF4CAF50),
          children: [RectangleHitbox()],
        );

  final bool isTop;
  bool scored = false;

  @override
  void update(double dt) {
    super.update(dt);
    if (game.phase != Phase.playing) return;
    position.x -= 160 * dt;
    // One point when the top pipe passes the bird.
    if (isTop && !scored && position.x + size.x < game.bird.position.x) {
      scored = true;
      game.addPoint();
    }
    if (position.x < -size.x) removeFromParent();
  }
}

class Ground extends RectangleComponent {
  Ground()
      : super(
          position: Vector2(0, groundY),
          size: Vector2(gameWidth, gameHeight - groundY),
          paint: Paint()..color = const Color(0xFFDED895),
          children: [RectangleHitbox()],
        );
}
