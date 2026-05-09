import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/core/utils/currency_formatter.dart';
import 'package:btgproject/domain/entities/investment.dart';
import 'package:btgproject/presentation/funds/bloc/funds_bloc.dart';
import 'package:btgproject/presentation/funds/bloc/funds_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Diálogo de confirmación antes de cancelar una inversión.
class CancelConfirmationDialog extends StatelessWidget {
  final Investment investment;

  const CancelConfirmationDialog({super.key, required this.investment});

  static Future<void> show(
    BuildContext context, {
    required Investment investment,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => BlocProvider.value(
        value: context.read<FundsBloc>(),
        child: CancelConfirmationDialog(investment: investment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Dialog(
      backgroundColor: colors.cardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.riskHigh.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: FaIcon(FontAwesomeIcons.triangleExclamation,
                  size: 32, color: colors.riskHigh),
            ),
            const SizedBox(height: 20),
            Text('¿Cancelar inversión?', style: textStyles.heading2),
            const SizedBox(height: 12),
            Text(
              'Se devolverán ${CurrencyFormatter.formatCOP(investment.amount)} a tu saldo disponible.',
              style: textStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                investment.fundName,
                style: textStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: colors.surfaceLight.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'No, mantener',
                          style: textStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.read<FundsBloc>().add(CancelInvestment(
                            investmentId: investment.id,
                            amount: investment.amount,
                          ));
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: colors.riskHigh,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          'Sí, cancelar',
                          style: textStyles.body.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
