import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/category.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:flutter/material.dart';

extension CategoryIcon on Category {
  IconData get icon => switch (this) {
    Category.dairy => Icons.local_drink_outlined,
    Category.bakery => Icons.bakery_dining_outlined,
    Category.meatAndPoultry => Icons.kebab_dining_outlined,
    Category.fruitsAndVegetables => Icons.eco_outlined,
    Category.frozen => Icons.ac_unit_rounded,
    Category.beverages => Icons.local_cafe_outlined,
    Category.snacks => Icons.cookie_outlined,
    Category.grocery => Icons.local_grocery_store_outlined,
    Category.other => Icons.category_outlined,
  };
}

extension BatchStatusIcon on BatchStatus {
  IconData get icon => switch (this) {
    BatchStatus.active => Icons.radio_button_checked_rounded,
    BatchStatus.discounted => Icons.sell_outlined,
    BatchStatus.sold => Icons.check_circle_outline_rounded,
    BatchStatus.wasted => Icons.delete_outline_rounded,
  };
}

extension ExpiryBucketIcon on ExpiryBucket {
  IconData get icon => switch (this) {
    ExpiryBucket.expired => Icons.report_outlined,
    ExpiryBucket.within3Days => Icons.schedule_rounded,
    ExpiryBucket.within4To7Days => Icons.calendar_today_outlined,
  };
}

const IconData laterUrgencyIcon = Icons.check_rounded;
