import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
