import 'package:btgproject/presentation/dashboard/pages/home_page.dart';
import 'package:btgproject/presentation/funds/pages/funds_page.dart';
import 'package:btgproject/presentation/shell/main_shell.dart';
import 'package:btgproject/presentation/transactions/pages/transactions_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // Determine current index from location
        final location = state.uri.path;
        int currentIndex = 0;
        if (location.startsWith('/funds')) {
          currentIndex = 1;
        } else if (location.startsWith('/transactions')) {
          currentIndex = 2;
        }
        return MainShell(
          currentIndex: currentIndex,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/funds',
          name: 'funds',
          builder: (context, state) => const FundsPage(),
        ),
        GoRoute(
          path: '/transactions',
          name: 'transactions',
          builder: (context, state) => const TransactionsPage(),
        ),
      ],
    ),
  ],
);
