import 'package:equatable/equatable.dart';
import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';

class BatchFilters extends Equatable {
  final BatchStatus? status;
  final ExpiryBucket? urgency;
  final bool fromDashboard;

  const BatchFilters({this.status, this.urgency, this.fromDashboard = false});

  bool get hasAny => status != null || urgency != null;

  bool get showsDashboardBanner => fromDashboard && urgency != null;

  List<Batch> apply(List<Batch> batches, DateTime now, String query) {
    final search = query.trim().toLowerCase();
    return [
      for (final batch in batches)
        if (_matches(batch, now, search)) batch,
    ];
  }

  bool _matches(Batch batch, DateTime now, String search) {
    if (status != null && batch.status != status) return false;
    if (urgency != null && batch.urgencyOn(now) != urgency) return false;
    if (search.isEmpty) return true;
    return batch.productName.toLowerCase().contains(search) ||
        (batch.barcode?.contains(search) ?? false);
  }

  static List<Batch> sortForDisplay(List<Batch> batches) {
    int byExpiry(Batch a, Batch b) => a.expiryDate.compareTo(b.expiryDate);
    return [
      ...batches.where((batch) => batch.isOpen).toList()..sort(byExpiry),
      ...batches.where((batch) => !batch.isOpen).toList()..sort(byExpiry),
    ];
  }

  @override
  List<Object?> get props => [status, urgency, fromDashboard];
}
