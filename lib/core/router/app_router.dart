import 'package:btgproject/presentation/dashboard/home_page.dart';
import 'package:btgproject/presentation/funds/pages/funds_page.dart';
import 'package:btgproject/presentation/transactions/pages/transactions_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
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
);
