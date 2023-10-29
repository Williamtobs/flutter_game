import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_game/actors/player.dart';
import 'package:flutter_game/levels/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  Player player = Player(char: 'Ninja Frog');
  //create joystick component to control the player
  late JoystickComponent joystick;

  late final CameraComponent cam;

  @override
  Future<void> onLoad() async {
    //load all images into cache
    await images.loadAllImages();

    final level = Level(
      levelName: 'Level-02',
      player: player,
    );

    cam = CameraComponent.withFixedResolution(
        world: level, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, level]);

    addJoyStick();

    return super.onLoad();
  }

  //creating joystick
  void addJoyStick() {}
}
