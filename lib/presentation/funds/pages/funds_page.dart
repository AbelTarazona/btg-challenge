import 'package:btgproject/domain/repositories/investment_repository.dart';
import 'package:btgproject/domain/repositories/transaction_repository.dart';
import 'package:btgproject/domain/repositories/user_repository.dart';
import 'package:btgproject/presentation/funds/bloc/funds_bloc.dart';
import 'package:btgproject/presentation/funds/bloc/funds_event.dart';
import 'package:btgproject/presentation/funds/pages/funds_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FundsPage extends StatelessWidget {
  const FundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FundsBloc(
        userRepository: context.read<UserRepository>(),
        investmentRepository: context.read<InvestmentRepository>(),
        transactionRepository: context.read<TransactionRepository>(),
      )..add(FundsLoadRequested()),
      child: const FundsView(),
    );
  }
}
