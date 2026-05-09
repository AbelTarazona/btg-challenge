import 'package:btgproject/data/datasources/fund_local_datasource.dart';
import 'package:btgproject/data/datasources/user_local_datasource.dart';
import 'package:btgproject/data/repositories/fund_repository_impl.dart';
import 'package:btgproject/data/repositories/user_repository_impl.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_bloc.dart';
import 'package:btgproject/presentation/dashboard/pages/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(
        fundRepository: FundRepositoryImpl(
          dataSource: FundLocalDataSource(),
        ),
        userRepository: UserRepositoryImpl(
          dataSource: UserLocalDataSource(),
        ),
      ),
      child: HomeView(),
    );
  }
}
