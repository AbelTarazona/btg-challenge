import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:btgproject/core/theme/app_colors.dart';
import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/core/utils/currency_formatter.dart';
import 'package:btgproject/domain/entities/fund.dart';

class FundCard extends StatelessWidget {
  final Fund fund;
  final VoidCallback? onTap;

  const FundCard({super.key, required this.fund, this.onTap});

  Color _riskColor(AppColors colors, String level) {
    switch (level) {
      case 'Bajo':
        return colors.riskLow;
      case 'Medio':
        return colors.riskMedium;
      case 'Alto':
        return colors.riskHigh;
      default:
        return colors.textMuted;
    }
  }

  FaIconData _riskIcon(String level) {
    switch (level) {
      case 'Bajo':
        return FontAwesomeIcons.shieldHalved;
      case 'Medio':
        return FontAwesomeIcons.gaugeHigh;
      case 'Alto':
        return FontAwesomeIcons.fire;
      default:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  FaIconData _categoryIcon(String category) {
    return category == 'FPV'
        ? FontAwesomeIcons.clockRotateLeft
        : FontAwesomeIcons.peopleGroup;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final riskColor = _riskColor(colors, fund.riskLevel);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colors.surfaceLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: Icono categoría + nombre + badge riesgo ──
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (fund.category == 'FPV'
                            ? colors.accentTeal
                            : colors.accentGold)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FaIcon(
                    _categoryIcon(fund.category),
                    size: 18,
                    color: fund.category == 'FPV'
                        ? colors.accentTeal
                        : colors.accentGold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fund.name,
                        style: textStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        fund.category == 'FPV'
                            ? 'Fondo de Pensiones Voluntarias'
                            : 'Fondo de Inversión Colectiva',
                        style: textStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _RiskBadge(
                  level: fund.riskLevel,
                  color: riskColor,
                  icon: _riskIcon(fund.riskLevel),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Descripción ──
            Text(
              fund.description,
              style: textStyles.bodySmall.copyWith(
                color: colors.textSecondary.withValues(alpha: 0.8),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 14),

            // ── Footer: Monto mínimo + flecha ──
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.moneyBill,
                  size: 14,
                  color: colors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  'Monto mínimo: ',
                  style: textStyles.bodySmall.copyWith(
                    color: colors.textMuted,
                  ),
                ),
                Text(
                  CurrencyFormatter.formatCOP(fund.minimumAmount),
                  style: textStyles.bodySmall.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 14,
                  color: colors.textMuted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskBadge extends StatelessWidget {
  final String level;
  final Color color;
  final FaIconData icon;

  const _RiskBadge({
    required this.level,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            level,
            style: textStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
