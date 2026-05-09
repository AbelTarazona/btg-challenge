import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Header extends StatelessWidget {
  final String userName;

  const Header({super.key, required this.userName});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final themeCubit = context.watch<ThemeCubit>();

    return Row(
      children: [
        // Logo
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: colors.goldGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: colors.accentGold.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'B',
              style: TextStyle(
                color: colors.deepNavy,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_greeting, style: textStyles.bodySmall),
              const SizedBox(height: 2),
              Text(userName, style: textStyles.heading3),
            ],
          ),
        ),
        // Theme toggle
        GestureDetector(
          onTap: () => themeCubit.toggleTheme(),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.cardDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.surfaceLight.withValues(alpha: 0.3),
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => RotationTransition(
                turns: Tween(begin: 0.5, end: 1.0).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: FaIcon(
                themeCubit.isDark
                    ? FontAwesomeIcons.sun
                    : FontAwesomeIcons.moon,
                key: ValueKey(themeCubit.isDark),
                color: themeCubit.isDark
                    ? colors.accentGold
                    : colors.textSecondary,
                size: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Notification bell
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.cardDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.surfaceLight.withValues(alpha: 0.3),
            ),
          ),
          child: FaIcon(
            FontAwesomeIcons.bell,
            color: colors.textSecondary,
            size: 18,
          ),
        ),
      ],
    );
  }
}
