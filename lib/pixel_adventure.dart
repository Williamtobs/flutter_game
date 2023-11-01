import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_game/components/player.dart';
import 'package:flutter_game/components/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  Player player = Player(char: 'Pink Man');
  //create joystick component to control the player
  late JoystickComponent joystick;

  // bool showJoystick = false;

  late final CameraComponent cam;

  @override
  Future<void> onLoad() async {
    //load all images into cache
    await images.loadAllImages();

    final level = Level(
      levelName: 'Level-01',
      player: player,
    );

    cam = CameraComponent.withFixedResolution(
        world: level, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, level]);

    addJoyStick();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // updateJoystick();
    super.update(dt);
  }

  //creating joystick
  void addJoyStick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/knob.png')),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache('HUD/Joystick.png')),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    //we add the joystick to the game
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
    }
  }
}
