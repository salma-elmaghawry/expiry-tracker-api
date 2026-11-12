import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/domain/enums/batch_action_type.dart';
import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/category.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/domain/enums/waste_reason.dart';

extension CategoryLabel on Category {
  String get label => 'categories.$name'.tr();
}

extension BatchStatusLabel on BatchStatus {
  String get label => 'batch_status.$name'.tr();
}

extension WasteReasonLabel on WasteReason {
  String get label => 'waste_reasons.$name'.tr();
}

extension ExpiryBucketLabel on ExpiryBucket {
  String get label => 'buckets.$name'.tr();
}

extension BatchActionTypeLabel on BatchActionType {
  String get label => 'batches.actions.$name'.tr();
}
