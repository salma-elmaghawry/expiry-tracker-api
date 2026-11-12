import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/const/app_breakpoints.dart';
import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/routes/routes.dart';
import 'package:expiry_tracker/features/batches/presentation/cubit/batches_cubit.dart';
import 'package:expiry_tracker/features/batches/presentation/cubit/batches_state.dart';
import 'package:expiry_tracker/features/batches/presentation/models/batch_filters.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/batches_body.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/batches_filter_bar.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/batches_header.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/dashboard_filter_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BatchesView extends StatefulWidget {
  final BatchFilters filters;

  const BatchesView({super.key, required this.filters});

  @override
  State<BatchesView> createState() => _BatchesViewState();
}

class _BatchesViewState extends State<BatchesView> {
  static const double _wideContentWidth = 760;

  final _searchController = TextEditingController();
  bool _searching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setSearching(bool searching) {
    setState(() {
      _searching = searching;
      if (!searching) _searchController.clear();
    });
  }

  void _goTo({
    BatchStatus? status,
    ExpiryBucket? urgency,
    bool fromDashboard = false,
  }) {
    context.go(
      Routes.batchesWith(
        status: status,
        urgency: urgency,
        fromDashboardCard: fromDashboard,
      ),
    );
  }

  void _clearAll() {
    if (_searching) _setSearching(false);
    _goTo();
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    final filters = widget.filters;
    final isWide = MediaQuery.sizeOf(context).width >= AppBreakpoints.wide;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWide ? _wideContentWidth : double.infinity,
            ),
            child: BlocBuilder<BatchesCubit, BatchesState>(
              buildWhen: (previous, current) =>
                  previous.batches != current.batches ||
                  previous.hasLoaded != current.hasLoaded ||
                  previous.fetchFailed != current.fetchFailed,
              builder: (context, state) {
                final showFilters =
                    !(state.batches.isEmpty &&
                        (state.fetchFailed || state.hasLoaded));

                return Column(
                  children: [
                    BatchesHeader(
                      total: state.batches.length,
                      searching: _searching,
                      searchController: _searchController,
                      onSearchChanged: (_) => setState(() {}),
                      onToggleSearch: () => _setSearching(!_searching),
                    ),
                    if (showFilters) ...[
                      BatchesFilterBar(
                        filters: filters,
                        batches: state.batches,
                        onStatusSelected: (status) => _goTo(
                          status: status,
                          urgency: filters.urgency,
                          fromDashboard: filters.fromDashboard,
                        ),
                        onUrgencySelected: (urgency) =>
                            _goTo(status: filters.status, urgency: urgency),
                      ),
                      if (filters.showsDashboardBanner)
                        DashboardFilterBanner(
                          filters: filters,
                          batches: state.batches,
                          onClear: () => _goTo(status: filters.status),
                        ),
                    ],
                    SizedBox(height: 4.h),
                    Expanded(
                      child: BatchesBody(
                        filters: filters,
                        query: _searchController.text,
                        onClearFilters: _clearAll,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<BatchesCubit, BatchesState>(
        buildWhen: (previous, current) =>
            previous.fetchFailed != current.fetchFailed ||
            previous.batches.isEmpty != current.batches.isEmpty,
        builder: (context, state) {
          if (state.fetchFailed && state.batches.isEmpty) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            onPressed: () => context.push(Routes.addBatch),
            icon: const Icon(Icons.add_rounded),
            label: Text('batches.add'.tr()),
          );
        },
      ),
    );
  }
}
