import 'package:btgproject/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

/// Shell principal con BottomNavigationBar premium.
///
/// Envuelve las 3 secciones: Inicio, Mis Fondos, Historial.
class MainShell extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const MainShell({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Scaffold(
      backgroundColor: colors.deepNavy,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.cardDark,
          border: Border(
            top: BorderSide(
              color: colors.surfaceLight.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: FontAwesomeIcons.house,
                  label: 'Inicio',
                  isActive: currentIndex == 0,
                  colors: colors,
                  textStyles: textStyles,
                  onTap: () => context.go('/'),
                ),
                _NavItem(
                  icon: FontAwesomeIcons.wallet,
                  label: 'Mis Fondos',
                  isActive: currentIndex == 1,
                  colors: colors,
                  textStyles: textStyles,
                  onTap: () => context.go('/funds'),
                ),
                _NavItem(
                  icon: FontAwesomeIcons.clockRotateLeft,
                  label: 'Historial',
                  isActive: currentIndex == 2,
                  colors: colors,
                  textStyles: textStyles,
                  onTap: () => context.go('/transactions'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final bool isActive;
  final dynamic colors;
  final dynamic textStyles;
  final VoidCallback onTap;

  const _NavItem({
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
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? colors.accentGold.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 20,
              color: isActive ? colors.accentGold : colors.textMuted,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: textStyles.label.copyWith(
                color: isActive ? colors.accentGold : colors.textMuted,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
