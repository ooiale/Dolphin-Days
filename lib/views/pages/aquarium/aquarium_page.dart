import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AquariumPage extends StatefulWidget {
  const AquariumPage({super.key});

  @override
  State<AquariumPage> createState() => _AquariumPageState();
}

class _AquariumPageState extends State<AquariumPage> {
  final List<Widget> _swimmers = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _spawnSwimmers(); // Spawn immediately on first load
    //_printSwimmerDebugInfo(); //debug
    _spawnSwimmersPeriodically(); // Then keep spawning every 10.5s
  }

  // ignore: unused_element
  void _printSwimmerDebugInfo() {
    final types =
        _swimmers.map((w) {
          if (w is SwimAnimation) {
            if (w.asset.contains('turtle')) return 'turtle';
            if (w.asset.contains('fish')) return 'fish';
          }
          return 'unknown';
        }).toList();

    debugPrint('🐠 Swimmer count: ${_swimmers.length}');
    debugPrint('🐟 Swimmers: $types');
  }

  void _spawnSwimmersPeriodically() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(_spawnSwimmers);
    });
  }

  void _spawnSwimmers() {
    if (_swimmers.length >= 12) return;
    final newCount = _rng.nextInt(3) + 1; // 1 to 3 new swimmers
    for (int i = 0; i < newCount; i++) {
      final isTurtle = _rng.nextBool();
      final verticalPos = _rng.nextDouble();
      final key = UniqueKey();

      if (isTurtle) {
        _swimmers.add(
          SwimAnimation(
            key: key,
            asset: 'assets/lotties/turtle.json',
            size: Size(
              80 + _rng.nextDouble() * 60,
              60 + _rng.nextDouble() * 40,
            ),
            duration: Duration(seconds: _rng.nextInt(8) + 8), // 8-15s
            startOffset: Offset(1.2, verticalPos),
            endOffset: Offset(-0.2, verticalPos),
            onComplete: () {
              if (mounted) {
                setState(() {
                  _swimmers.removeWhere((w) => w.key == key);
                  //_printSwimmerDebugInfo(); //debug
                });
              }
            },
          ),
        );
      } else {
        _swimmers.add(
          SwimAnimation(
            key: key,
            asset: 'assets/lotties/fish.json',
            size: Size(
              80 + _rng.nextDouble() * 80,
              60 + _rng.nextDouble() * 40,
            ),
            duration: Duration(seconds: _rng.nextInt(8) + 6), // 6-13s
            startOffset: Offset(-0.2, verticalPos),
            endOffset: Offset(1.2, verticalPos),
            onComplete: () {
              if (mounted) {
                setState(() {
                  _swimmers.removeWhere((w) => w.key == key);
                });
              }
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen underwater background
          Lottie.asset(
            'assets/lotties/underwater.json',
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
            repeat: true,
          ),
          // Constantly updated list of swimmers
          ..._swimmers,
        ],
      ),
    );
  }
}

/// A widget that animates a Lottie JSON sprite across the screen.
class SwimAnimation extends StatefulWidget {
  final String asset;
  final Size size;
  final Duration duration;
  final Offset startOffset;
  final Offset endOffset;
  final VoidCallback onComplete;

  const SwimAnimation({
    super.key,
    required this.asset,
    required this.size,
    required this.duration,
    required this.startOffset,
    required this.endOffset,
    required this.onComplete,
  });

  @override
  State<SwimAnimation> createState() => _SwimAnimationState();
}

class _SwimAnimationState extends State<SwimAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<Offset>(
        begin: widget.startOffset,
        end: widget.endOffset,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete.call(); // Notify parent to remove this widget
        }
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final screen = MediaQuery.of(context).size;
        return Positioned(
          left: _animation.value.dx * screen.width,
          top: _animation.value.dy * screen.height,
          child: SizedBox(
            width: widget.size.width,
            height: widget.size.height,
            child: Lottie.asset(widget.asset, repeat: true),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
