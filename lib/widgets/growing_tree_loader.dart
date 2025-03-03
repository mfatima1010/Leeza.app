import 'dart:math';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class GrowingTreeLoader extends StatefulWidget {
  final double size;
  final Duration duration;

  const GrowingTreeLoader({
    Key? key,
    this.size = 100,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  State<GrowingTreeLoader> createState() => _GrowingTreeLoaderState();
}

class _GrowingTreeLoaderState extends State<GrowingTreeLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
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
          size: Size(widget.size, widget.size),
          painter: TreePainter(
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class TreePainter extends CustomPainter {
  final double progress;
  final Random random = Random(42); // Fixed seed for consistent randomness

  // Gradient colors from your app theme
  final gradient = const LinearGradient(
    colors: [
      Color(0xFFE5A0FF), // Light purple
      Color(0xFFFFD27A), // Light yellow
    ],
  );

  TreePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Start from bottom center
    final startPoint = Offset(size.width / 2, size.height);

    // Draw main trunk
    drawBranch(
      canvas,
      paint,
      startPoint,
      size.height * 0.3, // Length of main trunk
      -math.pi / 2, // Straight up
      progress,
      size,
      1.0, // Initial thickness
    );
  }

  void drawBranch(
    Canvas canvas,
    Paint paint,
    Offset start,
    double length,
    double angle,
    double progress,
    Size size,
    double thickness,
  ) {
    if (length < 5 || progress <= 0) return;

    // Calculate end point
    final end = Offset(
      start.dx + math.cos(angle) * length * progress,
      start.dy + math.sin(angle) * length * progress,
    );

    // Create gradient for this branch
    final shader = gradient.createShader(Rect.fromPoints(start, end));
    paint.shader = shader;
    paint.strokeWidth = thickness;

    // Draw the branch
    canvas.drawLine(start, end, paint);

    // Only continue branching if we have enough progress
    if (progress > 0.5) {
      // Left branch
      drawBranch(
        canvas,
        paint,
        end,
        length * 0.7,
        angle - math.pi / 4 + (random.nextDouble() - 0.5) * 0.2,
        (progress - 0.5) * 2,
        size,
        thickness * 0.7,
      );

      // Right branch
      drawBranch(
        canvas,
        paint,
        end,
        length * 0.7,
        angle + math.pi / 4 + (random.nextDouble() - 0.5) * 0.2,
        (progress - 0.5) * 2,
        size,
        thickness * 0.7,
      );

      // Sometimes add a middle branch
      if (random.nextBool() && length > 15) {
        drawBranch(
          canvas,
          paint,
          end,
          length * 0.6,
          angle + (random.nextDouble() - 0.5) * 0.2,
          (progress - 0.5) * 2,
          size,
          thickness * 0.7,
        );
      }
    }
  }

  @override
  bool shouldRepaint(TreePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
