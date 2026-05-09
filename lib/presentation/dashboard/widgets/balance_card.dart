import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/core/utils/currency_formatter.dart';
import 'package:btgproject/domain/entities/user.dart';

class BalanceCard extends StatelessWidget {
  final User user;

  const BalanceCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: colors.balanceGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.accentGold.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.deepNavy.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FaIcon(
                  FontAwesomeIcons.wallet,
                  color: colors.accentGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'SALDO DISPONIBLE',
                style: textStyles.label.copyWith(
                  color: colors.accentGold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            CurrencyFormatter.formatCOP(user.availableBalance),
            style: textStyles.balance.copyWith(
              color: const Color(0xFFF0F4F8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.currency,
            style: textStyles.balanceCurrency,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.accentTeal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.arrowTrendUp,
                  color: colors.accentTeal,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'Disponible para inversión',
                  style: textStyles.bodySmall.copyWith(
                    color: colors.accentTeal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
