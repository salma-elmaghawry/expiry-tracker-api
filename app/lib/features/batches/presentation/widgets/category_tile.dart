import 'package:expiry_tracker/core/domain/enums/category.dart';
import 'package:expiry_tracker/core/helpers/enum_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final bool muted;

  const CategoryTile({super.key, required this.category, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: muted
            ? colorScheme.surfaceContainerHighest
            : colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        category.icon,
        size: 22.r,
        color: muted
            ? colorScheme.onSurfaceVariant
            : colorScheme.onPrimaryContainer,
      ),
    );
  }
}
