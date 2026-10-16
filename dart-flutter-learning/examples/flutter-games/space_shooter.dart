// Space Shooter game with Flutter + Flame
// Full explanation and Run in browser: https://flutter.dart-tutorial.dev/game-projects/space-shooter-game/
// Use as lib/main.dart after: flutter pub add flame

import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const w = 400.0;
const h = 700.0;

void main() => runApp(GameWidget(game: ShooterGame()));

class ShooterGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, TapCallbacks {
  ShooterGame() : super(camera: CameraComponent.withFixedResolution(width: w, height: h));

  final random = Random();
  late final Ship ship;
  late final TextComponent hud;
  int score = 0;
  int lives = 3;
  bool over = false;
  double enemyTimer = 0;
  double enemyEvery = 1.0; // seconds between enemies, gets shorter

  @override
  Color backgroundColor() => const Color(0xFF0B0F2A);

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    for (var i = 0; i < 60; i++) {
      world.add(Star(Vector2(random.nextDouble() * w, random.nextDouble() * h), random));
    }
    ship = Ship()..position = Vector2(w / 2, h - 80);
    world.add(ship);
    hud = TextComponent(
      position: Vector2(12, 10),
      priority: 20,
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
    world.add(hud);
    // Fire a bullet four times a second.
    world.add(TimerComponent(period: 0.25, repeat: true, onTick: () {
      if (!over) world.add(Bullet(ship.position + Vector2(0, -30)));
    }));
    updateHud();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (over) return;
    enemyTimer += dt;
    if (enemyTimer > enemyEvery) {
      enemyTimer = 0;
      enemyEvery = max(0.35, enemyEvery * 0.98);
      world.add(Enemy(Vector2(30 + random.nextDouble() * (w - 60), -30), 120 + random.nextDouble() * 120));
    }
  }

  void updateHud() {
    hud.text = over
        ? 'GAME OVER  Score: $score  (tap to play again)'
        : 'Score: $score   Lives: ${'♥' * lives}';
  }

  void enemyDestroyed(Vector2 at) {
    score += 10;
    updateHud();
    explode(at, Colors.orangeAccent);
  }

  void shipHit() {
    lives--;
    explode(ship.position.clone(), Colors.cyanAccent);
    ship.add(OpacityEffect.fadeOut(
      EffectController(duration: 0.1, reverseDuration: 0.1, repeatCount: 3),
    ));
    if (lives <= 0) over = true;
    updateHud();
  }

  void explode(Vector2 at, Color color) {
    world.add(ParticleSystemComponent(
      position: at,
      particle: Particle.generate(
        count: 25,
        lifespan: 0.6,
        generator: (_) => AcceleratedParticle(
          speed: (Vector2.random(random) - Vector2.all(0.5)) * 400,
          child: CircleParticle(radius: 2.5, paint: Paint()..color = color),
        ),
      ),
    ));
  }

  void restart() {
    world.removeAll([...world.children.whereType<Enemy>(), ...world.children.whereType<Bullet>()]);
    score = 0;
    lives = 3;
    enemyEvery = 1.0;
    over = false;
    ship.position = Vector2(w / 2, h - 80);
    updateHud();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (over) restart();
  }
}

class Ship extends PositionComponent
    with HasPaint, DragCallbacks, KeyboardHandler, CollisionCallbacks, HasGameReference<ShooterGame> {
  Ship() : super(size: Vector2(44, 48), anchor: Anchor.center) {
    paint = Paint()..color = Colors.cyanAccent; // HasPaint lets effects fade it
    add(PolygonHitbox.relative(
      [Vector2(0, -1), Vector2(1, 1), Vector2(-1, 1)], // a triangle hitbox
      parentSize: size,
    ));
  }

  double steer = 0;

  @override
  void render(Canvas canvas) {
    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y)
      ..lineTo(size.x / 2, size.y * 0.75)
      ..lineTo(0, size.y)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!game.over) position += event.localDelta;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    steer = (keys.contains(LogicalKeyboardKey.arrowRight) || keys.contains(LogicalKeyboardKey.keyD) ? 1.0 : 0.0) -
        (keys.contains(LogicalKeyboardKey.arrowLeft) || keys.contains(LogicalKeyboardKey.keyA) ? 1.0 : 0.0);
    if (game.over && keys.contains(LogicalKeyboardKey.space)) game.restart();
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += steer * 320 * dt;
    position.clamp(Vector2(size.x / 2, h / 2), Vector2(w - size.x / 2, h - size.y / 2));
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is Enemy && !game.over) {
      other.removeFromParent();
      game.shipHit();
    }
  }
}

class Bullet extends RectangleComponent with CollisionCallbacks, HasGameReference<ShooterGame> {
  Bullet(Vector2 position)
      : super(
          position: position,
          size: Vector2(4, 14),
          anchor: Anchor.center,
          paint: Paint()..color = Colors.yellowAccent,
          children: [RectangleHitbox()],
        );

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= 500 * dt;
    if (position.y < -20) removeFromParent();
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is Enemy) {
      removeFromParent();
      other.removeFromParent();
      game.enemyDestroyed(other.position.clone());
    }
  }
}

class Enemy extends RectangleComponent with HasGameReference<ShooterGame> {
  Enemy(Vector2 position, this.speed)
      : super(
          position: position,
          size: Vector2.all(34),
          anchor: Anchor.center,
          angle: pi / 4, // a diamond
          paint: Paint()..color = Colors.pinkAccent,
          children: [RectangleHitbox()],
        );

  final double speed;

  @override
  void update(double dt) {
    super.update(dt);
    if (game.over) return;
    position.y += speed * dt;
    if (position.y > h + 30) removeFromParent();
  }
}

class Star extends CircleComponent with HasGameReference<ShooterGame> {
  Star(Vector2 position, Random random)
      : speed = 20 + random.nextDouble() * 60,
        super(
          position: position,
          radius: random.nextDouble() * 1.5 + 0.5,
          paint: Paint()..color = Colors.white70,
        );

  final double speed;

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;
    if (position.y > h) position.y = 0;
  }
}
