import 'package:flutter/material.dart';

import 'package:btgproject/core/theme/app_theme.dart';

/// Skeleton shimmer loading para la HomePage.
class HomeShimmer extends StatefulWidget {
  const HomeShimmer({super.key});

  @override
  State<HomeShimmer> createState() => _HomeShimmerState();
}

class _HomeShimmerState extends State<HomeShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerBox(
                height: 180,
                opacity: _animation.value,
                borderRadius: 20,
                color: colors.surfaceLight,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _ShimmerBox(width: 70, height: 36, opacity: _animation.value, borderRadius: 20, color: colors.surfaceLight),
                  const SizedBox(width: 8),
                  _ShimmerBox(width: 60, height: 36, opacity: _animation.value, borderRadius: 20, color: colors.surfaceLight),
                  const SizedBox(width: 8),
                  _ShimmerBox(width: 55, height: 36, opacity: _animation.value, borderRadius: 20, color: colors.surfaceLight),
                ],
              ),
              const SizedBox(height: 20),
              for (int i = 0; i < 3; i++) ...[
                _ShimmerBox(height: 130, opacity: _animation.value, borderRadius: 16, color: colors.surfaceLight),
                if (i < 2) const SizedBox(height: 12),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double opacity;
  final double borderRadius;
  final Color color;

  const _ShimmerBox({
    this.width,
    required this.height,
    required this.opacity,
    required this.borderRadius,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacity * 0.4),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
