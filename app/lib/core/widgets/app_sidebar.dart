import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/animations/animations.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/core/widgets/app_logo.dart';
import 'package:expiry_tracker/core/widgets/shell_destination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  Widget _item(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: _SidebarItem(
        destination: shellDestinations[index],
        selected: index == selectedIndex,
        onTap: () => onSelected(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mainIndexes = [
      for (final (index, destination) in shellDestinations.indexed)
        if (!destination.pinnedToBottom) index,
    ];
    final bottomIndexes = [
      for (final (index, destination) in shellDestinations.indexed)
        if (destination.pinnedToBottom) index,
    ];

    return Container(
      width: 256.w,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: BorderDirectional(
          end: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SidebarBrand().fadeInSlideUp(),
              verticalSpace(32),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 12.w, bottom: 8.h),
                child: Text(
                  'nav.menu'.tr(),
                  style: AppTextStyles.font12SemiBold.secondary(context),
                ),
              ),
              ...[for (final index in mainIndexes) _item(index)].animateList(),
              const Spacer(),
              const Divider(),
              verticalSpace(12),
              for (final index in bottomIndexes) _item(index),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarBrand extends StatelessWidget {
  const _SidebarBrand();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppLogo(size: 40),
        horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'app_name'.tr(),
                style: AppTextStyles.font16Bold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'app_tagline'.tr(),
                style: AppTextStyles.font12Medium.secondary(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final ShellDestination destination;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered != value) setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = widget.selected;

    final background = selected
        ? colorScheme.primaryContainer
        : _hovered
        ? colorScheme.surfaceContainerHigh
        : Colors.transparent;
    final iconColor = selected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;
    final labelColor = selected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface;

    return Semantics(
      button: true,
      selected: selected,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: AnimatedTap(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: AppAnimations.fast,
            curve: AppAnimations.defaultCurve,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 12.w,
              vertical: 11.h,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  selected
                      ? widget.destination.selectedIcon
                      : widget.destination.icon,
                  size: 22.r,
                  color: iconColor,
                ),
                horizontalSpace(12),
                Expanded(
                  child: Text(
                    widget.destination.labelKey.tr(),
                    style:
                        (selected
                                ? AppTextStyles.font14SemiBold
                                : AppTextStyles.font14Medium)
                            .copyWith(color: labelColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
