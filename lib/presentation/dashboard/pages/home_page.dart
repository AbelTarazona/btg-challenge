import 'package:btgproject/domain/repositories/fund_repository.dart';
import 'package:btgproject/domain/repositories/investment_repository.dart';
import 'package:btgproject/domain/repositories/transaction_repository.dart';
import 'package:btgproject/domain/repositories/user_repository.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_bloc.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_event.dart';
import 'package:btgproject/presentation/dashboard/pages/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        fundRepository: context.read<FundRepository>(),
        userRepository: context.read<UserRepository>(),
        investmentRepository: context.read<InvestmentRepository>(),
        transactionRepository: context.read<TransactionRepository>(),
      )..add(HomeLoadRequested()),
      child: const HomeView(),
    );
  }
}
