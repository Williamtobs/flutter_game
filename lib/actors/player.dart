import 'package:flame/components.dart';
import 'package:flutter_game/pixel_adventure.dart';

enum PlayerState {
  idle,
  run,
  // jump,
  // fall,
  // attack,
  // hurt,
  // dead,
}

//we use SpriteAnimationGroupComponent to animate the players
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  //we pass in our char
  final String char;
  Player({position, required this.char}) : super(position: position);

  //first state of the player is idle
  late final SpriteAnimation idleAnimation;

  late final SpriteAnimation runAnimation;

  final double stepTime = 0.05;

  @override
  Future<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    //we load frist the idle animation
    idleAnimation = _sprintAnimation('Idle', amount: 11);

    runAnimation = _sprintAnimation('Run', amount: 12);

    //List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.run: runAnimation,
    };

    //we set the current animation to idle
    current = PlayerState.idle;
  }

  _sprintAnimation(String state, {int amount = 8}) {
    return SpriteAnimation.fromFrameData(
      //load the image all the images you added to chache
      game.images.fromCache('Main Characters/$char/$state (32x32).png'),
      //we use SpriteAnimationData.sequenced to load the animation
      SpriteAnimationData.sequenced(
        amount: amount, //amount of frames gotten from image
        textureSize:
            Vector2.all(32), //size of each frame (gotten from image name)
        stepTime: stepTime, //time between each frame
      ),
    );
  }
}
