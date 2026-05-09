import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_state.dart';
import 'package:btgproject/presentation/dashboard/widgets/balance_card.dart';
import 'package:btgproject/presentation/dashboard/widgets/category_tabs.dart';
import 'package:btgproject/presentation/dashboard/widgets/fund_list.dart';
import 'package:btgproject/presentation/dashboard/widgets/header.dart';
import 'package:flutter/material.dart';

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

          // ── Sección de fondos ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Row(
                children: [
                  Text('Fondos disponibles', style: textStyles.heading3),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
