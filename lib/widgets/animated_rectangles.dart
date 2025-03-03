import 'package:flutter/material.dart';
import 'dart:ui';

class AnimatedRectangles extends StatefulWidget {
  @override
  _AnimatedRectanglesState createState() => _AnimatedRectanglesState();
}

class _AnimatedRectanglesState extends State<AnimatedRectangles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _orangeAnimations;
  late List<Animation<double>> _purpleAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    // Orange Rectangles: Start from the right and move left
    _orangeAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 300, end: 0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.15, // Stagger effect
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    // Purple Rectangles: Start from the left and move right
    _purpleAnimations = List.generate(3, (index) {
      return Tween<double>(begin: -300, end: 0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.15,
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    // Fade-in effect
    _fadeAnimations = List.generate(6, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.1 * index,
            0.8,
            curve: Curves.easeIn,
          ),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: RectanglesPainter(
            _orangeAnimations.map((a) => a.value).toList(),
            _purpleAnimations.map((a) => a.value).toList(),
            _fadeAnimations.map((a) => a.value).toList(),
          ),
          size: Size(double.infinity, 400),
        );
      },
    );
  }
}

class RectanglesPainter extends CustomPainter {
  final List<double> orangePositions;
  final List<double> purplePositions;
  final List<double> opacities;

  RectanglesPainter(this.orangePositions, this.purplePositions, this.opacities);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Color(0xFFF5B400).withOpacity(0.9); // Yellow
    final paint2 = Paint()
      ..color = Color(0xFFCB6BE5).withOpacity(0.9); // Purple

    double rectWidth = size.width * 0.6; // ✅ Original large size
    double rectHeight = 50;
    double spacing = 90;

    // Draw Orange Rectangles (Right to Left)
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width - rectWidth - orangePositions[i], // ✅ Start from right
            i * spacing + 80, // Adjust vertical spacing
            rectWidth,
            rectHeight,
          ),
          Radius.circular(15),
        ),
        paint1..color = paint1.color.withOpacity(opacities[i]),
      );
    }

    // Draw Purple Rectangles (Left to Right)
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            purplePositions[i], // ✅ Start from left
            (i * spacing + 130), // ✅ Moved down to stop overlap
            rectWidth,
            rectHeight,
          ),
          Radius.circular(15),
        ),
        paint2..color = paint2.color.withOpacity(opacities[i + 3]),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
