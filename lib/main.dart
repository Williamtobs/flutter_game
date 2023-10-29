import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game/pixel_adventure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Set full screen and landscape orientation
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  PixelAdventure game = PixelAdventure();
  //to disable app restart on every reload
  runApp(GameWidget(game: kDebugMode ? PixelAdventure() : game));
}
