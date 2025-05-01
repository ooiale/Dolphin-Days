import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'aquarium_styles.dart';
import 'aquarium_widgets.dart';

class AquariumPage extends StatefulWidget {
  const AquariumPage({super.key});

  @override
  State<AquariumPage> createState() => _AquariumPageState();
}

class _AquariumPageState extends State<AquariumPage> {
  final List<Widget> swimmers = [];
  final Random rng = Random();

  @override
  void initState() {
    super.initState();

    // Spawn immediately on first load
    SwimmerHelper.spawnSwimmers(swimmers, rng, (fn) => setState(fn), mounted);

    // Then keep spawning every 2s
    Timer.periodic(AquariumStyles.spawnPeriod, (timer) {
      if (!mounted) return;
      setState(() {
        SwimmerHelper.spawnSwimmers(swimmers, rng, (fn) => fn(), mounted);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [const UnderwaterBackground(), ...swimmers]),
    );
  }
}
