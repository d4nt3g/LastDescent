import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/camera.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final Player player;
  late final World world;
  final Vector2 screenSize = Vector2(1920, 1080);
  final Vector2 mapSize = Vector2(3840, 2160);
  final Random random = Random();

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(resolution: screenSize);
    world = World();
    camera.world = world;
    add(world);
    add(camera);

    world.add(RectangleComponent(
      size: mapSize,
      paint: Paint()..color = const Color(0xFF222222),
      priority: -1,
    ));

    player = Player(position: mapSize / 2, mapSize: mapSize);
    world.add(player);
    camera.follow(player);

    spawnEnemies(10);
  }

  void spawnEnemies(int count) {
    for (int i = 0; i < count; i++) {
      final pos = _generatePositionOutsideView(player.position);
      world.add(Enemy(position: pos, target: player));
    }
  }

  Vector2 _generatePositionOutsideView(Vector2 playerPos) {
    const viewWidth = 1920;
    const viewHeight = 1080;
    const padding = 100;

    while (true) {
      final x = random.nextDouble() * mapSize.x;
      final y = random.nextDouble() * mapSize.y;
      final dx = (x - playerPos.x).abs();
      final dy = (y - playerPos.y).abs();

      if ((dx > viewWidth / 2 + padding || dy > viewHeight / 2 + padding) &&
          x >= 0 &&
          x <= mapSize.x &&
          y >= 0 &&
          y <= mapSize.y) {
        return Vector2(x, y);
      }
    }
  }
}

class Player extends SpriteComponent
    with KeyboardHandler, CollisionCallbacks, HasGameRef<MyGame> {
  final double speed = 300;
  final Vector2 mapSize;
  Vector2 velocity = Vector2.zero();

  Player({required this.mapSize, super.position})
      : super(size: Vector2.all(100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
    position.clamp(Vector2.zero() + size / 2, mapSize - size / 2);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    velocity = Vector2.zero();
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) velocity.x = speed;
    else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) velocity.x = -speed;
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) velocity.y = -speed;
    else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) velocity.y = speed;
    return true;
  }
  }


class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  final Player target;
  final double speed = 100;
  Vector2 previousPosition = Vector2.zero();

  Enemy({required Vector2 position, required this.target})
      : super(position: position, size: Vector2.all(80), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('enemy.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    previousPosition.setFrom(position);

    final direction = (target.position - position);
    if (direction.length > 1) {
      position += direction.normalized() * speed * dt;
    }
  }

  @override
  void onCollision(Set<Vector2> _, PositionComponent other) {
    if (other is Enemy) {
      // Empurra para longe do outro inimigo
      final pushDirection = (position - other.position).normalized();
      position += pushDirection * 10; // Pequeno empurrão
    }
  }
}
