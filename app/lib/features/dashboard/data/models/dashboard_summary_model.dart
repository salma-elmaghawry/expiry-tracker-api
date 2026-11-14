import 'package:expiry_tracker/core/domain/expiry.dart';
import 'package:expiry_tracker/features/dashboard/domain/entities/dashboard_summary.dart';

/// Reads JSON like:
/// { "today": "2026-11-12",
///   "expired": { "batchCount": 2, "valuePiasters": 26000 }, ... }
class DashboardSummaryModel {
  final DateTime today;
  final BucketSummary expired;
  final BucketSummary within3Days;
  final BucketSummary within4To7Days;

  const DashboardSummaryModel({
    required this.today,
    required this.expired,
    required this.within3Days,
    required this.within4To7Days,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      today: parseCalendarDate(json['today'] as String),
      expired: _bucket(json['expired']),
      within3Days: _bucket(json['within3Days']),
      within4To7Days: _bucket(json['within4To7Days']),
    );
  }

  static BucketSummary _bucket(Object? json) {
    final map = json as Map<String, dynamic>;
    return BucketSummary(
      batchCount: map['batchCount'] as int,
      valuePiasters: map['valuePiasters'] as int,
    );
  }

  DashboardSummary toEntity() {
    return DashboardSummary(
      today: today,
      expired: expired,
      within3Days: within3Days,
      within4To7Days: within4To7Days,
    );
  }
}
