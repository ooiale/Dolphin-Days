import 'package:flutter/material.dart';

class AquariumStyles {
  // Spawn logic
  static const int maxSwimmers       = 12;
  static const Duration spawnPeriod  = Duration(seconds: 2);
  static const int minNewSwimmers    = 1;
  static const int maxNewSwimmers    = 3;

  // Size ranges
  static const Size minSize = Size(80, 60);
  static const Size maxSize = Size(140, 100);

  // Duration ranges
  static const Duration turtleMinDuration = Duration(seconds: 8);
  static const Duration turtleMaxDuration = Duration(seconds: 15);
  static const Duration fishMinDuration   = Duration(seconds: 6);
  static const Duration fishMaxDuration   = Duration(seconds: 13);

  // Off-screen offsets
  static const Offset offscreenStartLeft  = Offset(-0.2, 0);
  static const Offset offscreenEndRight   = Offset(1.2, 0);
  static const Offset offscreenStartRight = Offset(1.2, 0);
  static const Offset offscreenEndLeft    = Offset(-0.2, 0);

  // Asset paths
  static const String turtleAsset      = 'assets/lotties/turtle.json';
  static const String fishAsset        = 'assets/lotties/fish.json';
  static const String backgroundAsset  = 'assets/lotties/underwater.json';
}
