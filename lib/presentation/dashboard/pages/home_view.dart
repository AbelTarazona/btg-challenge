import 'package:btgproject/core/theme/app_theme.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_bloc.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_event.dart';
import 'package:btgproject/presentation/dashboard/bloc/home_state.dart';
import 'package:btgproject/presentation/dashboard/pages/home_error_view.dart';
import 'package:btgproject/presentation/dashboard/pages/home_success_view.dart';
import 'package:btgproject/presentation/dashboard/widgets/home_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.deepNavy,
      body: Container(
        decoration: BoxDecoration(
          gradient: colors.backgroundGradient,
        ),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return switch (state.status) {
              HomeStatus.initial || HomeStatus.loading => const HomeShimmer(),
              HomeStatus.error => HomeErrorView(
                message: state.errorMessage ?? 'Error desconocido',
                onRetry: () => context.read<HomeBloc>().add(HomeLoadRequested()),
              ),
              HomeStatus.success => HomeSuccessView(state: state),
            };
          },
        ),
      ),
    );
  }
}
