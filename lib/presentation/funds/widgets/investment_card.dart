import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/core/utils/currency_formatter.dart';
import 'package:btgproject/domain/entities/investment.dart';
import 'package:btgproject/presentation/funds/widgets/cancel_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class InvestmentCard extends StatelessWidget {
  final Investment investment;
  final bool isCancelling;

  const InvestmentCard({
    super.key,
    required this.investment,
    this.isCancelling = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    final d = investment.subscriptionDate;
    final dateFormatted =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.accentTeal.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.accentTeal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FaIcon(FontAwesomeIcons.chartLine,
                    size: 18, color: colors.accentTeal),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      investment.fundName,
                      style: textStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(dateFormatted, style: textStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Info row ──
          Row(
            children: [
              _InfoChip(
                icon: FontAwesomeIcons.moneyBill,
                label: CurrencyFormatter.formatCOP(investment.amount),
                color: colors.accentGold,
                colors: colors,
                textStyles: textStyles,
              ),
              const SizedBox(width: 10),
              _InfoChip(
                icon: investment.notificationMethod == 'EMAIL'
                    ? FontAwesomeIcons.envelope
                    : FontAwesomeIcons.commentSms,
                label: investment.notificationMethod,
                color: colors.accentTeal,
                colors: colors,
                textStyles: textStyles,
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Botón cancelar ──
          GestureDetector(
            onTap: isCancelling
                ? null
                : () => CancelConfirmationDialog.show(
                      context,
                      investment: investment,
                    ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: colors.riskHigh.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors.riskHigh.withValues(alpha: 0.25),
                ),
              ),
              child: Center(
                child: isCancelling
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation(colors.riskHigh),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.xmark,
                              size: 14, color: colors.riskHigh),
                          const SizedBox(width: 8),
                          Text(
                            'Cancelar inversión',
                            style: textStyles.body.copyWith(
                              color: colors.riskHigh,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final Color color;
  final dynamic colors;
  final dynamic textStyles;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.colors,
    required this.textStyles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            label,
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
