import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/components/collision_block.dart';
import 'package:flutter_game/components/utils.dart';
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
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  //we pass in our char
  final String char;
  Player({position, this.char = 'Ninja Frog'}) : super(position: position);

  //first state of the player is idle
  late final SpriteAnimation idleAnimation;

  late final SpriteAnimation runAnimation;

  final double stepTime = 0.05;

  //we need player direction, move speed and velocity to move the player
  // PlayerDirection direction = PlayerDirection.none; We get rid of it now

  final double _gravity = 9.8;
  final double _jumpForce = 250;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  // bool isFacingRight = true; //we use this to flip the player //we dont need it again
  List<CollisionBlock> collisionBlocks = [];

  @override
  Future<void> onLoad() async {
    _loadAllAnimations();
    debugMode = true;
    return super.onLoad();
  }

  //we use update update our game state and update on every frame
  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    _updatePlayerState();
    _checkHorizontalCollisions();
    //check horizontal collisions before applying gravity
    _applyGravity(dt);
    _checkVerticalCollisions();
    super.update(dt);
  }

  //we use onKeyEvent to get the key pressed
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    //we check if the key pressed is left arrow or A
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA);

    //we check if the key pressed is right arrow or D
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    //do nothing if both keys are pressed
    // if (isLeftKeyPressed && isRightKeyPressed) {
    //   direction = PlayerDirection.none;
    // } else if (isLeftKeyPressed) {
    //   direction = PlayerDirection.left;
    // } else if (isRightKeyPressed) {
    //   direction = PlayerDirection.right;
    // } else {
    //   direction = PlayerDirection.none;
    // }
    //we remove the if(s) statement above
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
    // we get rid of all the above code

    if (hasJumped && isOnGround) {
      _playerJump(dt);
    }

    if (velocity.y > _gravity) {
      isOnGround = false;
    }
    //we set the velocity to the direction
    velocity.x = horizontalMovement * moveSpeed;
    //we update the position of the player
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    if (isOnGround) {
      velocity.y = -_jumpForce;
      position.y += velocity.y * dt;
      isOnGround = false;
      hasJumped = false;
    }
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    //Check if the player is moving set the state to run
    if (velocity.x > 0 || velocity.x < 0) {
      playerState = PlayerState.run;
    }

    current = playerState;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + width;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - width;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - width;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height + height;
          }
        }
      }
    }
  }
}
