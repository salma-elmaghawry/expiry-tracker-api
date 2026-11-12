import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';

extension StatusColorsLookup on StatusColors {
  StatusTone forStatus(BatchStatus status) => switch (status) {
    BatchStatus.active => active,
    BatchStatus.discounted => discounted,
    BatchStatus.sold => sold,
    BatchStatus.wasted => wasted,
  };

  StatusTone forUrgency(ExpiryBucket? urgency) => switch (urgency) {
    ExpiryBucket.expired => expired,
    ExpiryBucket.within3Days => within3Days,
    ExpiryBucket.within4To7Days => within4To7Days,
    null => later,
  };
}
