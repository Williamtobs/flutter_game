import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_game/components/collision_block.dart';
import 'package:flutter_game/components/player.dart';

class Level extends World {
  final Player player;
  final String levelName;

  Level({required this.levelName, required this.player});

  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  Future<void> onLoad() async {
    //we made the level here
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    //we add the level to the world
    add(level);

    //we get the spawn points layer first by creating on Tiled and calling class name here
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointsLayer == null) {
      throw Exception('Spawnpoints layer not found');
    } else {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            //we add the player to the level
            // final player = Player(
            //     char: 'Ninja Frog',
            //     position: Vector2(spawnPoint.x, spawnPoint.y));
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
        }
      }
    }

    //collison layer after adding collision in tiles
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collision');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            //we add the platform to the level 
            add(platform);
            break;
          default:
          final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            //we add the platform to the level 
            add(block);
        }
      }
    }

    //we let it know that te collision actually exists
    player.collisionBlocks = collisionBlocks;
    return super.onLoad();
  }
}
