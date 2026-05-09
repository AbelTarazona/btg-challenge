import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_bloc.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryTabs extends StatelessWidget {
  final String selected;

  const CategoryTabs({super.key, required this.selected});

  static const _categories = ['Todos', 'FPV', 'FIC'];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Row(
      children: _categories.map((cat) {
        final isActive = cat == selected;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => context.read<HomeBloc>().add(HomeCategoryChanged(cat)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? colors.accentGold : colors.cardDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isActive
                      ? colors.accentGold
                      : colors.surfaceLight.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: colors.accentGold.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                cat,
                style: textStyles.bodySmall.copyWith(
                  color: isActive ? colors.deepNavy : colors.textSecondary,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
