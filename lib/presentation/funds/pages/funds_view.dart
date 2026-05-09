import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/core/utils/currency_formatter.dart';
import 'package:btgproject/presentation/dashboard/widgets/home_shimmer.dart';
import 'package:btgproject/presentation/funds/bloc/funds_bloc.dart';
import 'package:btgproject/presentation/funds/bloc/funds_event.dart';
import 'package:btgproject/presentation/funds/bloc/funds_state.dart';
import 'package:btgproject/presentation/funds/widgets/investment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FundsView extends StatefulWidget {
  const FundsView({super.key});

  @override
  State<FundsView> createState() => _FundsViewState();
}

class _FundsViewState extends State<FundsView> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.deepNavy,
      body: Container(
        decoration: BoxDecoration(
          gradient: colors.backgroundGradient,
        ),
        child: BlocConsumer<FundsBloc, FundsState>(
          listenWhen: (prev, curr) =>
              prev.cancellationStatus != curr.cancellationStatus,
          listener: (context, state) {
            if (state.cancellationStatus == CancellationStatus.success) {
              context.read<FundsBloc>().add(ResetCancellationStatus());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.circleCheck,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Inversión cancelada exitosamente',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: colors.accentTeal,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(16),
                ),
              );
            }
          },
          builder: (context, state) {
            return switch (state.status) {
              FundsStatus.initial || FundsStatus.loading =>
                const HomeShimmer(),
              FundsStatus.error => _ErrorView(
                  message: state.errorMessage ?? 'Error desconocido',
                  onRetry: () =>
                      context.read<FundsBloc>().add(FundsLoadRequested()),
                ),
              FundsStatus.success => _SuccessView(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final FundsState state;

  const _SuccessView({required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text('Mis Fondos', style: textStyles.heading1),
            ),
          ),

          // ── Balance ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: colors.balanceGradient,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colors.accentGold.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colors.accentGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FaIcon(FontAwesomeIcons.wallet,
                          color: colors.accentGold, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SALDO DISPONIBLE',
                          style: textStyles.label.copyWith(
                            color: colors.accentGold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.formatCOP(
                              state.user?.availableBalance ?? 0),
                          style: textStyles.heading2.copyWith(
                            color: const Color(0xFFF0F4F8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Contador ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                children: [
                  Text('Inversiones activas', style: textStyles.heading3),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.accentTeal.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${state.investments.length}',
                      style: textStyles.bodySmall.copyWith(
                        color: colors.accentTeal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Lista de inversiones ──
          if (state.investments.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                  decoration: BoxDecoration(
                    color: colors.cardDark.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colors.surfaceLight.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      FaIcon(FontAwesomeIcons.seedling,
                          size: 40, color: colors.textMuted),
                      const SizedBox(height: 16),
                      Text(
                        'No tienes inversiones activas',
                        style: textStyles.heading3.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Suscríbete a un fondo desde la pantalla de inicio',
                        style: textStyles.subtitle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final investment = state.investments[index];
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      index == 0 ? 16 : 6,
                      20,
                      index == state.investments.length - 1 ? 24 : 6,
                    ),
                    child: InvestmentCard(
                      investment: investment,
                      isCancelling:
                          state.cancellationStatus ==
                                  CancellationStatus.loading &&
                              state.cancellingInvestmentId == investment.id,
                    ),
                  );
                },
                childCount: state.investments.length,
              ),
            ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

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
            FaIcon(FontAwesomeIcons.cloudBolt,
                size: 44, color: colors.riskHigh),
            const SizedBox(height: 24),
            Text('¡Algo salió mal!', style: textStyles.heading2),
            const SizedBox(height: 12),
            Text(message,
                style: textStyles.subtitle, textAlign: TextAlign.center),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  gradient: colors.goldGradient,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Text(
                  'Reintentar',
                  style: textStyles.body.copyWith(
                    color: colors.deepNavy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
