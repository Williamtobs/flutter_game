import 'package:flame/components.dart';
import 'package:flutter/services.dart';
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

enum PlayerDirection {
  left,
  right,
  none,
}

//we use SpriteAnimationGroupComponent to animate the players
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  //we pass in our char
  final String char;
  Player({position, this.char = 'Ninja Frog'}) : super(position: position);

  //first state of the player is idle
  late final SpriteAnimation idleAnimation;

  late final SpriteAnimation runAnimation;

  final double stepTime = 0.05;

  //we need player direction, move speed and velocity to move the player
  PlayerDirection direction = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true; //we use this to flip the player

  @override
  Future<void> onLoad() async {
    _loadAllAnimations();
    return super.onLoad();
  }

  //we use update update our game state and update on every frame
  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  //we use onKeyEvent to get the key pressed
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    //we check if the key pressed is left arrow or A
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA);

    //we check if the key pressed is right arrow or D
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);

    //do nothing if both keys are pressed
    if (isLeftKeyPressed && isRightKeyPressed) {
      direction = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      direction = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      direction = PlayerDirection.right;
    } else {
      direction = PlayerDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);
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

  void _updatePlayerMovement(double dt) {
    //we will create direction axis, left is negative and right is positive
    double dirX = 0.0;
    //we will use switch statement to check the direction
    switch (direction) {
      case PlayerDirection.left:
        if (isFacingRight) {
          //we flip the player
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        //we set the current state to run
        current = PlayerState.run;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          //we flip the player
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        //we set the current state to run
        current = PlayerState.run;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        //we set the current state to idle
        current = PlayerState.idle;
        dirX = velocity.x * 0.92;
        break;
      default:
    }
    //we set the velocity to the direction
    velocity = Vector2(dirX, 0.0);
    //we update the position of the player
    position += velocity * dt;
  }
}
