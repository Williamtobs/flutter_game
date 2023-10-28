import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  late TiledComponent level;

  @override
  Future<void> onLoad() async {
    //we made the level here
    level = await TiledComponent.load('Level-01.tmx', Vector2.all(16));
    //we add the level to the world
    add(level);

    return super.onLoad();
  }
}
