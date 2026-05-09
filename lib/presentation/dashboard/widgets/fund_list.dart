import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/domain/entities/fund.dart';
import 'package:btgproject/domain/entities/investment.dart';
import 'package:btgproject/presentation/dashboard/widgets/subscribe_bottom_sheet.dart';

import 'fund_card.dart';

class FundList extends StatelessWidget {
  final List<Fund> funds;
  final String selectedCategory;
  final List<Investment> investments;
  final double availableBalance;

  const FundList({
    super.key,
    required this.funds,
    required this.selectedCategory,
    this.investments = const [],
    this.availableBalance = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (funds.isEmpty) {
      return _EmptyState(category: selectedCategory);
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: funds.length,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final fund = funds[index];
        final isSubscribed =
            investments.any((inv) => inv.fundId == fund.id);
        return FundCard(
          fund: fund,
          isSubscribed: isSubscribed,
          onTap: () {
            SubscribeBottomSheet.show(
              context,
              fund: fund,
              availableBalance: availableBalance,
            );
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String category;

  const _EmptyState({required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: colors.cardDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.surfaceLight.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          FaIcon(
            FontAwesomeIcons.folderOpen,
            size: 36,
            color: colors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            'No hay fondos $category disponibles',
            style: textStyles.subtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
