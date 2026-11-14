import 'package:equatable/equatable.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';

/// One urgency card: how many open batches, and their value at cost.
class BucketSummary extends Equatable {
  final int batchCount;
  final int valuePiasters;

  const BucketSummary({required this.batchCount, required this.valuePiasters});

  @override
  List<Object?> get props => [batchCount, valuePiasters];
}

/// What GET /api/dashboard returns. The three buckets never overlap.
class DashboardSummary extends Equatable {
  final DateTime today;
  final BucketSummary expired;
  final BucketSummary within3Days;
  final BucketSummary within4To7Days;

  const DashboardSummary({
    required this.today,
    required this.expired,
    required this.within3Days,
    required this.within4To7Days,
  });

  BucketSummary of(ExpiryBucket bucket) => switch (bucket) {
    ExpiryBucket.expired => expired,
    ExpiryBucket.within3Days => within3Days,
    ExpiryBucket.within4To7Days => within4To7Days,
  };

  @override
  List<Object?> get props => [today, expired, within3Days, within4To7Days];
}
