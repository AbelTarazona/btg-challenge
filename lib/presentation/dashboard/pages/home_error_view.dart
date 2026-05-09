import 'package:btgproject/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const HomeErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.riskHigh.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                FontAwesomeIcons.cloudBolt,
                size: 44,
                color: colors.riskHigh,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '¡Algo salió mal!',
              style: textStyles.heading2,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: textStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: colors.goldGradient,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: colors.accentGold.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.rotateRight,
                      color: colors.deepNavy,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Reintentar',
                      style: textStyles.body.copyWith(
                        color: colors.deepNavy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
