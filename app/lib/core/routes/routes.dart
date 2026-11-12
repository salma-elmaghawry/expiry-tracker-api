import 'package:expiry_tracker/core/domain/api_enum.dart';
import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';

class Routes {
  static const String root = '/';
  static const String splash = '/splash';

  static const String dashboard = '/dashboard';
  static const String batches = '/batches';
  static const String addBatch = '/batches/new';
  static const String reports = '/reports';
  static const String settings = '/settings';

  static const String statusParam = 'status';
  static const String urgencyParam = 'urgency';
  static const String fromParam = 'from';
  static const String fromDashboard = 'dashboard';

  static String batchesWith({
    BatchStatus? status,
    ExpiryBucket? urgency,
    bool fromDashboardCard = false,
  }) {
    final query = {
      if (status != null) statusParam: status.apiName,
      if (urgency != null) urgencyParam: urgency.apiName,
      if (fromDashboardCard && urgency != null) fromParam: fromDashboard,
    };
    return Uri(
      path: batches,
      queryParameters: query.isEmpty ? null : query,
    ).toString();
  }
}
