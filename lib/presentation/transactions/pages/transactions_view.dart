import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/presentation/dashboard/widgets/home_shimmer.dart';
import 'package:btgproject/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:btgproject/presentation/transactions/bloc/transactions_event.dart';
import 'package:btgproject/presentation/transactions/bloc/transactions_state.dart';
import 'package:btgproject/presentation/transactions/widgets/transaction_card.dart';
import 'package:btgproject/presentation/transactions/widgets/transaction_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.deepNavy,
      body: Container(
        decoration: BoxDecoration(
          gradient: colors.backgroundGradient,
        ),
        child: BlocBuilder<TransactionsBloc, TransactionsState>(
          builder: (context, state) {
            return switch (state.status) {
              TransactionsStatus.initial ||
              TransactionsStatus.loading =>
                const HomeShimmer(),
              TransactionsStatus.error => _ErrorView(
                  message: state.errorMessage ?? 'Error desconocido',
                  onRetry: () => context
                      .read<TransactionsBloc>()
                      .add(TransactionsLoadRequested()),
                ),
              TransactionsStatus.success => _SuccessView(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final TransactionsState state;

  const _SuccessView({required this.state});

  static const _filters = ['Todas', 'Suscripciones', 'Cancelaciones'];

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
              child: Text('Historial', style: textStyles.heading1),
            ),
          ),

          // ── Tabs de filtro ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: _filters.map((filter) {
                  final isActive = filter == state.selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => context
                          .read<TransactionsBloc>()
                          .add(TransactionsFilterChanged(filter)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color:
                              isActive ? colors.accentGold : colors.cardDark,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isActive
                                ? colors.accentGold
                                : colors.surfaceLight
                                    .withValues(alpha: 0.3),
                            width: 1,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: colors.accentGold
                                        .withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          filter,
                          style: textStyles.bodySmall.copyWith(
                            color: isActive
                                ? colors.deepNavy
                                : colors.textSecondary,
                            fontWeight:
                                isActive ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Contador ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Text('Transacciones', style: textStyles.heading3),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.accentGold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${state.filteredTransactions.length}',
                      style: textStyles.bodySmall.copyWith(
                        color: colors.accentGold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Lista ──
          if (state.filteredTransactions.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: TransactionEmptyState(),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tx = state.filteredTransactions[index];
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      index == 0 ? 16 : 6,
                      20,
                      index == state.filteredTransactions.length - 1
                          ? 24
                          : 6,
                    ),
                    child: TransactionCard(transaction: tx),
                  );
                },
                childCount: state.filteredTransactions.length,
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
