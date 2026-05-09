import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/core/utils/currency_formatter.dart';
import 'package:btgproject/domain/entities/transaction.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  bool get _isSubscription => transaction.type == 'SUBSCRIPTION';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    final badgeColor = _isSubscription ? colors.riskLow : colors.riskHigh;
    final badgeLabel = _isSubscription ? 'Suscripción' : 'Cancelación';
    final badgeIcon = _isSubscription
        ? FontAwesomeIcons.arrowDown
        : FontAwesomeIcons.arrowUp;

    final d = transaction.date;
    final dateFormatted =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.surfaceLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Badge + fecha ──
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(badgeIcon, size: 10, color: badgeColor),
                    const SizedBox(width: 5),
                    Text(
                      badgeLabel,
                      style: textStyles.label.copyWith(
                        color: badgeColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(dateFormatted, style: textStyles.bodySmall),
            ],
          ),

          const SizedBox(height: 12),

          // ── Nombre del fondo ──
          Text(
            transaction.fundName,
            style: textStyles.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          // ── Footer: Monto + método de notificación ──
          Row(
            children: [
              Text(
                _isSubscription ? '- ' : '+ ',
                style: textStyles.body.copyWith(
                  color: badgeColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                CurrencyFormatter.formatCOP(transaction.amount),
                style: textStyles.body.copyWith(
                  color: badgeColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      transaction.notificationMethod == 'EMAIL'
                          ? FontAwesomeIcons.envelope
                          : FontAwesomeIcons.commentSms,
                      size: 10,
                      color: colors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      transaction.notificationMethod,
                      style: textStyles.label.copyWith(
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
