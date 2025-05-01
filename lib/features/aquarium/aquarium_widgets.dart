// lib/features/aquarium/aquarium_widgets.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'aquarium_styles.dart';
import 'swim_animation.dart';

/// Full-screen underwater background.
class UnderwaterBackground extends StatelessWidget {
  const UnderwaterBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      AquariumStyles.backgroundAsset,
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,
      repeat: true,
    );
  }
}

/// Helper that moves the original spawn logic out of the page.
class SwimmerHelper {
  /// Spawns new swimmers into [swimmers] using the same logic as in AquariumPage.
  static void spawnSwimmers(
    List<Widget> swimmers,
    Random rng,
    void Function(VoidCallback fn) setState,
    bool mounted,
  ) {
    // limit total swimmers
    if (swimmers.length >= AquariumStyles.maxSwimmers) return;

    // 1 to 3 new swimmers
    final newCount = rng.nextInt(3) + 1;
    for (int i = 0; i < newCount; i++) {
      final isTurtle = rng.nextBool();
      final verticalPos = rng.nextDouble();
      final key = UniqueKey();

      final asset =
          isTurtle ? AquariumStyles.turtleAsset : AquariumStyles.fishAsset;
      final width =
          isTurtle ? 80 + rng.nextDouble() * 60 : 80 + rng.nextDouble() * 80;
      final height = 60 + rng.nextDouble() * 40;
      final duration = Duration(
        seconds: rng.nextInt(isTurtle ? 8 : 8) + (isTurtle ? 8 : 6),
      );
      final start =
          isTurtle ? Offset(1.2, verticalPos) : Offset(-0.2, verticalPos);
      final end =
          isTurtle ? Offset(-0.2, verticalPos) : Offset(1.2, verticalPos);

      swimmers.add(
        SwimAnimation(
          key: key,
          asset: asset,
          size: Size(width, height),
          duration: duration,
          startOffset: start,
          endOffset: end,
          onComplete: () {
            if (mounted) {
              setState(() {
                swimmers.removeWhere((w) => w.key == key);
              });
            }
          },
        ),
      );
    }
  }
}
