import 'package:expiry_tracker/core/injection/injection_container.dart';
import 'package:expiry_tracker/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:expiry_tracker/features/dashboard/presentation/widgets/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardCubit>()..load(),//inj
      child: const DashboardView(),
    );
  }
}
