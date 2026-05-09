import 'package:btgproject/domain/repositories/transaction_repository.dart';
import 'package:btgproject/presentation/transactions/bloc/transactions_bloc.dart';
import 'package:btgproject/presentation/transactions/bloc/transactions_event.dart';
import 'package:btgproject/presentation/transactions/pages/transactions_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionsBloc(
        transactionRepository: context.read<TransactionRepository>(),
      )..add(TransactionsLoadRequested()),
      child: const TransactionsView(),
    );
  }
}
