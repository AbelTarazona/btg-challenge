import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_state.dart';
import 'package:btgproject/presentation/dashboard/widgets/balance_card.dart';
import 'package:btgproject/presentation/dashboard/widgets/category_tabs.dart';
import 'package:btgproject/presentation/dashboard/widgets/fund_list.dart';
import 'package:btgproject/presentation/dashboard/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeSuccessView extends StatelessWidget {
  final HomeState state;

  const HomeSuccessView({super.key, required this.state});

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
              child: Header(userName: state.user?.name ?? ''),
            ),
          ),

          // ── Balance Card ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: BalanceCard(user: state.user!),
            ),
          ),

          // ── Inversiones activas (resumen compacto) ──
          if (state.investments.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.accentTeal.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colors.accentTeal.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.chartLine,
                          size: 16, color: colors.accentTeal),
                      const SizedBox(width: 10),
                      Text(
                        '${state.investments.length} inversión(es) activa(s)',
                        style: textStyles.body.copyWith(
                          color: colors.accentTeal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Sección de fondos ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Row(
                children: [
                  Text('Fondos disponibles', style: textStyles.heading3),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.accentGold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${state.filteredFunds.length}',
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

          // ── Tabs ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: CategoryTabs(selected: state.selectedCategory),
            ),
          ),

          // ── Lista de fondos ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: FundList(
                funds: state.filteredFunds,
                selectedCategory: state.selectedCategory,
                investments: state.investments,
                availableBalance: state.user?.availableBalance ?? 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
