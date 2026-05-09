import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/core/utils/currency_formatter.dart';
import 'package:btgproject/domain/entities/fund.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_bloc.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_event.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Bottom sheet premium para suscribirse a un fondo.
///
/// Muestra detalle del fondo, input de monto variable, selector
/// de método de notificación (Email/SMS), y validación de saldo.
class SubscribeBottomSheet extends StatefulWidget {
  final Fund fund;
  final double availableBalance;

  const SubscribeBottomSheet({
    super.key,
    required this.fund,
    required this.availableBalance,
  });

  static Future<void> show(
    BuildContext context, {
    required Fund fund,
    required double availableBalance,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<HomeBloc>(),
        child: SubscribeBottomSheet(
          fund: fund,
          availableBalance: availableBalance,
        ),
      ),
    );
  }

  @override
  State<SubscribeBottomSheet> createState() => _SubscribeBottomSheetState();
}

class _SubscribeBottomSheetState extends State<SubscribeBottomSheet> {
  String _notificationMethod = 'EMAIL';
  late TextEditingController _amountController;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.fund.minimumAmount.toInt().toString(),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _enteredAmount {
    final text = _amountController.text.replaceAll('.', '').replaceAll(',', '');
    return double.tryParse(text) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (prev, curr) =>
          prev.subscriptionStatus != curr.subscriptionStatus,
      listener: (context, state) {
        if (state.subscriptionStatus == SubscriptionStatus.success) {
          Navigator.of(context).pop();
          context.read<HomeBloc>().add(ResetSubscriptionStatus());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  FaIcon(FontAwesomeIcons.circleCheck,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Suscripción exitosa a ${widget.fund.name}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: colors.riskLow,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: colors.cardDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: colors.surfaceLight.withValues(alpha: 0.2),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Drag handle ──
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.surfaceLight.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Título ──
                Text('Suscribirse al fondo', style: textStyles.heading2),
                const SizedBox(height: 20),

                // ── Info del fondo ──
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colors.surfaceLight.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (widget.fund.category == 'FPV'
                                  ? colors.accentTeal
                                  : colors.accentGold)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: FaIcon(
                          widget.fund.category == 'FPV'
                              ? FontAwesomeIcons.clockRotateLeft
                              : FontAwesomeIcons.peopleGroup,
                          size: 20,
                          color: widget.fund.category == 'FPV'
                              ? colors.accentTeal
                              : colors.accentGold,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.fund.name,
                              style: textStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Mínimo: ${CurrencyFormatter.formatCOP(widget.fund.minimumAmount)}',
                              style: textStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Saldo disponible ──
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.accentTeal.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.wallet,
                          size: 16, color: colors.accentTeal),
                      const SizedBox(width: 10),
                      Text(
                        'Saldo disponible: ',
                        style: textStyles.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.formatCOP(widget.availableBalance),
                        style: textStyles.body.copyWith(
                          color: colors.accentTeal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Input de monto ──
                Text('Monto a invertir',
                    style: textStyles.label
                        .copyWith(letterSpacing: 1.2)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colors.surfaceLight.withValues(alpha: 0.4),
                    ),
                  ),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: textStyles.heading3.copyWith(
                      color: colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      prefixStyle: textStyles.heading3.copyWith(
                        color: colors.accentGold,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      hintText: 'Ingresa el monto',
                      hintStyle: textStyles.body.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                    onChanged: (_) {
                      if (_localError != null) {
                        setState(() => _localError = null);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // ── Selector de notificación ──
                Text('Método de notificación',
                    style: textStyles.label
                        .copyWith(letterSpacing: 1.2)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _NotificationOption(
                        icon: FontAwesomeIcons.envelope,
                        label: 'Email',
                        isActive: _notificationMethod == 'EMAIL',
                        colors: colors,
                        textStyles: textStyles,
                        onTap: () =>
                            setState(() => _notificationMethod = 'EMAIL'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _NotificationOption(
                        icon: FontAwesomeIcons.commentSms,
                        label: 'SMS',
                        isActive: _notificationMethod == 'SMS',
                        colors: colors,
                        textStyles: textStyles,
                        onTap: () =>
                            setState(() => _notificationMethod = 'SMS'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Error messages ──
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (prev, curr) =>
                      prev.subscriptionStatus != curr.subscriptionStatus ||
                      prev.subscriptionError != curr.subscriptionError,
                  builder: (context, state) {
                    final error = _localError ?? state.subscriptionError;
                    if (error == null ||
                        state.subscriptionStatus != SubscriptionStatus.error &&
                            _localError == null) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: colors.riskHigh.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colors.riskHigh.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          FaIcon(FontAwesomeIcons.triangleExclamation,
                              size: 16, color: colors.riskHigh),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              error,
                              style: textStyles.bodySmall.copyWith(
                                color: colors.riskHigh,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // ── Botón suscribirse ──
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (prev, curr) =>
                      prev.subscriptionStatus != curr.subscriptionStatus,
                  builder: (context, state) {
                    final isLoading =
                        state.subscriptionStatus == SubscriptionStatus.loading;
                    return GestureDetector(
                      onTap: isLoading ? null : () => _onSubscribe(context),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: isLoading ? null : colors.goldGradient,
                          color: isLoading
                              ? colors.surfaceLight.withValues(alpha: 0.3)
                              : null,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isLoading
                              ? []
                              : [
                                  BoxShadow(
                                    color: colors.accentGold
                                        .withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: isLoading
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation(
                                        colors.textMuted),
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.arrowRight,
                                      color: colors.deepNavy,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Suscribirme',
                                      style: textStyles.body.copyWith(
                                        color: colors.deepNavy,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubscribe(BuildContext context) {
    final amount = _enteredAmount;

    if (amount <= 0) {
      setState(() => _localError = 'Ingresa un monto válido.');
      return;
    }
    if (amount < widget.fund.minimumAmount) {
      setState(() => _localError =
          'El monto mínimo es ${CurrencyFormatter.formatCOP(widget.fund.minimumAmount)}');
      return;
    }
    if (amount > widget.availableBalance) {
      setState(() => _localError =
          'No tiene saldo disponible para vincularse al fondo ${widget.fund.name}');
      return;
    }

    setState(() => _localError = null);
    context.read<HomeBloc>().add(SubscribeToFund(
          fund: widget.fund,
          amount: amount,
          notificationMethod: _notificationMethod,
        ));
  }
}

class _NotificationOption extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final bool isActive;
  final dynamic colors;
  final dynamic textStyles;
  final VoidCallback onTap;

  const _NotificationOption({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.colors,
    required this.textStyles,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive
              ? colors.accentGold.withValues(alpha: 0.12)
              : colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive
                ? colors.accentGold
                : colors.surfaceLight.withValues(alpha: 0.3),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 16,
              color: isActive ? colors.accentGold : colors.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: textStyles.body.copyWith(
                color: isActive ? colors.accentGold : colors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
