// Snake game with Flutter + Flame
// Full explanation and Run in browser: https://flutter.dart-tutorial.dev/game-projects/snake-game/
// Use as lib/main.dart after: flutter pub add flame

import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const cells = 20;          // the board is 20 × 20 cells
const cellSize = 20.0;     // each cell is 20 × 20 pixels
const boardTop = 40.0;     // space for the score at the top

void main() => runApp(GameWidget(game: SnakeGame()));

class SnakeGame extends FlameGame with KeyboardEvents, DragCallbacks, TapCallbacks {
  SnakeGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: cells * cellSize,
            height: cells * cellSize + boardTop,
          ),
        );

  final random = Random();
  final snake = <Point<int>>[];          // first item = the head
  Point<int> direction = const Point(1, 0);
  Point<int> nextDirection = const Point(1, 0);
  Point<int> food = const Point(10, 10);
  double timer = 0;
  double stepTime = 0.15;                // seconds per move
  int score = 0;
  int best = 0;
  bool gameOver = false;
  late final TextComponent scoreText;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(Board());
    scoreText = TextComponent(
      position: Vector2(10, 8),
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 18)),
    );
    world.add(scoreText);
    reset();
  }

  void reset() {
    snake
      ..clear()
      ..addAll(const [Point(5, 10), Point(4, 10), Point(3, 10)]);
    direction = const Point(1, 0);
    nextDirection = direction;
    score = 0;
    stepTime = 0.15;
    timer = 0;
    gameOver = false;
    placeFood();
    updateText();
  }

  void placeFood() {
    do {
      food = Point(random.nextInt(cells), random.nextInt(cells));
    } while (snake.contains(food));
  }

  void updateText() {
    scoreText.text = gameOver
        ? 'Game over! Score $score. Tap or Space'
        : 'Score: $score    Best: $best';
  }

  void turn(Point<int> d) {
    // The snake cannot turn straight back into itself.
    if (d.x == -direction.x && d.y == -direction.y) return;
    nextDirection = d;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameOver) return;

    // Move one cell every stepTime seconds.
    timer += dt;
    if (timer < stepTime) return;
    timer = 0;

    direction = nextDirection;
    final head = snake.first;
    final newHead = Point(head.x + direction.x, head.y + direction.y);

    final hitWall = newHead.x < 0 || newHead.y < 0 || newHead.x >= cells || newHead.y >= cells;
    if (hitWall || snake.contains(newHead)) {
      gameOver = true;
      best = max(best, score);
      updateText();
      return;
    }

    snake.insert(0, newHead);
    if (newHead == food) {
      score++;
      stepTime = max(0.06, stepTime * 0.96); // a little faster each time
      placeFood();
      updateText();
    } else {
      snake.removeLast(); // not growing: drop the tail
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) turn(const Point(0, -1));
      if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.keyS) turn(const Point(0, 1));
      if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.keyA) turn(const Point(-1, 0));
      if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.keyD) turn(const Point(1, 0));
      if (key == LogicalKeyboardKey.space && gameOver) reset();
    }
    return KeyEventResult.handled;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    final v = event.velocity;
    if (v.x.abs() > v.y.abs()) {
      turn(Point(v.x > 0 ? 1 : -1, 0));
    } else {
      turn(Point(0, v.y > 0 ? 1 : -1));
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (gameOver) reset();
  }
}

/// Draws the board, the food and the snake.
class Board extends PositionComponent with HasGameReference<SnakeGame> {
  Board() : super(position: Vector2(0, boardTop), size: Vector2.all(cells * cellSize));

  final _background = Paint()..color = const Color(0xFF1B2B1B);
  final _body = Paint()..color = const Color(0xFF7CD34B);
  final _head = Paint()..color = const Color(0xFFC6F68D);
  final _food = Paint()..color = const Color(0xFFFF5252);

  Rect _cell(Point<int> p) =>
      Rect.fromLTWH(p.x * cellSize + 1, p.y * cellSize + 1, cellSize - 2, cellSize - 2);

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _background);
    canvas.drawOval(_cell(game.food), _food);
    for (var i = 0; i < game.snake.length; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(_cell(game.snake[i]), const Radius.circular(5)),
        i == 0 ? _head : _body,
      );
    }
  }
}
