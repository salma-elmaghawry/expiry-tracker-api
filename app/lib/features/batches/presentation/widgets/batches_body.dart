import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/helpers/ui_helpers.dart';
import 'package:expiry_tracker/core/injection/injection_container.dart';
import 'package:expiry_tracker/core/network/api_config.dart';
import 'package:expiry_tracker/core/routes/routes.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/core/widgets/state_view.dart';
import 'package:expiry_tracker/features/batches/presentation/cubit/batches_cubit.dart';
import 'package:expiry_tracker/features/batches/presentation/cubit/batches_state.dart';
import 'package:expiry_tracker/features/batches/presentation/models/batch_filters.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/batches_list.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/batches_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BatchesBody extends StatelessWidget {
  final BatchFilters filters;
  final String query;
  final VoidCallback onClearFilters;

  const BatchesBody({
    super.key,
    required this.filters,
    required this.query,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BatchesCubit, BatchesState>(
      listenWhen: (previous, current) =>
          current.fetchFailed && current.batches.isNotEmpty,
      listener: (context, state) =>
          showAppSnackBar(context, state.message ?? '', isError: true),
      builder: (context, state) {
        final cubit = context.read<BatchesCubit>();

        if (state.batches.isEmpty) {
          if (state.fetchFailed) return _errorView(context, state.failure);
          if (!state.hasLoaded) return const BatchesSkeleton();
          return _emptyView(context);
        }

        final visible = BatchFilters.sortForDisplay(
          filters.apply(state.batches, DateTime.now(), query),
        );
        if (visible.isEmpty) return _noMatchView(context);

        return BatchesList(batches: visible, onRefresh: cubit.refresh);
      },
    );
  }

  Widget _errorView(BuildContext context, Failure? failure) {
    final isNetwork = failure is NetworkFailure;
    final tone = context.statusColors.expired;
    final server = Uri.tryParse(getIt<ApiConfig>().baseUrl)?.authority ?? '';

    return StateView(
      icon: Icons.wifi_off_rounded,
      iconBackground: tone.background,
      iconColor: tone.accent,
      title: isNetwork
          ? 'batches.error.title'.tr()
          : 'errors.something_wrong'.tr(),
      body: isNetwork ? 'batches.error.body'.tr() : failure?.message,
      actions: [
        FilledButton.icon(
          onPressed: context.read<BatchesCubit>().refresh,
          icon: const Icon(Icons.refresh_rounded),
          label: Text('common.retry'.tr()),
        ),
        TextButton(
          onPressed: () => context.go(Routes.settings),
          child: Text(
            'batches.error.server'.tr(args: [server]),
            style: AppTextStyles.font13Medium
                .secondary(context)
                .copyWith(decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }

  Widget _emptyView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return StateView(
      icon: Icons.inventory_2_outlined,
      iconBackground: colorScheme.primaryContainer,
      iconColor: colorScheme.onPrimaryContainer,
      title: 'batches.empty.title'.tr(),
      body: 'batches.empty.body'.tr(),
      actions: [
        FilledButton.icon(
          onPressed: () => context.push(Routes.addBatch),
          icon: const Icon(Icons.add_rounded),
          label: Text('batches.add'.tr()),
        ),
        TextButton(
          onPressed: () => context.go(Routes.settings),
          child: Text('batches.empty.load_demo'.tr()),
        ),
      ],
    );
  }

  Widget _noMatchView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return StateView(
      icon: Icons.search_off_rounded,
      iconSize: 64,
      iconBackground: colorScheme.surfaceContainerHighest,
      iconColor: colorScheme.onSurfaceVariant,
      title: 'batches.no_match'.tr(),
      actions: [
        OutlinedButton(
          onPressed: onClearFilters,
          child: Text('batches.clear_filters'.tr()),
        ),
      ],
    );
  }
}
