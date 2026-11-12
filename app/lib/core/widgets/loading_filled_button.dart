import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingFilledButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;

  const LoadingFilledButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = backgroundColor ?? colorScheme.primary;
    final foreground = foregroundColor ?? colorScheme.onPrimary;

    final style = FilledButton.styleFrom(
      minimumSize: Size.fromHeight(height.h),
      backgroundColor: background,
      foregroundColor: foreground,
      disabledBackgroundColor: isLoading ? background : null,
      disabledForegroundColor: isLoading ? foreground : null,
    );

    if (isLoading) {
      return FilledButton(
        onPressed: null,
        style: style,
        child: SizedBox.square(
          dimension: 22.r,
          child: CircularProgressIndicator(strokeWidth: 2.4, color: foreground),
        ),
      );
    }

    if (icon == null) {
      return FilledButton(
        onPressed: onPressed,
        style: style,
        child: Text(label),
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      style: style,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
