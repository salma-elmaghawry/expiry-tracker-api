import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';

/// The API sends calendar dates as "2027-05-01". Parse them to UTC midnight,
/// so "days left" never shifts with the phone's time zone.
DateTime parseCalendarDate(String value) {
  final date = DateTime.parse(value);
  return DateTime.utc(date.year, date.month, date.day);
}

/// Whole days from today to [expiryDate]. Negative once it has expired.
int daysUntil(DateTime expiryDate, DateTime now) {
  final today = DateTime.utc(now.year, now.month, now.day);
  return expiryDate.difference(today).inDays;
}

/// Same edges as the API dashboard. Null means more than 7 days away.
ExpiryBucket? urgencyFor(int daysLeft) {
  if (daysLeft < 0) return ExpiryBucket.expired;
  if (daysLeft <= 3) return ExpiryBucket.within3Days;
  if (daysLeft <= 7) return ExpiryBucket.within4To7Days;
  return null;
}
