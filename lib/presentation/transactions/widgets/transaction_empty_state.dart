import 'package:btgproject/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionEmptyState extends StatelessWidget {
  const TransactionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: colors.cardDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.surfaceLight.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          FaIcon(FontAwesomeIcons.clockRotateLeft,
              size: 40, color: colors.textMuted),
          const SizedBox(height: 16),
          Text(
            'Sin transacciones',
            style: textStyles.heading3.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No hay transacciones registradas aún.\nSuscríbete a un fondo para comenzar.',
            style: textStyles.subtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
