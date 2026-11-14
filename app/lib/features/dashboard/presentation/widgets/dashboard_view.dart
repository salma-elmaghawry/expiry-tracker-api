import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/animations/animations.dart';
import 'package:expiry_tracker/core/const/app_breakpoints.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/helpers/ui_helpers.dart';
import 'package:expiry_tracker/core/routes/routes.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/core/widgets/loading_filled_button.dart';
import 'package:expiry_tracker/core/widgets/state_view.dart';
import 'package:expiry_tracker/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:expiry_tracker/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:expiry_tracker/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:expiry_tracker/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:expiry_tracker/features/dashboard/presentation/widgets/needs_action_list.dart';
import 'package:expiry_tracker/features/dashboard/presentation/widgets/urgency_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DashboardView extends StatelessWidget {
  static const double _wideContentWidth = 1100;

  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _wideContentWidth),
            child: BlocConsumer<DashboardCubit, DashboardState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status &&
                  (current.action == DashboardAction.loadDemo ||
                      (current.fetchFailed && current.summary != null)),
              listener: (context, state) {
                if (state.isFailure) {
                  showAppSnackBar(context, state.message ?? '', isError: true);
                }
              },
              builder: (context, state) {
                final summary = state.summary;
                if (summary == null) {
                  if (state.fetchFailed) return _errorView(context, state);
                  return const DashboardSkeleton();
                }
                if (!state.hasAnyBatches) return _emptyView(context, state);
                return _content(context, state, summary);
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.push(kIsWeb ? Routes.addBatch : Routes.receiveCarton),
        icon: Icon(kIsWeb ? Icons.add_rounded : Icons.qr_code_scanner_rounded),
        label: Text((kIsWeb ? 'batches.add' : 'receive.button').tr()),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    DashboardState state,
    DashboardSummary summary,
  ) {
    final isWide = MediaQuery.sizeOf(context).width >= AppBreakpoints.wide;
    final cubit = context.read<DashboardCubit>();

    final cards = [
      for (final bucket in ExpiryBucket.values)
        UrgencyCard(
          bucket: bucket,
          summary: summary.of(bucket),
          onTap: () => context.go(
            Routes.batchesWith(urgency: bucket, fromDashboardCard: true),
          ),
        ),
    ];

    return RefreshIndicator(
      onRefresh: cubit.load,
      child: ListView(
        // Room at the bottom so the FAB never covers the last row.
        padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 96.h),
        children: [
          _header(context, summary),
          verticalSpace(16),
          Text(
            'dashboard.overview'.tr(),
            style: AppTextStyles.font13ExtraBold.secondary(context),
          ),
          verticalSpace(8),
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < cards.length; i++) ...[
                  if (i > 0) horizontalSpace(16),
                  Expanded(child: cards[i]),
                ],
              ],
            )
          else
            for (final card in cards) ...[card, verticalSpace(12)],
          verticalSpace(16),
          NeedsActionList(batches: state.needsAction),
        ].animateList(),
      ),
    );
  }

  Widget _header(BuildContext context, DashboardSummary summary) {
    final locale = context.locale.languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('nav.dashboard'.tr(), style: AppTextStyles.font22ExtraBold),
        Text(
          DateFormat.yMMMMEEEEd(locale).format(summary.today),
          style: AppTextStyles.font13SemiBold.secondary(context),
        ),
      ],
    );
  }

  Widget _emptyView(BuildContext context, DashboardState state) {
    final colorScheme = Theme.of(context).colorScheme;
    return StateView(
      icon: Icons.space_dashboard_outlined,
      iconBackground: colorScheme.primaryContainer,
      iconColor: colorScheme.onPrimaryContainer,
      title: 'dashboard.empty.title'.tr(),
      body: 'dashboard.empty.body'.tr(),
      actions: [
        LoadingFilledButton(
          label: 'dashboard.load_demo'.tr(),
          icon: Icons.auto_awesome_outlined,
          isLoading: state.isLoadingDemo,
          onPressed: context.read<DashboardCubit>().loadDemoData,
        ),
      ],
    );
  }

  Widget _errorView(BuildContext context, DashboardState state) {
    final isNetwork = state.failure is NetworkFailure;
    final tone = context.statusColors.expired;
    return StateView(
      icon: Icons.wifi_off_rounded,
      iconBackground: tone.background,
      iconColor: tone.accent,
      title: isNetwork
          ? 'batches.error.title'.tr()
          : 'errors.something_wrong'.tr(),
      body: isNetwork ? 'batches.error.body'.tr() : state.message,
      actions: [
        FilledButton.icon(
          onPressed: context.read<DashboardCubit>().load,
          icon: const Icon(Icons.refresh_rounded),
          label: Text('common.retry'.tr()),
        ),
      ],
    );
  }
}
