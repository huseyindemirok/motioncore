import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NeonContainer extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool animate;

  const NeonContainer({
    super.key,
    required this.child,
    this.glowColor = Colors.cyanAccent,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: glowColor,
          width: 2,
        ),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: child,
    );

    if (animate) {
      return container
          .animate()
          .fadeIn(duration: 300.ms, curve: Curves.easeOut)
          .slideY(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOut);
    }

    return container;
  }
}

