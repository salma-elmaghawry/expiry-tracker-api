import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedBackground;
  final Color selectedForeground;
  final Color selectedBorder;
  final IconData? icon;
  final Color? iconColor;
  final String? count;

  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.selectedBackground,
    required this.selectedForeground,
    required this.selectedBorder,
    this.icon,
    this.iconColor,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = selected ? selectedForeground : colorScheme.onSurface;
    final leadingIcon = icon ?? (selected ? Icons.check_rounded : null);

    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? selectedBackground : Colors.transparent,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? selectedBorder : colorScheme.outline,
          ),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Container(
            height: 40.h,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 13.w),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: 16.r, color: iconColor ?? foreground),
                  horizontalSpace(6),
                ],
                Text(
                  label,
                  style: AppTextStyles.font14ExtraBold.copyWith(
                    color: foreground,
                  ),
                ),
                if (count != null) ...[
                  horizontalSpace(6),
                  Text(
                    count!,
                    style: AppTextStyles.font12Bold.tabular().copyWith(
                      color: foreground.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
