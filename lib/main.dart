import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'data/datasources/fund_local_datasource.dart';
import 'data/datasources/investment_local_datasource.dart';
import 'data/datasources/transaction_local_datasource.dart';
import 'data/datasources/user_local_datasource.dart';
import 'data/repositories/fund_repository_impl.dart';
import 'data/repositories/investment_repository_impl.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/fund_repository.dart';
import 'domain/repositories/investment_repository.dart';
import 'domain/repositories/transaction_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();

  final userDataSource = UserLocalDataSource();
  final fundDataSource = FundLocalDataSource();
  final investmentDataSource = InvestmentLocalDataSource();
  final transactionDataSource = TransactionLocalDataSource();

  runApp(MyApp(
    userRepository: UserRepositoryImpl(dataSource: userDataSource),
    fundRepository: FundRepositoryImpl(dataSource: fundDataSource),
    investmentRepository:
        InvestmentRepositoryImpl(dataSource: investmentDataSource),
    transactionRepository:
        TransactionRepositoryImpl(dataSource: transactionDataSource),
  ));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final FundRepository fundRepository;
  final InvestmentRepository investmentRepository;
  final TransactionRepository transactionRepository;

  const MyApp({
    super.key,
    required this.userRepository,
    required this.fundRepository,
    required this.investmentRepository,
    required this.transactionRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>.value(value: userRepository),
        RepositoryProvider<FundRepository>.value(value: fundRepository),
        RepositoryProvider<InvestmentRepository>.value(
            value: investmentRepository),
        RepositoryProvider<TransactionRepository>.value(
            value: transactionRepository),
      ],
      child: BlocProvider(
        create: (_) => ThemeCubit(),
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              title: 'BTG Challenge',
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              routerConfig: appRouter,
            );
          },
        ),
      ),
    );
  }
}
