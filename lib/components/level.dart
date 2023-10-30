import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_game/components/player.dart';

class Level extends World {
  final Player player;
  final String levelName;

  Level({required this.levelName, required this.player});

  late TiledComponent level;

  @override
  Future<void> onLoad() async {
    //we made the level here
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));
    //we add the level to the world
    add(level);

    //we get the spawn points layer first by creating on Tiled and calling class name here
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    for (final spawnPoint in spawnPointsLayer!.objects) {
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

    return super.onLoad();
  }
}
