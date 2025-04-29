import 'package:flutter/material.dart';

class WaterAppBarTitle extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  const WaterAppBarTitle(this.text, this.textStyle,{super.key});

  @override
  WaterAppBarTitleState createState() => WaterAppBarTitleState();
}

class WaterAppBarTitleState extends State<WaterAppBarTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    // Animate from 0→1 continuously
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // start the loop immediately :contentReference[oaicite:8]{index=8}
  }

  @override
  void dispose() {
    controller
        .dispose(); // Prevent memory leaks :contentReference[oaicite:9]{index=9}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ShaderMask(
          // Shift gradient across the text bounds
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1 + 2 * controller.value, -0.5),
              end: Alignment(1 + 2 * controller.value, 0.5),
              colors: [
                Colors.lightBlue.shade100,
                Colors.blue.shade800,
                Colors.cyan.shade200,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          blendMode:
              BlendMode
                  .srcATop, // Mask only the text :contentReference[oaicite:10]{index=10}
          child: Text(
            widget.text,
            style: widget.textStyle,
          ),
        );
      },
    );
  }
}
