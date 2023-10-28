import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_game/levels/level.dart';

class PixelAdventure extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  final level = Level(
    levelName: 'Level-02',
  );
  late final CameraComponent cam;

  @override
  Future<void> onLoad() async {
    //load all images into cache
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(
        world: level, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([
      cam,
      level,
    ]);
    return super.onLoad();
  }
}
