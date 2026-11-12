import 'package:expiry_tracker/core/injection/injection_container.dart';
import 'package:expiry_tracker/features/batches/presentation/cubit/batches_cubit.dart';
import 'package:expiry_tracker/features/batches/presentation/models/batch_filters.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/batches_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BatchesScreen extends StatelessWidget {
  final BatchFilters filters;

  const BatchesScreen({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BatchesCubit>()..refresh(),
      child: BatchesView(filters: filters),
    );
  }
}
