import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/app_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum FactoryTab { create, print }

/// Top bar of the factory portal: factory name + "Create labels / Print preview".
/// A tab with a null callback is shown but can't be pressed.
class FactoryHeader extends StatelessWidget {
  final FactoryTab current;
  final VoidCallback? onCreate;
  final VoidCallback? onPrint;

  const FactoryHeader({
    super.key,
    required this.current,
    this.onCreate,
    this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final title = Row(
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: AppColors.third,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.factory_outlined, color: Colors.white, size: 22.r),
        ),
        horizontalSpace(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'factory.company'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.font17ExtraBold,
              ),
              Text(
                'factory.portal'.tr(),
                style: AppTextStyles.font12Normal.secondary(context),
              ),
            ],
          ),
        ),
      ],
    );

    final nav = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavPill(
          label: 'factory.nav_create'.tr(),
          selected: current == FactoryTab.create,
          onTap: onCreate,
        ),
        horizontalSpace(4),
        _NavPill(
          label: 'factory.nav_print'.tr(),
          selected: current == FactoryTab.print,
          onTap: onPrint,
        ),
      ],
    );

    return Material(
      color: colorScheme.surface,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 14.r),
        child: SafeArea(
          bottom: false,
          // Narrow window: the menu drops under the factory name.
          child: LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth < 640
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [title, verticalSpace(10), nav],
                  )
                : Row(
                    children: [
                      Expanded(child: title),
                      nav,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _NavPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _NavPill({required this.label, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = selected || onTap != null;

    return TextButton(
      onPressed: selected ? null : onTap,
      style: TextButton.styleFrom(
        backgroundColor: selected ? colorScheme.primaryContainer : null,
        foregroundColor: colorScheme.onSurfaceVariant,
        disabledForegroundColor: selected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.45),
        minimumSize: Size(0, 40.r),
        padding: EdgeInsets.symmetric(horizontal: 14.r),
        textStyle: AppTextStyles.font14ExtraBold,
      ),
      child: Semantics(
        selected: selected,
        enabled: enabled,
        child: Text(label),
      ),
    );
  }
}
